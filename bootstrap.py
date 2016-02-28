#!/usr/bin/python

import os
import sys
import shutil
import subprocess
import argparse
import logging

__author__ = 'Gaurav Chauhan(gauravschauhan1@gmail.com)'

DOTFILES_REPO_HTTP_URL = 'https://github.com/ImGauravC/mydotfiles.git'
SPACEMACS_REPO_URL = 'https://github.com/syl20bnr/spacemacs'

HOME_DIR = os.path.expanduser('~')
FS_DOTFILES_PATH = os.path.join(HOME_DIR, 'dotfiles')
EMACS_LIBS_DIR = os.path.join(HOME_DIR, '.emacs.d')

def setup_dotfiles():
    for file_name in os.listdir(FS_DOTFILES_PATH):
        item_path = os.path.join(FS_DOTFILES_PATH, file_name)
        if file_name.startswith('.'):
            # Must be a dotfile. Create symlink
            target_symlink_path = os.path.join(HOME_DIR, file_name)
            if os.path.exists(target_symlink_path):
                if os.path.islink(target_symlink_path):
                    os.unlink(target_symlink_path)
                else:
                    shutil.rmtree(target_symlink_path) if os.path.isdir(target_symlink_path) else os.remove(target_symlink_path)
            try:
                os.symlink(item_path, target_symlink_path)
            except OSError as e:
                logging.info('Found exception creating symlink: %r', e)

def setup_emacs():
    # setup spacemacs
    if os.path.exists(EMACS_LIBS_DIR):
        shutil.rmtree(EMACS_LIBS_DIR)
    subprocess.call(['git', 'clone', SPACEMACS_REPO_URL, EMACS_LIBS_DIR])

def setup_tmux():
    pass

def setup_git():
    pass

def download_dotfiles():
    if os.path.exists(FS_DOTFILES_PATH):
        shutil.rmtree(FS_DOTFILES_PATH)
    subprocess.call(['git', 'clone', DOTFILES_REPO_HTTP_URL, FS_DOTFILES_PATH])

def main(args):
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
    parser = argparse.ArgumentParser('Bootstrap dotfiles')
    parser.add_argument('--a', action='store_true', default=False, help='Don\'t setup all')
    parser.add_argument('--d', action='store_false', default=False, help='Setup dotfiles')
    parser.add_argument('--e', action='store_false', default=False, help='Setup emacs')
    parser.add_argument('--t', action='store_false', default=False, help='Setup tmux')
    parser.add_argument('--g', action='store_false', default=False, help='Setup git')
    args = parser.parse_args()

    main(args)

