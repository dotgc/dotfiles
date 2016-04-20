if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
    . $(brew --prefix)/share/bash-completion/bash_completion
fi

export CLICOLOR=1
# get rid of .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -delete'
