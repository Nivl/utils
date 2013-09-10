#!/bin/bash
## Comment:     Unlock config files
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           April 03 2011 at 01:52 PM

function lock() {
    su -c "chown root:users ${HOME}/.bashrc;
    chown root:users ${HOME}/.bash_profile;
    chown root:users ${HOME}/.local/bin -R"
    return 0
}
