## .zshenv
##
## Sourced on all invocations of the shell, unless the -f option is set.
## Read even when Zsh is launched to run a single command (with the -c option),
## even by another tool like make.
## Therefore, KEEP THIS FILE SHORT.
##
## Should contain exported variables that should be available to other programs,
## and are updated often.
##   - set the command search path, $PATH
##   - $EDITOR
##   - $PAGER
##   - ${RB,EX,PY}ENV_ROOT for git-checkout installations (not homebrew).
##     ...according to pyenv's readme.
##
## Should NOT contain commands that:
##   - produce output or
##   - assume the shell is attached to a tty.
##
## Sourced after `/etc/zshenv` and before any other user startup files.
##  - man zsh
##  - zsh -l -o sourcetrace
##  - https://github.com/rbenv/rbenv/wiki/Unix-shell-initialization
##
#echo "Sourcing ~/.zshenv"

# Paths: keeps paths as arrays of unique items
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# TODO all of this is being appended to the basic path
#     see man path_helper
#path=('/usr/local/sbin' $path) # Better to just add this one to /etc/paths
# User local: ahead of path
path=("$HOME/bin" $path)
# User synced: end of path
path+=("$HOME/Dropbox/bin")

# Interpreter ENV_ROOT for access to bin/
#   vim will then use pyenv/rbenv provided interpreter
# N.B. not clear how or for what purpose this should work
#export PYENV_ROOT="$HOME/.pyenv"
#path=("$PYENV_ROOT/bin" $path)
#export RBENV_ROOT="$HOME/.rbenv"
#path=("$RBENV_ROOT/bin" $path)

path+=("$HOME/.pub-cache/bin")
path+=("$HOME/.poetry/bin")

export PATH

## Flutter / Dart SDK Path (including dart path)
##export FLUTTER_ROOT="/usr/local/src/flutter"
##export DART_SDK="$FLUTTER_ROOT/bin/cache/dart-sdk"
##export DART_VM_OPTIONS=-DSILENT_OBSERVATORY=true

## MacOS SDK Path
#   Required if using command line tools without XCode.
#export SDKROOT=/Applications/Xcode7.3.1.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
#   Also see how to install system headers after installing xcode or command
#   line tools, as of XCode 10.
#
#   Also see `xcrun --show-sdk-path` command.
#export CFLAGS="-I/usr/local/include -L/usr/local/lib -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"

## Compiler flags
# FIXME These screw up compilations by PlugInstall in vim
#export CXX="clang++"

## Preprocessor flags and include directories.
# Should have a function for generating thesystem include libraries for macOS
#export CPPFLAGS=""

## Compilation flags
export ARCHFLAGS="-arch x86_64"
#export DIAGFLAGS=""
WARNFLAGS=(-Wall -Wextra)
DEBUGFLAGS=(-g -D_GLIBCXX_DEBUG)
OPTFLAGS='-O0'
MYCFLAGS=('-std=c99' $WARNFLAGS $DEBUGFLAGS $OPTFLAGS)
export MYCFLAGS
# Variable length cstrings in c++14 and up.
MYCXXFLAGS=(
  '-std=c++14' '-stdlib=libc++'
  -Wpedantic $WARNFLAGS $DEBUGFLAGS $OPTFLAGS
)
export MYCXXFLAGS

## Linker flags
# Extra flags to give to compilers when they are supposed to invoke the linker,
# ‘ld’, such as -L. Libraries (-lfoo) should be added to the LDLIBS variable.
#export LDFLAGS

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export VISUAL='vim'
  export EDITOR="$VISUAL"
fi


# export MANPATH="/usr/local/man:$MANPATH"

export MANWIDTH=70 # to help vim on small screens
# Less Coloured Man Pages
#   Same vars used in colored-man-pages zsh plugin.
#   Cannot be a function for it to work with vim shortcut: shift+k
#   Can be placed in .zshrc or .zshenv
#
# NOTE on terminal coloring.
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# Test like `echo -e "\e[31mHello World\e[0m"`.
#
# NOTE on some codes:
#   1 bold, 2 dim, 4 underlined
#   31 red, 32 green, 33 yellow, 34 blue, 35 magenta
#   Starting with `[38;5;` selects color from the 256 color set.
PAGER=/usr/bin/less
PAGER="${commands[less]:-$PAGER}"
export LESS_TERMCAP_mb=$(printf "\e[1;31m")     # begin blinking
export LESS_TERMCAP_md=$(printf "\e[1;31m")     # begin bold
export LESS_TERMCAP_me=$(printf "\e[0m")        # end mode
export LESS_TERMCAP_se=$(printf "\e[0m")        # end standout-mode
export LESS_TERMCAP_so=$(printf "\e[1;38;5;246m")  # begin standout-mode (bottom info box)
export LESS_TERMCAP_ue=$(printf "\e[0m")        # end underline
export LESS_TERMCAP_us=$(printf "\e[4;32m")     # begin underline
export _NROFF_U=1                               # ???
# Alternative coloring: blue and purple with underlines
#export LESS_TERMCAP_md=$'\e[01;38;5;74m'
#export LESS_TERMCAP_us=$'\e[04;38;5;146m'

# Python terminal output needs to be specified
export PYTHONIOENCODING=utf-8
