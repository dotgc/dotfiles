#!/usr/bin/python

import os
import shutil
import subprocess
import argparse
import logging
import util

__author__ = 'Gaurav Chauhan(gauravschauhan1@gmail.com)'

DOTFILES_REPO_HTTP_URL = 'https://dotgc@github.com/dotgc/dotfiles.git'
SPACEMACS_REPO_URL = 'https://github.com/syl20bnr/spacemacs'
GIT_COMPLETION_URL = 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh'

HOME_DIR = os.path.expanduser('~')
FS_DOTFILES_PATH = os.path.join(HOME_DIR, 'dotfiles')
EMACS_LIBS_DIR = os.path.join(HOME_DIR, '.emacs.d')
BACKUP_DIR = os.path.join(HOME_DIR, 'old-dotfiles.backup')

DOTFILES_TO_IGNORE = frozenset(['.gitignore', '.git'])

def setup_dotfiles():
    logging.info('Setting up dotfiles')
    # Create backup directory if needed
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)

    for file_name in os.listdir(FS_DOTFILES_PATH):
        item_path = os.path.join(FS_DOTFILES_PATH, file_name)
        if file_name.startswith('.') and file_name not in DOTFILES_TO_IGNORE:
            # Must be a dotfile. Create symlink
            target_symlink_path = os.path.join(HOME_DIR, file_name)
            if os.path.exists(target_symlink_path):
                shutil.move(target_symlink_path, os.path.join(BACKUP_DIR, target_symlink_path))
                '''
                if os.path.islink(target_symlink_path):
                    os.unlink(target_symlink_path)
                else:
                    shutil.rmtree(target_symlink_path) if os.path.isdir(target_symlink_path) else os.remove(target_symlink_path)
                '''
            try:
                os.symlink(item_path, target_symlink_path)
            except OSError as e:
                logging.info('Found exception creating symlink: %r', e)
            else:
                if os.path.isfile(target_symlink_path):
                    logging.info('Sourcing %s' % file_name)
                    # Symlinking this way doesn't work. This is kind of times that make me want to learn bash scripting
                    # subprocess.call(['source', target_symlink_path])

    logging.info('Dotfiles setup')

def setup_emacs():
    # setup spacemacs
    logging.info('Setting up emacs')
    if os.path.exists(EMACS_LIBS_DIR):
        shutil.rmtree(EMACS_LIBS_DIR)
    subprocess.call(['git', 'clone', SPACEMACS_REPO_URL, EMACS_LIBS_DIR])
    logging.info('Emacs setup done')

def setup_tmux():
    pass

def setup_git():
    pass

def download_dotfiles():
    logging.info('Downloading dotfile')
    if os.path.exists(FS_DOTFILES_PATH):
        shutil.rmtree(FS_DOTFILES_PATH)
    subprocess.call(['git', 'clone', DOTFILES_REPO_HTTP_URL, FS_DOTFILES_PATH])
    logging.info('Dotfiles downloaded---Downloading git prompt now')
    subprocess.call(['curl', GIT_COMPLETION_URL, '-o', os.path.join(HOME_DIR, '.git-prompt.sh')])
    logging.info('git-prompt.sh downloaded')

def revert():
    # delete all symlinks created using this script and setup dotfiles from backup
    pass

def main(args):
    if args.l:
        util.add_stdout_logging()
    else:
        util.add_file_logging()
    download_dotfiles()
    if args.d or not args.a:
        setup_dotfiles()
    if args.e or not args.a:
        setup_emacs()
    if args.t or not args.a:
        setup_tmux()
    if args.g or not args.a:
        setup_git()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Bootstrap dotfiles')
    parser.add_argument('--l', action='store_false', default=True, help='Dump logging to stdout/stderr')
    parser.add_argument('--a', action='store_true', default=False, help='Don\'t setup all')
    parser.add_argument('--d', action='store_true', default=False, help='Explicit setup dotfiles')
    parser.add_argument('--e', action='store_true', default=False, help='Explicit setup emacs')
    parser.add_argument('--t', action='store_true', default=False, help='Explicit setup tmux')
    parser.add_argument('--g', action='store_true', default=False, help='Explicit setup git')
    args = parser.parse_args()

    main(args)
