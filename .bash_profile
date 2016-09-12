# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

unset USERNAME
