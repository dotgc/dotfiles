#!/usr/bin/python

import os
import sys
import shutil
import subprocess
import argparse
import logging
import logging.handlers
import warnings

__author__ = 'Gaurav Chauhan(gauravschauhan1@gmail.com)'

DOTFILES_REPO_HTTP_URL = 'https://github.com/ImGauravC/mydotfiles.git'
SPACEMACS_REPO_URL = 'https://github.com/syl20bnr/spacemacs'

HOME_DIR = os.path.expanduser('~')
FS_DOTFILES_PATH = os.path.join(HOME_DIR, 'dotfiles')
EMACS_LIBS_DIR = os.path.join(HOME_DIR, '.emacs.d')

LOG_FORMAT = '[%(filename)-22s:%(lineno)-4d] - %(asctime)s - %(levelname)s - %(message)s'

def init_logging():
    # Python warnings normally go to stderr.  Make them go through logging module instead.
    def my_showwarning(message, category, filename, line, *args, **kwds):
        import logging, warnings, traceback
        logging.warning(warnings.formatwarning(message, category, filename, line) + '\n' + '\n'.join(traceback.format_stack()))

    warnings.showwarning = my_showwarning

def add_file_logging(logname, is_cron=False, shard_id=None, log_backup_count=None, formatter=None):
    init_logging()
    default_backup_count = 500
    if shard_id is not None:
        logname = '%s.%s' % (logname, shard_id)
        default_backup_count = 20
    if not log_backup_count:
        log_backup_count = default_backup_count
    handler = logging.handlers.RotatingFileHandler('%s.log' % logname, maxBytes=20 * 1024 * 1024, backupCount=log_backup_count) if is_cron else logging.FileHandler('%s.log' % logname)
    if formatter is None:
        formatter = logging.Formatter(LOG_FORMAT)
    handler.setFormatter(formatter)
    logging.getLogger().addHandler(handler)
    logging.getLogger().setLevel(logging.INFO)
    if is_cron:
        if handler.shouldRollover(logging.makeLogRecord({'msg': ''})):
            handler.doRollover()

def add_stdout_logging():
    init_logging()
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter(LOG_FORMAT))
    logging.getLogger().addHandler(handler)
    logging.getLogger().setLevel(logging.INFO)

def setup_dotfiles():
    logging.info('Setting up dotfiles')
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
    logging.info('Dotfiles downloaded')

def main(args):
    if args.l:
        add_stdout_logging()
    else:
        add_file_logging()
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
    parser.add_argument('--l', action='store_false', default=True, help='Dump logging to stdout/stderr')
    parser.add_argument('--a', action='store_true', default=False, help='Don\'t setup all')
    parser.add_argument('--d', action='store_false', default=False, help='Setup dotfiles')
    parser.add_argument('--e', action='store_false', default=False, help='Setup emacs')
    parser.add_argument('--t', action='store_false', default=False, help='Setup tmux')
    parser.add_argument('--g', action='store_false', default=False, help='Setup git')
    args = parser.parse_args()

    main(args)

