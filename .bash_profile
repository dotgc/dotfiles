# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

export HOMEBREW_NO_ANALYTICS=1  # alternatively, brew analytics off

unset USERNAME
