# Don't do anything if not running interactively
if [[ $- != *i* ]]; then
    return
fi

# disable START/STOP signal to the terminal. Especially useful when using screen, tmux, byobu
stty -ixon

# History options ignore duplicate commands and whitespace in history
HISTCONTROL=ignoreboth

# Keep the times of the commands in history
HISTTIMEFORMAT='%F %T  '

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

# These options only exist since Bash 4.0-alpha
if ((${BASH_VERSINFO[0]} >= 4)); then
    shopt -s checkjobs # Warn me about stopped jobs when exiting
    shopt -s dirspell # Autocorrect fudged paths during completion
    shopt -s globstar # Enable double-starring paths
fi

# Source a script if it is executable
source_script() {
    [[ "${@:-1}" == "force" ]] && FORCE=1
    for script in $*; do
        if [[ -x $script || "$FORCE" == 1 ]]; then
            source $script
        fi
    done
}


# Execute scripts under .bashrc.d
if [[ -d $HOME/.bashrc.d ]]; then
    source_script "$HOME"/.bashrc.d/*.bash
fi


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

unset -v config


export PATH

unset USERNAME
