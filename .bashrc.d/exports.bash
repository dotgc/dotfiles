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

# easy conflict resolver
export SVN_MERGE=/var/store/code/setup/dotfiles/bin/mergewrap.py
