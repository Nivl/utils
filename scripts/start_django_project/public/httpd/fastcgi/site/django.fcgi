#!/usr/bin/python
import os, sys

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', '..', '??PROJECT_NAME??'))

os.environ['DJANGO_SETTINGS_MODULE'] = '??PROJECT_NAME??.settings'

from django.core.servers.fastcgi import runfastcgi
runfastcgi(method='threaded', daemonize='false')
