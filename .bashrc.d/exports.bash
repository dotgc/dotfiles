export PROMPT_COMMAND='
if [ $TERM = "screen" ]; then echo -ne "\033k${USER}@${HOSTNAME}\033\\"; fi;
'

# User specific aliases and functions
export EDITOR=emacs
export ANDROID_NDK=~/android-ndk-r10e
export PATH=$PATH:$HOME/bin:/sbin:/usr/sbin:/usr/local/mysql/bin:/usr/local/bin:/usr/share/phabricator/arcanist/bin:$HOME/code/setup/dotfiles/bin
export ROOT=$HOME/code
export PYTHONPATH=$PYTHONPATH:$ROOT/python:$ROOT/python/stubs:.
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
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
        local user="$REDBOLD\u"
        local host="$DEFAULT\h"
        local pwd="$BLUEBOLD\w"
        local openp="$DEFAULT("
        local closep="$DEFAULT)"
        local gitbranch="\$(__git_ps1 '$openp$PURPLEBOLD%s$closep')"
        local openb="$DEFAULT["
        local closeb="$DEFAULT]"
        export PS1="$openb$user$DEFAULT@$host$closeb $openb$pwd$closeb $gitbranch\n$WHITEBOLD$BLUEBOLD$ $DEFAULT"
    fi
}

setup_prompt
