export PROMPT_COMMAND='
if [ $TERM = "screen" ]; then echo -ne "\033k${USER}@${HOSTNAME}\033\\"; fi;
'

# User specific aliases and functions
export EDITOR='emacs'
export VISUAL=$EDITOR
export GIT_EDITOR=vim
export PATH=$PATH:$HOME/bin
export ROOT=$HOME/code
#export PYTHONPATH=$PYTHONPATH:$ROOT/python:$ROOT/python/stubs:.
export AWS_CONFIG_FILE=$HOME/.s3cfg
export GOPATH=$ROOT/go
export GOROOT=/usr/lib/go


if $_isxrunning; then
    export PAGER=less
    export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline
    export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

function setup_prompt {
    local DEFAULT="\[\033[00m\]"
    local BLACK="\[\033[0;30m\]"
    local BLACKBOLD="\[\033[1;30m\]"
    local RED="\[\033[0;31m\]"
    local REDBOLD="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local GREENBOLD="\[\033[1;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local YELLOWBOLD="\[\033[1;33m\]"
    local BLUE="\[\033[0;34m\]"
    local BLUEBOLD="\[\033[1;34m\]"
    local PURPLE="\[\033[0;35m\]"
    local PURPLEBOLD="\[\033[1;35m\]"
    local CYAN="\[\033[0;36m\]"
    local CYANBOLD="\[\033[1;36m\]"
    local WHITE="\[\033[0;37m\]"
    local WHITEBOLD="\[\033[1;37m\]"
    export GIT_PS1_SHOWDIRTYSTATE=1
    if [ "$TERM" = "dumb" ] ; then
        export PS1="[\u@\h] [\w] > "
        unset GREP_OPTIONS
    else
        #   PS1="[\u@\h] [\w]\n> "
        local host_name="\h"
        if [[ ! -z $CANONICAL_HOST_NAME ]]; then
            host_name=$CANONICAL_HOST_NAME
        fi

        local host="$GREENBOLD$host_name"
        local user="$REDBOLD\u"
        local pwd="$BLUEBOLD\w"
        local openp="$WHITEBOLD("
        local closep="$WHITEBOLD)"
        local timestamp="$YELLOWBOLD\D{%F %T}"
        local gitbranch="\$(__git_ps1 '$openp$PURPLEBOLD%s$closep')"
        local openb="$WHITEBOLD["
        local closeb="$WHITEBOLD]"
        local atrate="$DEFAULT@"
        local promptsign=">"
        export PS1="$openb$user$atrate$host$closeb $openb$timestamp$closeb $openb$pwd$closeb $gitbranch\n$promptsign $DEFAULT"
    fi
}


function dp () {
    if [[ $1 -eq "1" || $# -eq "0" ]]; then
        export PS1="\033[01;32m$\033[00m "
    elif [[ $1 -eq "2" ]]; then
        export PS1="${debian_chroot:+($debian_chroot)}\w\033[01;32m$\033[00m "
    elif [[ $1 -eq "3" ]]; then
        setup_prompt
    fi
}

setup_prompt
