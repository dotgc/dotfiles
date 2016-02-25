# .bashrc

# User specific aliases and functions
export EDITOR=emacs
export PATH=$PATH:$HOME/bin:/sbin:/usr/sbin:/usr/local/bin

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ "$TERM" = "dumb" ] ; then
    export PS1="[\u@\h] [\w] > "
    unset GREP_OPTIONS
else
#    PS1="[\u@\h] [\w]\n> "
    PS1="\[\033[01;37m\][\[\033[01;31m\]\u\[\033[01;37m\]@\[\033[01;32m\]\h\[\033[01;37m\]] [\[\033[01;34m\]\w\[\033[01;37m\]]\n> \[\033[00m\]"
fi

# History options
HISTCONTROL=ignoredups
shopt -s cmdhist

export PROMPT_COMMAND='
if [ $TERM = "screen" ]; then echo -ne "\033k${USER}@${HOSTNAME}\033\\"; fi;
'

# standard ubuntu aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# bash completion
. /etc/bash_completion

if [ -f .aliases ]; then
   . .aliases
fi
