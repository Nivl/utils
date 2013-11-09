"""
Django settings for ??PROJECT_NAME?? project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

import os
from private import *

BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Uncomment the following for a user system
# AUTH_PROFILE_MODULE = 'user_profile.UserProfile'
# LOGIN_REDIRECT_URL = '/'
# LOGIN_ERROR_URL = '/accounts/sign-in/fail/'
# LOGIN_URL = '/accounts/sign-in/'
# ABSOLUTE_URL_OVERRIDES = {
#     'auth.user': lambda o: "/accounts/view/%s/" % o.username,
# }

DEFAULT_FILE_STORAGE = "commons.storage.UniqueFileSystemStorage"

ROOT_URLCONF = '??PROJECT_NAME??.urls'

LOCALE_PATHS = (
    os.path.abspath(os.path.join(os.path.dirname(__file__),
       '..', '..', 'locale')),
)

SESSION_COOKIE_DOMAIN = '.' + DOMAIN_NAME
MAX_UPLOAD_SIZE = 5242880
MANAGERS = ADMINS

USE_TZ = True
TIME_ZONE = 'America/Los_Angeles'
LANGUAGE_CODE = 'en'
DATE_FORMAT = 'F, d Y'
TIME_FORMAT = 'P'
USE_I18N = True
USE_L10N = True


MEDIA_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', 'public', 'media'))
MEDIA_URL = 'http://media.' + DOMAIN_NAME + '/'

STATIC_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '..', '..', '..', 'public', 'static'))
STATIC_URL = 'http://static.' + DOMAIN_NAME + '/'
ADMIN_MEDIA_PREFIX = STATIC_URL + "admin/"  # rm when 1.4

STATICFILES_DIRS = (
    os.path.abspath(os.path.join(BASE_DIR, '..', 'static_files', 'static')),
    os.path.abspath(os.path.join(BASE_DIR, '..', 'static_files', 'vendors', 'bootstrap', 'dist', 'static')),
)


TEMPLATE_CONTEXT_PROCESSORS = (
    'django.contrib.auth.context_processors.auth',
    'django.core.context_processors.debug',
    'django.core.context_processors.request',
    'django.core.context_processors.i18n',
    'django.core.context_processors.media',
    'django.core.context_processors.static',
    'django.core.context_processors.tz',
    'django.contrib.messages.context_processors.messages',
    '??PROJECT_NAME??.context_processors.app',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.gzip.GZipMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'logger.middleware.LoggerMiddleware',
    '??PROJECT_NAME??.middleware.Http405Middleware',
)

TEMPLATE_DIRS = (
    os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "templates"))
)

AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend',
)

INSTALLED_APPS = (
    'django.contrib.humanize',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.sitemaps',
    'django.contrib.admin',
)
