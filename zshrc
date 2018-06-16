# .zshrc
#
# Sourced in all interactive shells (including login shells).
#
# Should be used for:
#   - set up aliases
#   - set up functions
#   - set up keybindings
#   - setting options for interactive shell (setopt, unsetopt)
#   - set HISTORY options
#   - change prompt
#   - set up completions
#   - set variables only used in interactive shell (LS_COLOR)
echo "Sourcing ~/.zshrc"


# BEGIN oh-my-zsh configuration

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  rails
)

# catimg - show image in terminal
# common-aliases - just that
# colored-man-pages - sets LESS_TERMCAP colors for man
# rails - rails/rake aliases
# git - adds cmd aliases and functions for current branch
# gitfast - replaces git because it's slow
# git-auto-status - ??
# git-prompt - ??
# git-extras - adds some nice git completions
# git-flow - completions for git-flow

source $ZSH/oh-my-zsh.sh

# END oh-my-zsh configuration


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export VISUAL='vim'
  export EDITOR="$VISUAL"
fi

# hide my username from constantly showing for user@hostname
DEFAULT_USER=`whoami`

# Base16 Shell
#BASE16_SHELL="$HOME/.config/base16-shell/base16-atelierdune.dark.sh"
#BASE16_SHELL="$HOME/.config/base16-shell/solarized.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Set CLICOLOR if you want
#   - Ansi Colors in iTerm2
#   - Colored output for ls
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export COLORTERM=truecolor    # 24-bit color (16 million color palette)
#export TERM=xterm-256color   # docker-machine ssh uses "xterm"

# iTerm shell integration
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  source ~/.iterm2_shell_integration.`basename $SHELL`
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export PATH="/usr/local/sbin:$PATH"

# Docker - changes with new docker-machine instances
# Suggested to run: `eval "$(docker-machine env default)"`
#export DOCKER_TLS_VERIFY="1"
#export DOCKER_HOST="tcp://192.168.99.100:2376"
#export DOCKER_CERT_PATH="/Users/darwingroskleg/.docker/machine/machines/default"
#export DOCKER_MACHINE_NAME="default"

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# Elixir
if which exenv > /dev/null; then eval "$(exenv init -)"; fi
# Python
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export WORKON_HOME=$HOME/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

if [ -f "/usr/local/share/zsh/site-functions" ]; then
  . "usr/local/share/zsh/site-functions"
fi

### Functions ###

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
  brew upgrade --cleanup
  # brew ls --unbrewed
  brew doctor
  brew ls --pinned --versions
  brew outdated
}

# Markdown to Word
function md2word () {
    PANDOC_INSTALLED=$(pandoc --version >> /dev/null; echo $?)

    if [ "0" == ${PANDOC_INSTALLED} ]; then
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

function xcode-agree() {
  sudo xcodebuild -license accept
}


### Aliases ###

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias md2word=md2word # alias the function below
alias sshmonolith="ssh -t monolith \"cd /Groups/monolith; exec \$SHELL --login\""
# preserve file tags, if macOS
if [[ "$(uname)" == "Darwin" ]]; then
  alias rsync="rsync -E"
  alias scp="scp -E"
fi
alias bins="ls /usr/bin /usr/sbin /bin /sbin"
alias link_documents=". $HOME/Code/scripts/link_documents.sh"
alias ducks="du -cksh * | sort -rn | head -11"
alias tree="tree -C"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
