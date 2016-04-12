# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH
unset USERNAME
export JAVA_HOME=$(/usr/libexec/java_home -v1.8)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
