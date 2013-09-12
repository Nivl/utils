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


    if [ -d "$dest_path" ]; then
        put_error "The directory $dest_path already exists."
        return 1
    fi

    if [ ! -z `lsvirtualenv | grep $project_name` ]; then
        put_error "The virtual environement $project_name already exists."
        return 1
    fi

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
    touch README.md

    mkvirtualenv $project_name --python=`command -v python2.7`
    workon $project_name
    pip install django django-js-utils==0.0.5dev django-bootstrap-form django-pipeline South akismet cssmin pytz==2013d hamlpy PIL MySQL-python johnny-cache
    if [ $? -ne 0 ]; then
       put_error "An error occured when installing python packages."
       return 1
    fi
    pip freeze > requirements.txt

    put_info "Setting up django"
    django-admin.py startproject $project_name
    cd $dest_path
    cp -rf ${script_path}/${FUNCNAME[0]}/public/ .
    cd public/httpd
    find . -type f | xargs sed -i "s/??PROJECT_NAME??/$project_name/g"

    cd ${dest_path}/${project_name}
    mkdir -p locale
    cp -rf ${script_path}/${FUNCNAME[0]}/apps/commons .

    cd $project_name
    rm -f settings.py
    mkdir -p settings
    cp ${script_path}/${FUNCNAME[0]}/settings/*.py settings
    find settings -type f | xargs sed -i "s/??PROJECT_NAME??/$project_name/g"
    cp ${script_path}/${FUNCNAME[0]}/main/*.py .
    # Update urls.py
    # Enable the admin
    sed -e 's|# from|from|' -e 's|# admin|admin|' -e "s|# url(r'^admin/'|url(r'^admin/'|" urls.py > urls.py.tmp && mv urls.py.tmp urls.py
    # Add django-js-utils
    sed "$ i\    url(r'^jsurls.js$', 'django_js_utils.views.jsurls', {}, 'jsurls')," urls.py > urls.py.tmp && mv urls.py.tmp urls.py
    # Add the proper import (needed by urls.py,part)
    sed -e '1 a\from commons.views import TexplainView' -e '1 a\from django.views.generic.base import RedirectView' urls.py > urls.py.tmp && mv urls.py.tmp urls.py
    cat $script_path/${FUNCNAME[0]}/main/urls.py.part >> urls.py
    sed "s|??PROJECT_NAME??|$project_name|" urls.py > urls.py.tmp && mv urls.py.tmp urls.py

    mkdir -p static_files/vendors/bootstrap
    mkdir -p static_files/static/commons/{css/app,fonts,img,js}
    cp $script_path/${FUNCNAME[0]}/fonts/* static_files/static/commons/fonts/
    cp $script_path/${FUNCNAME[0]}/less/* static_files/static/commons/css/app/
    cp -rf $script_path/${FUNCNAME[0]}/js/* static_files/static/commons/js/

    mkdir templates
    cp -rf $script_path/${FUNCNAME[0]}/base_tpl/* templates

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

    if [ ! -z $remote_path ]; then
        cd $dest_path
        put_info "Setting up the git repository"
        git init
        git add README.md requirements.txt $project_name public
        git remote add origin $remote_path
        git commit -m "First commit"
        git push -u origin master

        if [ $? -ne 0 ]; then
           put_error "An error occured when creating and pushing the git repository."
        fi
    fi

    cd $dest_path
    put_info "You can now edit the configuration files"
    return 0
}
