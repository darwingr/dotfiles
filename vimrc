" My VimRC
" vim:foldmethod=marker:ft=vim:
"   Darwin J Groskleg
" Folding Hint:
"   zo - opens fold at cursor
"   zO - opens all folds at cursor
"   zc - closes fold at cursor
"   zM - closes all open folds
"   zm - increase foldlevel by one
"   zr - decrease foldlevel by one
"   zR - decrease all foldlevel to zero (all folds open)

" sources VundleToPlug
"   if  bundle file exists
if filereadable(expand("~/.vimrc.bundles"))
  let g:PluginFileLoaded=1 " allow script to override while sourcing
  source ~/.vimrc.bundles
else
  let g:PluginFileLoaded=0
endif

"{{{ Portable Basics

" Disables vi compatible mode, enabling more features
set nocompatible

" Set leader key, a prefix for user custom shortcuts
let mapleader = " "

" Still undecided about these
" set nobackup
" set nowritebackup
" set noswapfile
set undodir=~/.vim/undodir
set undofile      " Maintain undo history between sessions

set history=1000
set showcmd
set autowrite     " Automatically :write before running commands

set ruler         " show the cursor position all the time
set number
set scrolloff=4   " Minimal number of screen line to keep above and below cursor

set incsearch     " do incremental searching,     hit n for next result
set hlsearch      " turns on search highlighting, C-r for last search
set ignorecase    " search case insensitive, required for smartcase.
set smartcase     " case-insensitive search via / & ? unless capitals used

" Vim Command AutoCompletion Requirements:
"   Use arrows/ctrl-n to navigate wildmenu, like YCM.
"   Uses tab key. Each click as follows:
"   1. autocomplete to first full match, for speed
"       NOT -> longest COMMON match, to find roughly
"     list alternatives if any (for fuzzy finding)
"     matched word is highlighted in list
"     wildmenu lists horizontally in status bar to save screen space
"   2. cycle alternative matches
set wildmenu
set wildmode=full
" Does not highlight first match if multiple on first tab!
"set wildmode=longest:full,full " 1T: match or menu, 2T: select, 3T: cycle
"set wildmode=longest,list,full " 1 tab to complete, 2 tab to list, 3 to cycle
" NOTE the */ is required before each directory
set wildignore+=*/tmp/*,*/.git/*,*/.svn/*
set wildignore+=*.so,*.swp,*.zip,*.o,*.obj,*.a,*.d,*.dep
set wildignore+=tags,compile_commands.json
" Less heavy handed than wildignore
"   default is ".bak,~,.o,.h,.info,.swp,.obj"
set suffixes+=,,    " deprioritize matching extensionless file names, binaries

" Search path
"   Where header files are found (via :find commands).
"   Default: path=.,/usr/include,,
"   NB: preceeding relative path with ./ will search relative to the current
"       file, omitting the ./ searches relative to CWD.
"   Test missing headers using :checkpath
"   See :help file-searching
set path=.,include,,
"        | |         +-- relative to CURRENT DIRECTORY (project root),
"        | |              empty string between 2 commas
"        | +-- project's include directory (where CWD == project root),
"        |      up to 2 folders deep
"        +-- relative to the directory of the CURRENT FILE (sibling)
" Use path on include line for headers in subfolders
set path+=/usr/local/include,/usr/include
set path+=/usr/include/c++/*    " base folder of the c++ headers

" Required for included headers that include headers themselves.
set path+=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/8.0.0/include
" Required for missing declarations in default algorithms library
set path+=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
" nope, didn't help. Still can't find iostream (doens't recognize cout) and
" doesn't recognize next_permutation from algorithm.

" Height of the command bar
set cmdheight=1

" Show matching brackets when text indicator is over them
set showmatch

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" jump xml tags
runtime macros/matchit.vim

" Use the patience algorithm for easier to read diffs
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
" :verbose set fo?
"   to troubleshoot
setlocal formatoptions-=t formatoptions+=croql

" Lazy load built in man page plugin, which was calling uname.
" https://github.com/dstein64/dotfiles/blob/30b73acf9a97ff2abc8498d8672a0bc2ed341b01/packages/vim/.vimrc#L67-L69
silent! command -nargs=* Man
      \ delcommand Man |
      \ runtime ftplugin/man.vim "|
      \ Man <args>
"runtime ftplugin/man.vim  " required for viewing man page within vim

" Fix Man shortcut for MacVim (built-in macro)
if has("gui_running")
  " NOTE: lookup cmdline ctrl shortcuts like this :help c_CTRL-U
  "   See Man for opening in v/split or a new tab
  nnoremap K :<C-U>execute "Man" v:count "<C-R><C-W>"<CR>
  "             |          |      |         |    |   |
  "             |          |      |         |    |   +-- carriage return
  "             |          |      |         +----+-- word under cursor
  "             |          |      |                   C-R current cursor
  "             |          |      |                   C-W for word
  "             |          |      +-- optional man section number
  "             |          +-- builtin command finding and viewing man pages
  "             +-- removes the visual selection range that may be inserted
endif

" No Error Bell
set noerrorbells visualbell t_vb=
"if has('autocmd')
"  autocmd GUIEnter * set visualbell t_vb=
"endif
"
" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Copy/Paste with system clipboard
"set clipboard=unnamedplus
"if has("unix")
"    let s:uname = system("uname")
"    if s:uname == "Darwin\n"
"        set clipboard=unnamed
"    endif
"endif

function! InitializeDirectories()
  " swapdir
  " backupdir
  let directoryList = [
  \   &undodir,
  \   &viewdir
  \ ]

  for vimdir in directoryList
    if !isdirectory(vimdir)
      silent !clear
      execute "!mkdir " . vimdir
    endif

    if !isdirectory(vimdir)
      echo "Warning: Unable to create backup directory: " . vimdir
      echo "Try: mkdir -p " . vimdir
    endif
  endfor
endfunction
" call InitializeDirectories()

"}}} Portable Basics

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ autocmd Groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has ('autocmd') " Remain compatible with earlier versions
augroup vimrcEx
  autocmd!

  " Save on losing focus
  "   Don't warn about errors
  autocmd FocusLost * silent! wa

  " DROPBOX
  autocmd BufNewFile,BufRead *
    \ if expand('%:~') =~ '^\~/Dropbox' |
    \   set noswapfile |
    \ else |
    \   set swapfile |
    \ endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  "   Commands to list filetypes:
  "     echo glob($VIMRUNTIME . '/ftplugin/*.vim')
  "     echo glob($VIMRUNTIME . '/syntax/*.vim')
  "   https://codeyarns.com/2015/03/19/how-to-list-filetypes-in-vim/
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  "autocmd BufRead,BufNewFile Ruby set filetype=ruby
  " ...setup rspec mappings

  " if no filetype specified, set ft=markdown (alternative would be text)
  " NOTE: causes issues with gitignore and is maybe not a reasonable default
  "       Set the filetype manually if you don't want to save the file.
  "autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

  " Recognize markdown files
  autocmd BufRead,BufNewFile *.markdown,*.md set filetype=markdown
  autocmd FileType markdown
    \   setlocal conceallevel=0
    \ | setlocal formatoptions-=t            " Disable line wrapping
  autocmd FileType markdown,tex,gitcommit
    \   setlocal spell  " Turn on spell check
    \ | setlocal spell spelllang="en_CA,en_US,fr,medical"   " Region preference
    \ | setlocal complete+=kspell    " dict to end of sources for autocomplete
  autocmd BufRead,BufNewFile,BufReadPost .{jscs,jshint,eslint}rc
    \   set filetype=json
    \ | setlocal conceallevel=0

  " 4 spaces for C++, java, python, assembly (check with :set filetype?)
  autocmd FileType c,cpp,java,asm,make
    \ setlocal shiftwidth=4 tabstop=4
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 "et
  " Tabs not spaces
  autocmd FileType plist,xml " vim-plist plugin sets plist ft to xml
    \ setlocal noexpandtab

  " C++ modeline ignored on macOS stdlib, only checking in line 1
  autocmd BufRead *
    \ if search('\M-*- C++ -*-', 'n', 1) |
    \   setlocal filetype=cpp |
    \ endif

  " C++ has triple-slash comments, C does not
  autocmd FileType cpp set comments^=:///

  "C++ fomatoptions for quickfix window
  autocmd FileType c,cpp compiler gcc

  " New C/C++ files
  autocmd BufNewFile *.{h,hpp,c,cpp} call <SID>insert_documentation_header()
  autocmd BufNewFile *.{h,hpp} call <SID>insert_header_guards()
  " autocmd BufNewFile *Test.{h,hpp,c,cpp} call <SID>setup_unit_test()

  " makeprogram for current file, type :cn for next warning/error.
  " Note that %:t is for filename without path, expecting SUFFIX to be defined..
  "           %:r is without the suffix
  "autocmd FileType cpp,c setlocal makeprg=make\ %:t:r
  "autocmd FileType cpp,c setlocal makeprg=make\ -C\ ./bin\ %:t:r
  "autocmd FileType cpp,c setlocal makeprg=make\ -C\ ./bin\ $*
augroup END

" Watch vimrc for changes and reload
"   https://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim#132030
"   Manual method `:source $MYVIMRC`
augroup myvimrc
  autocmd!
  "autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc source $MYVIMRC
  "      \ | if has('gui_running')
  "      \ |   source $MYGVIMRC
  "      \ | endif

  " for reloading when vimrc is saved, assuming currently working on it?
  autocmd! BufWritePost $MYVIMRC source %
        \ | echom "Reloaded " . $MYVIMRC
        \ | redraw
  autocmd! BufWritePost $MYGVIMRC
        \   if has('gui_running')
        \ |   source %
        \ |   echom "Reloaded " . $MYGVIMRC
        \ | endif
        \ | redraw
augroup END " myvimrc

" Usage outside of group:
"   `autocmd cpp_ide Filetype cpp call <SID>special_funtions()`
"   https://vi.stackexchange.com/questions/9455/why-should-i-use-augroup
"   http://vimdoc.sourceforge.net/htmldoc/usr_40.html#40.3
augroup cpp_ide
  autocmd!
augroup cpp_ide

endif " has autocmd"

"}}} autocmd Groups


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Printing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" duplex:off prints on one side
" syntax:n for black and white or removing emphasis
"set printoptions=paper:letter,wrap:n,number:y ",duplex:off,syntax:n
" when printing from gui, give linenumber a white background for visibility
" run: highlight LineNr guibg=#ffffff

" Exporting to HTML
let g:html_font = ["Consolas"]

"}}} Printing

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabulation
" Expand tab characters to spaces
set expandtab
" 1 tab == 2 spaces
set shiftwidth=2  " number of spaces to use for each (auto)indent, tabstop if 0
set tabstop=2
" tab follows shiftwidth on new lines
set smarttab

" Indentation
" Auto indent, problematic when pasting so use "*p
set autoindent
" Smart indent
set smartindent
" Soft wrap lines to fit window (default on)
"set wrap

" Auto hardwraps when formatoptions is not set
set textwidth=80
" Make it obvious where 80 characters is
set colorcolumn=+1

" Disables textwidth autowrap, overrides possible by filetype
"set formatoptions-=tc

" Linebreak on 500 characters
"set lbr

" Display extra whitespace
"   HT for horizontal tabulation
"set list listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵,precedes:←,extends:→
set list listchars=tab:»\ ,trail:·,nbsp:·,eol:¬,precedes:←,extends:→
"set list listchars=tab:\ \ ,trail:·,nbsp:·,eol:¬

" Trim trailing spaces, no error if none
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
function! TrimWhitespace()
  let l:save = winsaveview()  " Save current cursor position, folds, jumps, etc.
  keeppatterns %s/\s\+$//e    " Don't save pattern in history
  call winrestview(l:save)    " Restore the view and history we saved
endfun
command! TrimWhitespace call TrimWhitespace()

"}}} Text, tab and indent related


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Mouse & Scroll: Terminal Performance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Replace with plugin 'wincent/terminus'
if ! has("gui_running")
  set mouse=a

  " Scroll in vim-iTerm2 like in Terminal.app
  "   note that TERM_PROGRAM is still passed to gui vim
  if $TERM_PROGRAM =~ "iTerm"
    if !has('nvim')
      set ttymouse=xterm2
    endif

    " Proper mouse reporting rows/columns in big terminal window,
    " (for)from iterm2.com. The SGR protocol.
    if has('mouse_sgr')
      set ttymouse=sgr
    endif
  else
    " You're not holding it right!
    "   Navigate, don't scroll.
    "   Scrolling is still choppy and unpredictable without GPU rendering.
    nnoremap <ScrollWheelUp>   :echoe      "Use ^u"<CR>
    inoremap <ScrollWheelUp>   <C-o>:throw "Use ESC ^u"<CR>
    nnoremap <ScrollWheelDown> :echoe      "Use ^d"<CR>
    inoremap <ScrollWheelDown> <C-o>:throw "Use ESC ^d"<CR>
  endif

  " Slow terminal vim scrolling
  set lazyredraw
  set ttyfast
endif
"}}} Mouse & Scroll

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To keep current color setting
syntax enable
set background=dark
" Toggle Solarized background, conflicts with ctrlP
"call togglebg#map("<F5>")

" CursorLine should not show in insert mode or for non-current windows,
"   style is hard to visually distinguich from horizontal splits (StatusLineNC).
"   So only show the cursorline in the current buffer split.
if exists('+cursorline')
  set cursorline
  augroup cursorLine
    autocmd!
    autocmd VimEnter,InsertLeave,BufEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave,InsertEnter,BufLeave,BufWinLeave * setlocal nocursorline
  augroup END
endif

" For vim to overrule current terminal color setting
"syntax on

" 24-bit / Truecolor mode
"   Requires
"     1.You have vim >=8.0 or Neovim >= 0.1.5  --> ("termguicolors")
"         has("termguicolors") = vim compiled with true color support
"     2.Terminal with 24-bit / truecolor support enabled
"       COLORTERM is set by the terminal application if it supports truecolor.
"       Should not be exported by bash/zsh.
"         Check if COLORTERM is "truecolor" or "24bit",
"         no need to check TERM_PROGRAM.
"     - ? compatible colorscheme???
"     3.Not set t_Co, term ???
"       t_Co must be set before colorscheme.
"       Don't set t_Co in .vimrc, vim will ask the terminal via $TERM.
"       Don't set TERM in .profile, the terminal application is supposed to set
"         this via terminfo, allowing shell configs to be used with multiple
"         term apps.
"     Previously under statusline section of VIMRC:
"     " These lines setup the environment to show graphics and colors correctly.
"     "set t_Co=256
"     "set term=xterm
"
if ( has("termguicolors") &&
    \ ($COLORTERM == "truecolor" || $COLORTERM == "24bit"))
  set termguicolors
endif

try " No need to check runtime path if color is installed
  " To run base16 vim using 256 terminal (iterm theme or shell theme)
  "   Use in terminal only???
  "let base16colorspace=256 " set above colorscheme

  if has("gui_running")
    colorscheme base16-monokai
    "colorscheme base16-ashes
    "colorscheme base16-default
    "colorscheme base16-solarized
    "colorscheme base16-atelierdune
    " 24bit color, default background = light
    " Faster versions with truecolor
    " lifepillar/vim-gruvbox8
    " lifepillar/vim-solarized8
  else
    " Transparent terminal backgrounds not displayed well with solarized
    let g:solarized_termtrans = 1
    colorscheme solarized

    "colorscheme gruvbox
    "let g:gruvbox_contrast_light = 'hard'
    "let g:gruvbox_contrast_dark  = 'hard'

    " Base 16 with shell matching component
    if filereadable(expand("~/.vimrc_background"))
      " not needed for iTerm2
      "let base16colorspace=256
      source ~/.vimrc_background
    endif
  endif
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme slate
endtry

"}}} Colorscheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Font
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" dz = dotted zero
" lg = linegap

" ! causes mvim to to no longer italicize comments
" Sets MacVim font (powerline) and size
"   Default for mvim is Menlo, which includes italic & bold typefaces
if has("gui_running")
  " Calling uname is slow
  "let s:uname = system("uname")
  "if s:uname == "Darwin\n"
  " OR just use has('gui_mac')
  if has('mac') " will fail on OSX/MacOS system vim, which is ok.
    "set guifont=MesloLGM-RegularForPowerline:h14
    set guifont=SourceCodePro-Regular:h14,Menlo-Regular:h13
    set linespace=2

    " No Scrollbars
    set guioptions=0
  endif
endif

" ! Need a font that includes italic typefaces
" Italicize comments
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment gui=italic cterm=italic

" LaTeX conceal to utf8 glyphs
let g:tex_conceal = ""

"}}} Font

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Switching files, panes & windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
"nnoremap <leader>w <C-w>w   " Leader key causes delay, use commands below
nnoremap <leader>w :echoe "Use <C-{j,k,h,l}>"<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Cycle through listed buffers
" They work but overlap with ctrl-p search
"nnoremap <C-n> :bnext<CR>
"nnoremap <C-p> :bprevious<CR>
" move through buffers
nmap <leader>[ :bp!<CR>
nmap <leader>] :bn!<CR>
nmap <leader>x :bd<CR>

"}}} Switching files, panes & windows

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Status line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line -> doesnt work
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Airline replacement: https://www.vi-improved.org/recommendations/
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    +-- current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

" Reduce (leader key) and escape timeout on delay when leaving insert mode with
" powerline or airline in terminal vim.
if ! has('gui_running')
  set ttimeoutlen=10    " Default is 1000
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

"}}} Status line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Get off my lawn
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <Left>  :echoe      "Use h"<CR>
"inoremap <Left>  <C-o>:throw "Use ESC h"<CR>
"nnoremap <Right> :echoe      "Use l"<CR>
"inoremap <Right> <C-o>:throw "Use ESC l"<CR>
"nnoremap <Up>    :echoe      "Use k"<CR>
"inoremap <Up>    <C-o>:throw "Use ESC k"<CR>
"nnoremap <Down>  :echoe      "Use j"<CR>
"inoremap <Down>  <C-o>:throw "Use ESC j"<CR>

" Allow left and right navigation to wrap between lines
set whichwrap+=<,>,h,l

" Configure backspace so it acts as it should act
"set backspace=2   " same as 3 below, see help 'backspace'
"set backspace=indent
"set backspace=eol
"set backspace=start

" niceties
nnoremap ; :

" Practical Make and Quickfix Shortcuts
if exists('g:loaded_dispatch')
  " see :h dispatch-maps
  "   m maps exist without Leader prefix as well
  nnoremap <Leader>m         :Make<CR>
  nnoremap <Leader>m<Space>  :Make<Space>
  nnoremap <Leader>l         :Copen<CR>
  nnoremap <Leader>ll        :Copen!<CR>
else
  nnoremap <Leader>m         :make<CR>
  nnoremap <Leader>m<Space>  :make<Space>
  nnoremap <Leader>l         :copen<CR>  " Error list
  nnoremap <Leader>ll        :copen!<CR> " Message list (long-list)
endif

"during insert, kj escapes, `^ is so that the cursor doesn't move
"inoremap kj <Esc>`^
inoremap kj <Esc>

" Vim is About Command-Mode!
"   Automatically exit insert mode
"au InsertEnter * let updaterestore=&updatetime | set updatetime=4000
"au InsertLeave * let &updatetime=updaterestore
"au CursorHoldI * stopinsert

"}}} Get off my lawn


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"
"{{{                        Plugin Configurations
if g:PluginFileLoaded
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{ Language Server Protocols
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dart minimalist
"   - don't override Ctrl-P
let g:lsc_auto_map = {'defaults': v:true, 'PreviousReference': '<C-N>'}
"}}} Language Server Protocols


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline (Powerline without python)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically populate airline symbols dictionary
"   Unecessary as of 2017, autoload/airline/init.vim detects if terminal is
"   Powerline, Unicode or ASCII. Fallback to visible characters when nicer ones
"   are not available.
"let g:airline_powerline_fonts = 1

" Smart tab line, displays buffers if only 1 tab open.
let g:airline#extensions#tabline#enabled = 1
" Too slowa, no advantage anyways
let g:airline#extensions#tagbar#enabled = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => AsyncRun / Dispatch
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:asyncrun_open = 3


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CrlP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" required for ignores to apply
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif
" Sane Ignore For ctrlp (ctrlp only, not wildignore)
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$\|temp$\|build$',
  \ 'file': '\.exe$\|\.so$\|\.dat$\|\.swp$\|\.zip$'
  \ }

" Follow symlinks but ignore looped internal symlinks
let g:ctrlp_follow_symlinks = 1

" Use the Silver Searcher if available
if executable('ack')
  " grpprg & quickfix handled separately by ack.vim plugin

  " FIXME ag falsely searches binary files when -g is used
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor --smart-case -g ""'
  let g:ctrlp_user_command = 'ack --nocolor --smart-case -g "" %s'
  " -l    Only print the names of files containing matches.
  " -G    Only search files whose names match PATTERN.
  " -g    Print filenames matching PATTERN.
  "let g:ctrlp_user_command = 'ag %s -l --nocolor --smart-case -G ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif " ag


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags - Plugin dependent configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Order of which tag file to use, 
"   '.' is replaced with the path of the current file
set tags=./tags,tags,~/.commontags

" C++ Specific Command Options
" TODO Move these to the ~/.ctags.d/cpp.ctags file with the others.
"   The other fields are to track:
"     +l  the language, is necessary for YouCompleteMe to use ctags
"     +i  Inheritance info
"     +a  Access/export level of class members
"     +S  Signature (prototype, parameters)
"   The c++-kinds=+p adds entries for the prototype to the tags file as well.
"   The extra +q forces full namespace qualified tags to be stored as well.
let g:ctags_options=" --fields=+liaS --c++-kinds=+p --extras=+q "

" Index ctags from any project, including those outside Rails
"   Use the same key as jumping to tag: ^] (^t to jump back)
map <Leader>]]
  \ :execute "!ctags " g:ctags_options " -R . &"<CR><CR> " 2 enters for command
  "\ :Dispatch!ctags . g:ctags_options . "-R ."<CR>

" => Tagbar
" Show Tagbar current file
nmap <Leader>b
  \ :TagbarToggle<CR>

let g:tagbar_type_css = {
\ 'ctagstype' : 'Css',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
    \ ]
\ }

" => Gutentags
" Show WHEN run in status line
if exists('g:loaded_airline') && g:loaded_airline
  if exists('g:loaded_gutentags')
    let g:airline#extensions#gutentags#enabled = 1
    set statusline+=%{gutentags#statusline()}
  endif
else
endif

" WHERE to run ctags (given directory of current buffer)
"   Add the file `.notags` to disable for project.
let g:gutentags_project_root = ['Makefile', 'tags']

" WHAT command to run
let g:gutentags_ctags_extra_args = split(g:ctags_options)

" these could get heavy
"let g:gutentags_exclude = ['*.css', '*.html', '*.js']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autopen NERDTree and focus cursor in new document (window on the right)
"autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Shortcut to open NERDTree
map <leader>n :NERDTreeToggle<CR>

" Close vim if the only window left open is a NERDTree
autocmd BufEnter *
  \ if (winnr("$") == 1
  \     && exists("b:NERDTreeType")
  \     && b:NERDTreeType == "primary") |
  \   q |
  \ endif

" Issue: is showing '.NERD_tree_1.swp' in nerdtree despite wildignore
" NERDTree reflects the file system.
" Only need to ignore file system support files & editor files.
let NERDTreeRespectWildIgnore = 0 " Default: 0
" Default: ['\~$']
let NERDTreeIgnore = [ '\~$',
  \ '\.DS_Store$', '\Desktop.ini$', '\.Spotlight-V100$', '\.Trashes$',
  \ '\.*.sw[nop]$', '\.netrwhist$'
  \ ]
" Show hidden files in NerdTree
let NERDTreeShowHidden = 1 " Default: 0

" Split explorer model instead of project drawer
"   opens tree at window level instead of at the tab level
let NERDTreeHijackNetrw = 1 " (Default: 1)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uninstalled, YouCompleteMe does the same


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-rspec mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup rspec_mappings
  autocmd!
  "autocmd FileType ruby nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
  autocmd FileType ruby nnoremap <Leader>s :call RunNearestSpec()<CR>
  autocmd FileType ruby nnoremap <Leader>l :call RunLastSpec()<CR>
  autocmd FileType ruby nnoremap <Leader>a :call RunAllSpec()<CR>
augroup END

" Run last session specs in currrent terminal (iTerm2 only)
let g:rspec_runner = "os_x_iterm2"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C++
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Won't pickup certain clang errors when enabled.
" i.e. Undefined symbols for architecture x86_64:...
"let g:compiler_gcc_ignore_unmatched_lines=1

" Compile and Run
"   Use without having a makefile to compile a single TU and run it.
"   Depends on AsyncRun.
"   Replacement for:
"     map<Leader>r :w <bar> !clear && g++ --std=c++11 -o %:r % && ./%:r<CR>
"   Reminders
"     use function! to override others by the same name.
"     use | to chain commands
"     use <bar> when mapping
autocmd FileType c,cpp
  \ map <Leader>r
  \ :call <SID>Compile_and_Run()<CR>
function s:Compile_and_Run()
  call mkdir('./bin/', 'p')
  " use @%:r to get relative path to current working directory
  "   Want to use the basename, without extensions.
  let binary = 'bin/' . expand('%:t:r')
  let cxx='clang++'
  let cpp_flags=''
  let cxx_flags='
    \ -std=c++11 -stdlib=libc++
    \ -Wall -Wextra -Wpedantic
    \ -g -O0
    \ -D_GLIBCXX_DEBUG'
  execute ':Dispatch -compiler=gcc ' . cxx . cpp_flags . cxx_flags . ' % -o ' . binary
  call <SID>AfterMakeC(binary)
endfunction

" After Make C
"   Executes C/C++ binary after they're linked if there were no errors during
"   compilation time. The result should show in the quicklist.
"   Called by autocmd.
"autocmd QuickfixCmdPost make call <SID>AfterMakeC(%<)
function s:AfterMakeC(executable_path)
  if len(filter(getqflist(), 'v:val.valid')) == 0
  "if len(getqflist()) == 0
    execute ':Dispatch -compiler=gcc ./' . a:executable_path
  endif
endfunction

" Current Translation Unit Test
"   Builds the expected test pathname for the current file.
function s:CurrentUnitTest()
  " Get tail of current file,
  "   remove file extension (.h, .hpp, .c, .cpp, etc.),
  "   removes filename suffix 'Test' if present,
  "   prepend the pathname and append 'Test' to the unit's name.
  let unit_name = substitute(expand('%:t:r'), 'Test$', '', '')
  let test_bin  = "bin/" . unit_name . "Test"
  return test_bin
endfunction

" Run Current Unit Test
"   Compile unit-test for the current translation unit then run it if no errors.
map <Leader>t
  \ :call <SID>Run_CurrentUnitTest()<CR>
function s:Run_CurrentUnitTest()
  let test_bin = <SID>CurrentUnitTest()
  " Without !, only sets for the current buffer
  execute ":compiler gcc"
  execute ":Make --silent " . test_bin
  call <SID>AfterMakeC(test_bin)
endfunction

" Make Test Current Unit
"   Hands off work to Make for BOTH the compilation for the current translation
"   unit under test and then the execution of that test.
"
"   Requires that a phony recipe exists in the Makefile.
"   Depends on Dispatch, makefile.
function! MakeTestCurrentUnit()
  let unit_name = substitute(expand('%:t:r'), 'Test$', '', '')
  execute ":Make test" . unit_name
endfunction

" Test All
"   Hands off work to Make for BOTH compiling and running all project unit tests.
"   Requires that a phony recipe exists in the Makefile.
"   Depends on Dispatch, Makefile recipe.
map <Leader>T
  \ :Make tests<CR>

" Insert Documentation Header
"   File documentation for new C/C++ files.
"   Called by autocmd.
function s:insert_documentation_header()
  set paste " to avoid auto-commenting on new lines
  let filename = expand("%:t")

  execute "normal! i/* " . filename .
    \            "\n * " . repeat('-', len(filename)) .
    \            "\n * Authors: Darwin Jacob Groskleg" .
    \            "\n * Date:    " . strftime("%A, %B %d, %Y") .
    \            "\n *" .
    \            "\n * Purpose: " .
    \            "\n */"
  set nopaste
endfunction

" Insert Header Guards
"   Inserts guards on new header files.
"   Called by autocmd.
function s:insert_header_guards()
  let guardname = substitute(toupper(expand("%:t")), "\\.", "_", "g")

  " Jump to bottom and insert
  execute "normal! Go#ifndef "   . guardname . "_INCLUDED\n" .
    \               "#define "   . guardname . "_INCLUDED\n" .
    \               "#endif // " . guardname . "_INCLUDED"
  " Move cursor up
  normal! kk
endfunction

" Config for octol/vim-cpp-enhanced-highlight
let g:cpp_member_variable_highlight = 1

" Indentations
" - scope declaration same as class keyword (public, private, protected)
set cinoptions+=g2  " offset for scope from block indent
set cinoptions+=h2  " offset from start of scope declaration
" - No indent on namespace body
set cinoptions+=N-s

if exists("loaded_alternateFile") " a.vim
  nnoremap <Leader>a    :A<CR>
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YCM YouCompleteMe
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Compilation flags file required for C & C++
" Strategy:
"   Automatically looks for and uses .ycm_extra_conf.py in project.
"   Otherwise detects and uses compilation database,
"     looks for compile_commands.json in the path to the current file.
"
"   Mannually set global ycm_extra_conf...
"
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf_global.py'

" Stop asking permission to use ycm config for the project
"   ...now leads to loading/using global config over the compilation database
"   even when `compile_commands.json` already exists!
let g:ycm_confirm_extra_conf = 1 " Default: 1 = asks once per config file

" Only works with Exuberant Ctags
" Requires ctags be called with `--fields=+l` to output the language field.
let g:ycm_collect_identifiers_from_tags_files = 1

" Relative to Vim's CWD
let g:ycm_filepath_completion_use_working_dir = 0

" Close the preview window!
let g:ycm_autoclose_preview_window_after_completion = 1

" Will use clangd by default if not set to Never
" clangd requires a compilation database.
" Options: 1 (Default) use if binary exists, 0 Never use clangd
"let g:ycm_use_clangd = 0

" Needed for clangd < v9
"let g:ycm_clangd_args = ['-background-index']

" Clangd recommend disabling YCM's caching on behalf of Clangd
let g:ycm_clangd_uses_ycmd_caching = 0

" Want maps to
"   - get type
"   - expand error for current line
"   - open/close location list
"   - open/close message list
nnoremap <Leader>y<Space> :Ycm
nnoremap <Leader>yf            :YcmCompleter FixIt<CR>


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
endif "}}}                 End of Plugin Configurations
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Project Specific vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set exrc
" Prevent autocmd, shell and write commands from being run in a project vimrc
set secure
