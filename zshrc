## .zshrc
##
## Sourced in all interactive shells (including login shells).
##
## Should be used for:
##   - set up aliases
##   - set up functions
##   - set up keybindings
##   - setting options for interactive shell (setopt, unsetopt)
##   - set HISTORY options
##   - change prompt
##   - set up completions
##   - set variables only used in interactive shell (LS_COLOR)
##
## Sourced after `.zprofile` and before `.zlogin`.
##
## Order on my MacOS (>10.10) on new terminal tab or SSH session:
##  1 /etc/zshenv
##  2 ~/.zshenv
##  3 /etc/zprofile
##    (calls path_helper -s) Order, from path_helper source code:
##        Starts PATH from entries in /etc/paths      (OS generated file)
##        Appends paths from files in /etc/paths.d/   (user/pkg generated files)
##        Appends all prexisting env PATH entries from before path_helper
##  4 ~/.zprofile
##  5 /etc/zshrc
##  6 ~/.zshrc
##  7 /etc/zlogin
##  8 ~/.zlogin
##
echo "Sourcing ~/.zshrc"
#echo $PATH
zmodload zsh/zprof


# Homebrew recommeded loading approach, run before oh-my-zsh (compinit)
if type brew &>/dev/null; then
  homebrew_fpath=$(brew --prefix)/share/zsh/site-functions
  fpath=( $homebrew_fpath $fpath)
  # should be run by oh-my-zsh
  #autoload -Uz compinit
  #compinit
fi

#{{{ BEGIN oh-my-zsh configuration

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# Test startup time with: time zsh -i -c exit
#ZSH_THEME="muse"       # 1.311 sec startup
#ZSH_THEME="agnoster"  # slow autocomplete, 1.282 sec startup (7.068 uncached?)
#ZSH_THEME="powerlevel9k/powerlevel9k" # 1.358 sec startup
ZSH_THEME="clean"
## Defaults:
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time
  root_indicator background_jobs virtualenv pyenv rbenv time)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution
# timestamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Skip the verification of insecure directories for completions.
# ...Not zsh's job.
ZSH_DISABLE_COMPFIX="true"

# XXX Until fixed in OMZ plugin for asdf
fpath=($HOME/.asdf/completions $fpath)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# NOTE pyenv and rbenv are the cause for PATH clutter, which is acceptable.
plugins=(
  dotenv        # Automatically load your project ENV variables from .env
  git           # Adds cmd aliases and functions for current branch
  nmap          # Meaningful aliases for nmap
  #rbenv         # Initializes rbenv environment and set version in prompt
  #pyenv         # Initializes pyenv environment and set version in prompt
                # Appends the pyenv bin dir to PATH if no pyenv command
  virtualenv    # Creates virtualenv_prompt_info function to use in your theme
  zsh_reload    # `src` - Function to reload the zsh session
  asdf
)

# catimg - show image in terminal
# common-aliases - just that
# colored-man-pages - sets LESS_TERMCAP colors for man
# rails - rails/rake aliases
# gitfast - replaces git because it's slow
# git-auto-status - ??
# git-prompt - ??
# git-extras - adds some nice git completions
# git-flow - completions for git-flow

source $ZSH/oh-my-zsh.sh

#}}} END oh-my-zsh configuration


# hide my username from constantly showing for user@hostname
DEFAULT_USER=`whoami`

# Fix Ctrl-D & Delete key from closing session on empty lines
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

# Base16 Shell
#BASE16_SHELL="$HOME/.config/base16-shell/base16-atelierdune.dark.sh"
#BASE16_SHELL="$HOME/.config/base16-shell/solarized.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Set CLICOLOR if you want
#   - Ansi Colors in iTerm2
#   - Colored output for ls
export CLICOLOR=1

# Should be set by terminal application to advertise color support.
#   - but not over ssh?
# Sets colors to match iTerm2 Terminal Colors
# Terminal.app does not support truecolor, does not set COLORTERM.
# export COLORTERM='truecolor'    # 24-bit color (16 million color palette)

# Should be set by terminal application, no need to set here.
#   Expected default: 'xterm-256color'
#   Vim also expects this.
#export TERM=xterm-256color   # docker-machine ssh uses "xterm"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# iTerm shell integration
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  echo "Sourcing iTerm shell integration..."
  source ~/.iterm2_shell_integration.`basename $SHELL`
fi

export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Docker - changes with new docker-machine instances
# Suggested to run: `eval "$(docker-machine env default)"`
#export DOCKER_TLS_VERIFY="1"
#export DOCKER_HOST="tcp://192.168.99.100:2376"
#export DOCKER_CERT_PATH="/Users/darwingroskleg/.docker/machine/machines/default"
#export DOCKER_MACHINE_NAME="default"

## Interpreter ENV Initializers (rehash shims and place in the front of PATH)
##  Also done by zsh plugins, which set the version in prompt
# Ruby
#if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
# Have Ruby-Install use homebrew's OpenSSL instead of reinstalling for each ruby
#   Too slow for zsh: --with-openssl-dir=$(brew --prefix openssl@1.1)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl@1.1"

# Elixir
if which exenv > /dev/null; then eval "$(exenv init -)"; fi

# Python
#if which pyenv > /dev/null; then eval "$(pyenv init - zsh)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export WORKON_HOME=$HOME/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh


# Oracle jdbc
if [ -f "/usr/local/share/instantclient" ]; then
  source /usr/local/share/instantclient/instantclient.sh
fi
# SQLPlus looks for login.sql in ORACLE_PATH on unix, not SQLPATH
#export ORACLE_PATH=~/.oracle

################################################################################
#{{{                            Functions                                    ###
# Autoloading functions:
#   https://scriptingosx.com/2019/07/moving-to-zsh-part-4-aliases-and-functions/

function docker-env() {
  eval $(docker-machine env $1);
}

# Slow Git
# Resolving slow prompt on large repositories
#git_prompt() {
#  temp=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
#  if [ «$temp» != «» ]; then echo «$temp:»; fi
#}
#setopt prompt_subst
#export RPROMPT='[$(git_prompt)%~]'
# This one worked: ...or it was the git ignoreStat config
#function git_prompt_info() {
#  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
# aak echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
#}

# HOMEBREW
# NOTE `brew cleanup` version mismatch failures happen in development
#alias brewfresh=brewfresh
# relink openssl `&& brew unlink openssl && brew link openssl --overwrite --force`
function brewfresh() {
  brew update
  # brew ls --unbrewed
  brew doctor
  brew cleanup
  brew ls --pinned --versions
  brew outdated
}

function brup() {
  brew outdated | xargs -I {} brew desc {}
  brew upgrade
}

function bru() {
  brew update
  local datetime
  datetime=$(command date)
  echo "\nOUTDATED: $datetime *****************************************"
  #brew outdated
  #   We don't want to manually delete or upgrade dependency packages.
  #   We may want to manually delete or upgrade a package that is not a
  #     dependency.
  # Only show outdated leaves (packages that are not dependencies)
  #   And include a description to help deciding if it's important.
  join <(brew outdated --verbose) \
       <(brew leaves | xargs -L1 brew desc | sed 's/:/		-/g')
  # TODO use `tput cols` builtin command to right-align package descriptions
  #      using the current terminal width.

  if [ -n "${1+x}" ]; then
    echo -n "\nOUTDATED USER PYTHON"
    echo " ***********************************************************"
    pip2 list --outdated --user
    pip3 list --outdated --user
    echo "\nOUTDATED SYSTEM PYTHON"
    pip2 list --outdated
    pip3 list --outdated
    echo ""
  fi

  if command -v asdf &> /dev/null
  then
    echo -n "\nUPDATING ASDF AND INSTALL LISTS"
    echo " ************************************************"
    asdf update --head
    asdf plugin update --all
    echo ""
  fi
}

function brew-linkmacvim() {
  # fix all linked apps
  #brew linkapps; find ~/Applications -type l | while read f; do osascript -e "tell app \"Finder\" to make new alias file at POSIX file \"/Applications\" to POSIX file \"$(/usr/bin/stat -f%Y "$f")\""; rm "$f"; done

  # Use hard links instead of symbolic links or aliases
  # find /Applications -type l -depth 1 | while read f; do osascript -e "tell app \"Finder\" to make new alias file at POSIX file \"/Applications\" to POSIX file \"$(stat -f%Y "$f")\""; rm "$f"; done

  # Use mac aliases
  #rm /Applications/MacVim.app
  osascript -e 'tell application "Finder" to make alias file to POSIX file "/usr/local/opt/macvim/MacVim.app" at POSIX file "/Applications"'
}

# Digest Check
# Checks that a given file's digest matches the expected value.
# NOTE on terminology, a "digest" is the output of a hash function.
function dgstchk() {
  expected_digest="$1"
  file_path="$2"

  # Usual File Name:
  #   ~/Downloads/RT-N66U_380.*/RT-N66U_380.*.trx
  file_digest=$(
    openssl dgst -sha256 "$file_path" \
    | sed 's/^.*= //'
  )

  if [[ "$expected_digest" = "$file_digest" ]]; then
    echo "MATCH"
    return 0
  else
    echo "NO MATCH"
    echo "$expected_digest(expected)"
    echo "$file_digest(actual)"
    return 1
  fi
}

# Give size of directory and it's contents
function ducks() {
  du -cksh "$1" | sort -rn | head -11
}

#alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
#alias localip="ipconfig getifaddr en0"
function ip() {
  # Takes an ip address (optional), assume it's valid
  ip_address="$1"

  # If no arguments passed, get addresses for current machine.
  if [ -z "$ip_address" ]; then
    # Local Addresses
    interface=`netstat -nr | awk '{ if ($1 ~/default/) { print $6} }'`
    ifconfig ${interface} | awk '{ if ($1 ~/inet/) { print $2} }'
    # Or use, to ignore IPV6:
    # ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'

    # Public Address
    curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'
  else
    # Info for given address
    curl ipinfo.io/"$ip_address"
    #curl https://api.ipstack.com/"$IP_ADDRESS"
    echo "\nFor more information run \`whois $ip_address\`"
    # Alternatively use the geoip cli tool.
  fi
}

macnst (){
    netstat -Watnlv \
    | grep LISTEN \
    | awk '{"ps -o comm= -p " $9 | getline procname;colred="\033[01;31m";colclr="\033[0m"; print colred "proto: " colclr $1 colred " | addr.port: " colclr $4 colred " | pid: " colclr $9 colred " | name: " colclr procname; }'\
    | column -t -s "|"
}

# Markdown to Word
function md2word () {
    pandoc_installed=$(pandoc --version >> /dev/null; echo $?)

    if [ "0" == ${pandoc_installed} ]; then
        pandoc -o $2 -f markdown -t docx $1
    else
        echo "Pandoc is not installed. Unable to convert document."
    fi
}

function mkcd() {
  mkdir -p "$@" && cd "$@"
}

function pbsend() {
  pbpaste | ssh "$@" pbcopy
}

export links="$HOME/Dropbox/.links.noindex"
#function links() {
#  links="$HOME/Dropbox/.links.noindex"
#  printf $links
#}

function linkw() {
  # See alias for links
  pbpaste >> links
  tail -n3 links
}

function xcode-agree() {
  sudo xcodebuild -license accept
}


#### PRIVATE SESSIONS ####
export HISTORY_IGNORE="(l|ll|ls|priv)"
function _priv() {
  # HISTSIZE - how many commands the current shell will remember
  unset HISTFILE \
    && export PRIVATE_SESSION=true
  # Set terminal window/tab title
  #   0 - ??? window title
  #   1 - tab title / icon title
  #   2 - window title
  printf '\e]1;%s\a' 'PRIVATE SESSION'
}

## priv - for user to engage private session properties
function priv() {
  _priv && echo "Disabled command history for session"
}
# FIXME fix false advertisement of PRIVATE_SESSION for terminal tab.
#   Occurs after session is restored on mac terminal. Key determining property
#   is as follows: IF HISTFILE is set THEN private session is invalid.
#   Example output:
#     ~$
#     [Restored Jun 7, 2019, 3:54:33 PM]
#     Last login: Fri Jun  7 15:54:33 on ttys003
#     Sourcing ~/.zprofile
#     Sourcing ~/.zshrc
#     ~$
if [[ -z "${HISTFILE+1}" ]]; then
  printf '\e]1;\a' # should default to terminal's tab title
fi

# TODO announce priv in the prompt line, which is a better visual spot than the
# tab title. It can alse call a function to confirm private each time!

# TODO re-engage private session properties on 'restored sessions'.
# If the session is reloaded, don't re-enable history.
# If the same environment is used, it should also be private?
# https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
  # if non zero length AND equals
function _priv_precmd() {
  if [[ -n "$PRIVATE_SESSION" && "$PRIVATE_SESSION" -eq "true" ]]; then
    _priv
  fi
}
precmd_functions+=(_priv_precmd)

# Redefinable functions
#  function names must match file names
#fpath=( ~/.zsh_functions $fpath )
#autoload -Uz $fpath[1]*(.:t)

#}}}  End of Functions

### Aliases ###
unalias run-help 2>/dev/null
autoload run-help
alias help=run-help
[[ -f ~/.aliases ]] && source ~/.aliases
