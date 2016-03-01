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

export GIT_PS1_SHOWDIRTYSTATE=1
if [ "$TERM" = "dumb" ] ; then
    export PS1="[\u@\h] [\w] > "
    unset GREP_OPTIONS
else
    #   PS1="[\u@\h] [\w]\n> "
    export PS1="\[\033[01;37m\][\[\033[01;31m\]\u\[\033[01;37m\]@\[\033[01;32m\]\h\[\033[01;37m\]] [\[\033[01;34m\]\w\[\033[01;37m\]]\[\033[0;34m\]\$(__git_ps1 ' (%s)')\n\[\033[01;37m\]$ \[\033[00m\]"
fi
