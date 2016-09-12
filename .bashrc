# Don't do anything if not running interactively
if [[ $- != *i* ]]; then
    return
fi


if [ "$(uname -s)" = "Darwin" ]; then
    OS="OSX"
else
    OS=$(uname -s)
fi


# Source global definitions first so that local ones can override them
if [ -f /etc/bashrc ]; then
	  . /etc/bashrc
fi


# disable START/STOP signal to the terminal. Especially useful when using screen, tmux, byobu
stty -ixon

HISTSIZE=99999            # bash history will save N commands
HISTFILESIZE=${HISTSIZE} # bash will remember N commands
HISTCONTROL=ignoreboth # History options ignore duplicate commands and whitespace in

# Keep the times of the commands in history
HISTTIMEFORMAT='%F %T  '
HISTIGNORE="ls:exit:history:[bf]g:jobs:reset:clear"


shopt -s cdspell # Autocorrect fudged paths in cd calls
shopt -s checkhash # Update the hash table properly
shopt -s checkwinsize # Update columns and rows if window size changes
shopt -s cmdhist # Put multi-line commands onto one line of history
shopt -s dotglob # Include dotfiles in pattern matching
shopt -s extglob # Enable advanced pattern matching
shopt -s histappend # Append rather than overwrite Bash history
# shopt -u hostcomplete # Don't use Bash's builtin host completion
# shopt -u mailwarn # Don't warn me about new mail all the time
# shopt -s no_empty_cmd_completion # Ignore me if I try to complete an empty line
shopt -s progcomp # Use programmable completion, if available
# shopt -s shift_verbose # Warn me if I try to shift when there's nothing there
# shopt -u sourcepath # Don't use PATH to find files to source
complete -d cd # lists only directories with cd <TAB>
# These options only exist since Bash 4.0-alpha
if ((${BASH_VERSINFO[0]} >= 4)); then
    shopt -s checkjobs # Warn me about stopped jobs when exiting
    shopt -s dirspell # Autocorrect fudged paths during completion
    shopt -s globstar # Enable double-starring paths
fi

[ -r "$HOME/.git-prompt.sh" ] && . "$HOME/.git-prompt.sh"

# Source a script if it is executable
function source_script() {
    [[ "${@:-1}" == "force" ]] && FORCE=1
    for script in $*; do
        if [[ -x $script || "$FORCE" == 1 ]]; then
            . $script
        fi
    done
}

# Execute scripts under .bashrc.d
if [[ -d $HOME/lib ]]; then
    source_script "$HOME"/lib/*.bash
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ "$OS" == "OSX" ]]; then
    . "$HOME"/.osx/*.bash
fi


unset -v config

export PATH

unset USERNAME

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
