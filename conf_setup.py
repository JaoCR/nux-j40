#!/usr/bin/python

# Do not move this file from the project root!

import os
from time import localtime, strftime

# get path
j40  = os.path.dirname(os.path.abspath(__file__))
home = os.path.expanduser('~')

# config files
config_files = (
    (f"{j40}/config/fish",      f"{home}/.config/fish/conf.d/j40.fish"),
    (f"{j40}/config/vim",       f"{home}/.vimrc"),
    (f"{j40}/config/qtile",     f"{home}/.config/qtile/config.py"),
    (f"{j40}/config/termite",   f"{home}/.config/termite/config"),
    (f"{j40}/config/git",       f"{home}/.gitconfig"),
    (f"{j40}/config/ipython",   f"{home}/.ipython/profile_default/ipython_config.py")
)

# get datetime for backup
timestamp = strftime('%Y-%m-%d_%H-%M-%S', localtime())
backup = f"{j40}/backup/{timestamp}" 
os.mkdir(backup)

for src, dst in config_files:

    # move the old file to the backup directory
    name = dst.split('/')[-1]
    os.rename(dst, f"{backup}/{name}")

    # symlink the new one
    os.symlink(src, dst)

    

