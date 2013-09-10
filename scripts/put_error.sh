#!/bin/bash
## Comment:     Display an error
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           June 29 2011 at 06:53 PM

function put_error() {
    echo -en  >&2 "\033[01;31m"
    echo  >&2 $@
    echo -en  >&2 "\033[00m"
    return 0
}
