#!/usr/bin/python

import sys
import logging
import logging.handlers
import warnings

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
