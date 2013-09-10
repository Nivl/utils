#!/bin/bash
## Comment:     Helper to checkout a svn/git/hg repo.
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           January 05 2012 at 03:44 PM

function epitech_get_repo() {
    if [ $# != 2 ] || [ -z $1 ] || [ -z $2 ]; then
        echo "usage: epitech_get_repo type name"
        return 1;
    fi

    local type=${1,,}
    local repo=$2

    case $type in
        "git") git clone kscm@koala-rendus.epitech.net:$repo ;;
        "hg") hg clone ssh://kscm@koala-rendus.epitech.net/$repo ;;
        "svn") svn checkout svn+ssh://kscm@koala-rendus.epitech.net/$repo ;;
        *)
            put_error "$type are not supported. The supported DRCS are svn, git, and hg"
            return 1
            ;;
    esac

    return 0
}

