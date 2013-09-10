#!/bin/bash
## Comment:     Recursively source all sh files of a directory
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           June 29 2011 at 10:24 PM

source_functions() {
    if [ -d $1 ]; then
        for f in $1/*; do
            if [ -d $f ]; then
                source_functions $f
            else
                if [ ${f/*./} == "sh" ]; then
                    source $f
                fi
            fi
        done
        return 0
    fi

    put_error "$1 is not a directory"
    return 1
}
