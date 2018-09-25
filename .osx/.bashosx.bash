if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
    . $(brew --prefix)/share/bash-completion/bash_completion
fi

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
fi


export CLICOLOR=1
# get rid of .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -delete'


export HOMEBREW_NO_ANALYTICS=1  # alternatively, brew analytics off

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


export PATH="/usr/local/sbin:$PATH"
