export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH='/Users/darwingroskleg/.boot2docker/certs/boot2docker-vm'
export DOCKER_TLS_VERIFY=1

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1
# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# ruby stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# python stuff
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export WORKON_HOME=$HOME/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

# go stuff
export GOPATH=$HOME/go/
export PATH=$PATH:$GOPATH/bin

# coloured man pages
man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    PAGER=/usr/bin/less \
    man "$@"
}
