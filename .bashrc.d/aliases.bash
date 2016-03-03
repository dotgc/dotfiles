
# standard ubuntu aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ll'
alias gitup='git stash; git pull --rebase; git stash pop'
alias gitst='git status; echo "------STASHES------"; git stash list | head '
alias diskspace="du -S | sort -n -r | more"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   <command>; alert. For example: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias hosts='sudo $EDITOR /etc/hosts'
alias source_bash='. ~/.bash_profile'
alias histg="history | grep"
alias top="htop"
alias ..='cd ..'
alias ...='cd ../..'
