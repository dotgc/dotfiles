
if [ "$TERM" = "dumb" ] ; then
    export PS1="[\u@\h] [\w] > "
    unset GREP_OPTIONS
else
#   PS1="[\u@\h] [\w]\n> "
    PS1="\[\033[01;37m\][\[\033[01;31m\]\u\[\033[01;37m\]@\[\033[01;32m\]\h\[\033[01;37m\]] [\[\033[01;34m\]\w\[\033[01;37m\]]\n> \[\033[00m\]"
fi
