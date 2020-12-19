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
    (f"{j40}/vimpacks",         f"{home}/.vim/pack/j40"),
    (f"{j40}/config/qtile",     f"{home}/.config/qtile/config.py"),
    (f"{j40}/config/termite",   f"{home}/.config/termite/config"),
    (f"{j40}/config/git",       f"{home}/.gitconfig"),
    (f"{j40}/config/ipython",   f"{home}/.ipython/profile_default/ipython_config.py"),
    (f"{j40}/config/starship",  f"{home}/.config/starship.toml")
)

# get datetime for backup
timestamp = strftime('%Y-%m-%d_%H-%M-%S', localtime())
backup = f"{j40}/backup/{timestamp}" 
os.mkdir(backup)

# function to setup individual
# config files
def set_config(src, dst):

    # get directory name
    dirname = os.path.dirname(dst)

    # create folder if it does
    # not exist
    if not os.path.isdir(dirname):
        os.mkdirs(dirname)

    # if link does exist and is
    # also the correct symlink, 
    # do nothing
    elif os.path.islink(dst) and os.path.realpath(dst) == src:
        return

    # if folder and link do exist
    # and are not the correct link,
    # make a backup
    elif os.path.exists(dst):
        filename = os.path.basename(dst)
        os.rename(dst, f"{backup}/{filename}")

    # if the link does not exist
    # or is the incorrect link
    # (implicit from previous ifs),
    # symlink the new one
    os.symlink(src, dst)

    return


# execute function for every
# config file
for src, dst in config_files:
    set_config(src, dst)

