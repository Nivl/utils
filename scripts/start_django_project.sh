#!/bin/bash
## Comment:     Start a new django project
##
## Project:
## Started by   Melvin Laplanche <melvin.laplanche+dev@gmail.com>
## On           September 09 2013 at 03:56 PM

function start_django_project() {
    local OPTIND
    local project_name=""
    local remote_path=""
    local resume=false
    local error=false

    type git >/dev/null 2>&1 || { put_error "git is required."; error=true; }
    type mkvirtualenv >/dev/null 2>&1 || { put_error "virtualenvwrapper is required."; error=true; }
    type grunt >/dev/null 2>&1 || { put_error "grunt is required."; error=true; }
    type python2.7 >/dev/null 2>&1 || { put_error "python2.7 is required."; error=true; }
    type unzip >/dev/null 2>&1 || { put_error "unzip is required."; error=true; }

    if $error ; then
        return 1
    fi

    while getopts "n:g:rh" options; do
        case $options in
            n)
                project_name=$OPTARG
                ;;
            g)
                remote_path=$OPTARG
                ;;
            r)
                resume=true
                ;;
            h)
                echo "usage: start_project -n projectName [-g remotePath] [-r] [-h]"
                return 0
                ;;
        esac
    done


    if [ -z $1 ]; then
        echo "usage: start_project -n projectName [-g remotePath] [-r]"
        return 1;
    fi

    local dest_path=`pwd`/$project_name
    local script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local tmp_path="/tmp/start_project/${RANDOM}-$project_name"

    mkdir -p $dest_path >/dev/null 2>&1
    if [ $? -ne 0 ]; then
       put_error "$dest_path not writable"
       return 1;
    fi

    mkdir -p $tmp_path >/dev/null 2>&1
    if [ $? -ne 0 ]; then
       put_error "$tmp_path not writable"
       return 1;
    fi

    cd $dest_path
    put_info "Setting up the environment"
    touch README.md requirements.txt

    mkvirtualenv $project_name --python=`command -v python2.7`
    workon $project_name
    pip install django #django-bootstrap-form django-pipeline South akismet cssmin django-js-utils==0.0.5dev pytz==2013d hamlpy PIL MySQL-python johnny-cache
    if [ $? -ne 0 ]; then
       put_error "An error occured when installing python packages."
       return 1
    fi

    put_info "Setting up django"
    django-admin.py startproject $project_name
    cd $dest_path/$project_name/

    mkdir -p locale

    cd $project_name
    mkdir -p settings
    mv settings.py settings/commons.py
    cp $script_path/${FUNCNAME[0]}/settings/*.py settings
    cp $script_path/${FUNCNAME[0]}/main/*.py .
    # Update urls.py
    # Enable the admin
    sed -e 's|# from|from|' -e 's|# admin|admin|' -e "s|# url(r'^admin/'|url(r'^admin/'|" urls.py > urls.py.new && mv urls.py.new urls.py
    # Add django-js-utils
    sed "$ i\    url(r'^jsurls.js$', 'django_js_utils.views.jsurls', {}, 'jsurls')," urls.py > urls.py.new && mv urls.py.new urls.py
    # Add the proper import (needed by urls.py,part)
    sed -e '1 a\from commons.views import TexplainView' -e '1 a\from django.views.generic.base import RedirectView' urls.py > urls.py.new && mv urls.py.new urls.py
    cat $script_path/${FUNCNAME[0]}/main/urls.py.part >> urls.py

    mkdir -p static_files/vendors/bootstrap
    mkdir -p static_files/static/commons/{css,fonts,img,js}
    cp $script_path/${FUNCNAME[0]}/fonts/* static_files/static/commons/fonts/
    cp $script_path/${FUNCNAME[0]}/less/* static_files/static/commons/css/app/

    mkdir templates
    cp $script_path/${FUNCNAME[0]}/base_tpl/* templates

    put_info "Installing twitter bootstrap"
    local bootstrap_path="$dest_path/$project_name/$project_name/static_files/vendors/bootstrap"
    local font_path="$dest_path/$project_name/$project_name/static_files/static/commons/fonts/"
    git clone https://github.com/twbs/bootstrap.git $tmp_path/bootstrap
    cd ${tmp_path}/bootstrap
    cp -rf less $bootstrap_path
    cp -rf js $bootstrap_path
    cp *.js $bootstrap_path
    cp package.json $bootstrap_path
    cd ${bootstrap_path}/js
    rm -rf tests
    cd ..
    npm install
    grunt dist

    put_info "Installing font-awesome"
    cd $tmp_path
    wget http://fontawesome.io/assets/font-awesome.zip
    unzip font-awesome.zip
    cd font-awesome
    cp -rf less ${bootstrap_path}/less/font-awesome
    sed 's|"../font"|"../../commons/fonts"|' less/variables.less > ${bootstrap_path}/less/variables.less
    cp font/* $font_path
    cd ${tmp_path}/bootstrap
    sed 's|"glyphicons.less"|"font-awesome/font-awesome.less"|' less/bootstrap.less > ${bootstrap_path}/less/bootstrap.less

    if [ $# -eq 2 ] && [ -z $2 ]; then
        cd $dest_path
        put_info "Setting up the git repository"
        git init
        git add README.md requirements.txt $project_name
        git remote add origin $remote_path

        if [ $? -ne 0 ]; then
           put_error "An error occured when creating and pushing the git repository."
        fi
    fi

    cd $dest_path
    put_info "You can now edit the configuration files"
    return 0
}
