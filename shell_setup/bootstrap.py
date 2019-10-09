#!/usr/bin/python

import os
import shutil
import subprocess
import argparse
import logging
import util
import time
import stat

__author__ = 'Gaurav Chauhan(gauravschauhan1@gmail.com)'

DOTFILES_REPO_HTTP_URL = 'https://dotgc@github.com/dotgc/dotfiles.git'
SPACEMACS_REPO_URL = 'https://github.com/syl20bnr/spacemacs'
GIT_COMPLETION_URL = 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh'
VUNDLE_REPO_URL = 'https://github.com/VundleVim/Vundle.vim.git'

HOME_DIR = os.path.expanduser('~')

FS_DOTFILES_PATH = os.path.join(HOME_DIR, 'dotfiles')
LIB_DIR_PATH = os.path.join(FS_DOTFILES_PATH, '.lib')
BIN_DIR_PATH = os.path.join(FS_DOTFILES_PATH, 'bin')

EMACS_LIBS_DIR = os.path.join(HOME_DIR, '.emacs.d')
VIM_DIRECTORY = os.path.join(HOME_DIR, '.vim')
BACKUP_DIR = os.path.join(HOME_DIR, 'old-dotfiles.backup')
VUNDLE_PATH = os.path.join(VIM_DIRECTORY, 'bundle/Vundle.vim')

DOTFILES_TO_IGNORE = set(['.gitignore', '.git', '.vscode'])

LOCAL_BASH_PROFILE_PRE_NAME = '.bash_profile_pre.local'
LOCAL_BASH_PROFILE_POST_NAME = '.bash_profile_post.local'

def pre_setup():
    if 'OS' in os.environ:
        os_name = os.environ['OS']
        if os_name == 'OSX':
            DOTFILES_TO_IGNORE.add('.osx')

def setup_dotfiles():
    logging.info('Setting up dotfiles...')
    # Create backup directory if needed
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)

    for file_name in get_dotfile_names_iterator():
        # Must be a dotfile. Create symlink
        target_symlink_path = os.path.join(HOME_DIR, file_name)
        if os.path.exists(target_symlink_path):
            shutil.move(target_symlink_path, os.path.join(BACKUP_DIR, target_symlink_path))
            time.sleep(0.3)
            '''
            if os.path.islink(target_symlink_path):
                os.unlink(target_symlink_path)
            else:
                shutil.rmtree(target_symlink_path) if os.path.isdir(target_symlink_path) else os.remove(target_symlink_path)
            '''

        item_path = os.path.join(FS_DOTFILES_PATH, file_name)
        success = create_symlink(item_path, target_symlink_path)
        if success:
            logging.info("Symlinked file: %s", file_name)
            if os.path.isfile(target_symlink_path):
                pass
                # Symlinking this way doesn't work because this sources the files in the child process.
                # This is kind of times that make me want to learn bash scripting
                # For the time, just source ~/.bash_profile once after setup
                # subprocess.call(['source', target_symlink_path])
        else:
            logging.info('Found exception creating symlink: %r for file: %s', e, file_name)

    create_local_bash_file(LOCAL_BASH_PROFILE_PRE_NAME)
    create_local_bash_file(LOCAL_BASH_PROFILE_POST_NAME)
    logging.basicConfig
    logging.info('Dotfiles setup')
    logging.info('Please source dotfiles using source ~/.bash_profile')


def get_dotfile_names_iterator():
    for file_name in os.listdir(FS_DOTFILES_PATH):
        if file_name.startswith('.') and file_name not in DOTFILES_TO_IGNORE:
            yield file_name

def remove_symlinks():
    for file_name in get_dotfile_names_iterator():
        path_to_remove = os.path.join(HOME_DIR, file_name)
        if os.path.exists(path_to_remove):
            logging.info("removing already existing symlink for file: %s", file_name)
            os.remove(path_to_remove)


def create_symlink(item_path, target_symlink_path):
    try:
        os.symlink(item_path, target_symlink_path)
        return True
    except OSError as e:
        return False

def create_local_bash_file(file_name):
    logging.info('Creating local bash profile...')
    file_path = os.path.join(FS_DOTFILES_PATH, file_name)
    if not os.path.exists(file_path):
        with open(file_path, 'w') as f:
            f.write("# Keep your local machine specific bash settings here. This is not version controlled")
        target_symlink_path = os.path.join(HOME_DIR, file_name)
        success = create_symlink(file_path, target_symlink_path)
        if not success:
            logging.info('Found exception creating symlink: %r for file: %s', e, file_name)


def make_executable():
    user_perms = stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR
    group_perms = stat.S_IRGRP | stat.S_IXGRP
    others_perms = stat.S_IROTH | stat.S_IXOTH
    perms_bit = user_perms | group_perms | others_perms
    for file_path in get_dotfile_names_iterator():
        os.chmod(file_path, perms_bit)

    for file_name in os.listdir(LIB_DIR_PATH):
        os.chmod(os.path.join(LIB_DIR_PATH, file_name), perms_bit)

    for file_name in os.listdir(BIN_DIR_PATH):
        os.chmod(os.path.join(BIN_DIR_PATH, file_name), perms_bit)


def setup_emacs():
    # setup spacemacs
    logging.info('Setting up emacs')
    if os.path.exists(EMACS_LIBS_DIR):
        shutil.rmtree(EMACS_LIBS_DIR)
    subprocess.call(['git', 'clone', SPACEMACS_REPO_URL, EMACS_LIBS_DIR])
    logging.info('Emacs setup done')

def setup_vim():
    logging.info('Setting up vim')
    if not os.path.exists(VUNDLE_PATH):
        subprocess.call(['git', 'clone', VUNDLE_REPO_URL, VUNDLE_PATH])
    logging.info('Vim - vundle setup')


def setup_tmux():
    pass

def setup_git():
    pass

def download_dotfiles():
    logging.info('Downloading dotfile')
    if os.path.exists(FS_DOTFILES_PATH):
        logging.info("dotfiles exists. re-download? (y/n) - default y")
        ans = raw_input() or 'y'
        if ans == 'y':
            shutil.rmtree(FS_DOTFILES_PATH)
            subprocess.call(['git', 'clone', DOTFILES_REPO_HTTP_URL, FS_DOTFILES_PATH])
            logging.info('Dotfiles downloaded --- Downloading git prompt now')
        else:
            logging.info('not downloading dotfiles again')
    subprocess.call(['curl', GIT_COMPLETION_URL, '-o', os.path.join(HOME_DIR, '.git-prompt.sh')])
    logging.info('git-prompt.sh downloaded')

def revert():
    # delete all symlinks created using this script and setup dotfiles from backup
    pass

def main(args):
    pre_setup()
    util.add_stdout_logging()
    if args.f:
        util.add_file_logging()

    download_dotfiles()

    if args.d or args.a:
        remove_symlinks()
        setup_dotfiles()
        make_executable()
    if args.e or args.a:
        setup_emacs()
    if args.t or args.a:
        setup_tmux()
    if args.g or args.a:
        setup_git()
    if args.v or args.a:
        setup_vim()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Bootstrap dotfiles')
    parser.add_argument('--f', action='store_true', default=False, help='Dump logging to file')

    parser.add_argument('--a', action='store_true', default=False, help='Setup all')

    parser.add_argument('--d', action='store_true', default=False, help='Setup dotfiles')
    parser.add_argument('--e', action='store_true', default=False, help='Setup emacs')
    parser.add_argument('--v', action='store_true', default=False, help='Setup vim')
    parser.add_argument('--t', action='store_true', default=False, help='Setup tmux')
    parser.add_argument('--g', action='store_true', default=False, help='Setup git')

    args = parser.parse_args()

    main(args)
