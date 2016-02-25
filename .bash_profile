# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
. ssh_setup

PATH=$PATH:$HOME/bin
EDITOR=emacsclient
export PATH

unset USERNAME

alias em='emacsclient'
