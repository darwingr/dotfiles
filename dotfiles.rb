#!/usr/bin/env ruby
#!/usr/bin/env rbenv exec ruby
#
# dotfiles
#   links the dotfiles into home folder
#
# Requires ruby 2.5
#     - Dir.children    (try Pathname?)
#       Use instead: Dir.entries('testdir') - [".", ".."]
#     - Array.filter
#   Should be prepared to work with ruby 2.0.0p648 (2015-12-16 revision 53162)
#   since without dotfiles only mac system ruby might be available.

require 'fileutils'
require 'pathname'

excluded = [
  '.DS_Store',
  '.git',
  '.gitignore',
  '.rbenv',
  '.ruby-version',
  'tags',
  'bootstrap.sh',
  'dotfiles',
  'dotfiles.c',
  'dotfiles.rb',
  'Brewfile.migrating',
  'Brewfile.old',
  '.vimrc.solarized',
  'ruby'
]

# Save the dotfiles directory for searching (current script folder)
dotfile_dir = Dir.new __dir__

class Dotfile
  def initialize(dotfile_dir, dotfile_pathname)
    @dotfiles_rel_path = dotfile_dir.path.delete_prefix(Dir.home + '/')
    @target_path = '.' +  dotfile_pathname

    prefix = './' + @dotfiles_rel_path + '/'
    # prepend an extra dot for dotfiles in subfolders
    prefix = '.' + prefix if File.fnmatch('*/*', dotfile_pathname)
    @source_path = prefix + dotfile_pathname
    # TODO verify source is valid
    # core assertion: the source exists
  end

  # What works manually (very flexible approach): Sep 27th, 2019
  #   cd ~  # only 1 cd is necessary
  #   # ln -s source target
  #   ln -s ./Dropbox/dotfiles/vimrc .vimrc
  #   ln -fs ../Dropbox/dotfiles/vim/autoload .vim/autoload
  #
  # preconditions:
  #   - source exists
  #   - target link does not exist
  #       e1: target is link and source is expected value
  #       e2: target will not bet overwritten
  # ln_s(target, link, force: nil, noop: nil, verbose: nil)
  #   creates symbolic link 'link' which points to 'target'
  def make_symlink
    begin
      FileUtils.ln_s @source_path, @target_path, verbose: true, force: false
    rescue Errno::EEXIST
      actual_source_path = Pathname(@target_path).readlink.to_s
      if ! actual_source_path.eql? @source_path
        puts "\tNOTE: symlink exists with unexpected src path #{actual_source_path}"
        puts "\t                             was expecting #{@source_path}"
      else
        # Do Nothing
      end
    end
  end

  def basepath
    target_path
  end

  def print_paths
    puts "\tsrc: #{@source_path}"
    puts "\t target:#{' ' * @dotfiles_rel_path.size}#{@target_path}"
  end

  private
  attr_reader :dotfiles_rel_path, :source_path, :target_path
end

# Get a list of folders to create in home folder
required_home_subfolders = dotfile_dir
  .children
  .difference(excluded)
  .filter {|pn| File.directory? pn }

dotfile_pathnames = dotfile_dir
  .children
  .difference(excluded)
  .difference(required_home_subfolders)
  .delete_if {|basename| basename.match(/\.swp$/) }
  .concat( Dir.glob(required_home_subfolders.map {|f| f+'/*'},
                    base: dotfile_dir.path))
#puts '# Dotfiles Pathnames:'
#puts dotfile_pathnames
#puts

# Get a list of dotfile objects, with target and source paths
dotfiles = dotfile_pathnames.map { |pn| Dotfile.new dotfile_dir, pn }
dotfiles.sort_by! { |df| df.basepath }


def existing_dotfile_links
  dotfiles_found = []
  Pathname(Dir.home).glob(['.*', '.*/*']) do |pn|
    if pn.symlink? && pn.readlink.fnmatch?('**/dotfiles/**', File::FNM_DOTMATCH)
      dotfiles_found.push pn
    end
  end
  dotfiles_found
end

# Get a list of dead symlinks
def dead_dotfile_links
  # strip the leading '../' off link sources
  existing_dotfile_links.filter do |pn|
    relative_link_src = pn.readlink.sub('../', '')
    ! relative_link_src.exist?
  end
end


# Need to:
# x - get list of required home subfolders
# x - get list of root dotfile source paths (relative to ~, filter excludes, prefix ./)
# x   + get list of dotfiles/folders from 1 level down in project (prefix ../)
# x   + get list of dotfile target paths relative to ~,
#     + get list of existing dotfile symlinks (matching from source list)
#   - get list of existing dead dotfile symlinks (is symlink, is broken and
#         has 'dotfile' in file path)
#   - delete dead dotfiles
# x - make target folders
#   - make new relative symlinks for non-existant & dead symlinks

#if ARGV.length != 0 || ARGV[0] != '-x'
if ARGV[0] != '-x'
  puts "# SAFE MODE: nothing will be over/written."
  puts "# Ruby Version: #{RUBY_VERSION}"
  puts '# Dotfile Objects Registered:'
  #dotfiles.each {|df| df.print_paths }
  dotfiles.each {|df| puts df.basepath }
  puts "\n# Run again with '-x' to execute the operation.\n"
  exit 0
end

# Save the initial pwd to return to it on exit regardless of success.
initial_dir = Dir.pwd
begin
  # Want to have very flexible relative symbolic links,
  #   so we need to be in the home directory ln to create the correct path,
  #   and all sub-directories must exist before linking.
  FileUtils.cd      Dir.home, verbose: true
  FileUtils.mkdir_p required_home_subfolders.map {|dir| "." + dir },
                    verbose: true

  # Want to clean out dead links before linking,
  #   so the user needs to be warned about deletions to avoid later confusion.
  puts "#  Dead Links to remove:"
  puts dead_dotfile_links.map {|pn| "rm #{pn.realpath} -> #{pn.readlink}" }
  FileUtils.rm dead_dotfile_links, verbose: true

  dotfiles.each { |df| df.make_symlink }
ensure
  # Return to initial dir for any failure
  FileUtils.cd initial_dir, verbose: true
end
