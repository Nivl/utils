#!/bin/bash
## Comment:     Unlock config files
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           April 03 2011 at 01:52 PM

function unlock() {
    if [ ${HOME} == "/root" ]; then
        put_error "You are already root!"
        return 1;
    fi

    su -c "chown nivl:users ${HOME}/.bashrc;
    chown nivl:users ${HOME}/.bash_profile;
    chown nivl:users ${HOME}/.local/bin -R"
    return 0
}
