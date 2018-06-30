# .zshenv
#
# Sourced on all invocations of the shell, unless the -f option is set.
# Should contain exported variables that should be available to other programs.
#   - set the command search path, $PATH
#   - $EDITOR
#   - $PAGER
#
# Should NOT contain commands that:
#   - produce output or
#   - assume the shell is attached to a tty.
echo "Sourcing ~/.zshenv"

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

# export MANPATH="/usr/local/man:$MANPATH"

# Less Coloured Man Pages
#   Same vars used in colored-man-pages zsh plugin.
#   Cannot be a function for it to work with vim shortcut: shift+k
#   Can be placed in .zshrc or .zshenv
#
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
