# Get the aliases and functions
if [ -f ~/.bash_profile_pre.local ]; then
  . ~/.bash_profile_pre.local
fi


if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.bash_profile_post.local ]; then
  . ~/.bash_profile_post.local
fi

unset USERNAME
