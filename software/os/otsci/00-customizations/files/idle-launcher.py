#!/usr/bin/python3

from idlelib.pyshell import main
from pathlib import Path

import os

workdir = Path('/run/user') / str(os.getuid()) / 'lg' / str(os.getpid())

workdir.mkdir(parents=True, exist_ok=True)

os.environ['LG_WD'] = str(workdir)

if __name__ == '__main__':
    main()
