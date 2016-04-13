# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export GOPATH=$HOME/work/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export ANDROID_HOME=/usr/local/opt/android-sdk
unset USERNAME
export JAVA_HOME=$(/usr/libexec/java_home -v1.8)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
