DEBUG = True
TEMPLATE_DEBUG = DEBUG

DOMAIN_NAME = 'localhost.com'
ALLOWED_HOSTS = ['.localhost.com']
EMAIL_HOST = "smtp.localhost.com"
EMAIL_PORT = 587
EMAIL_BACKEND = 'django.core.mail.backends.filebased.EmailBackend'
EMAIL_FILE_PATH = '/tmp/django-mails/'
EMAIL_SUBJECT_PREFIX = ""
EMAIL_NO_REPLY = 'no-reply@' + DOMAIN_NAME
DEFAULT_FROM_EMAIL = EMAIL_NO_REPLY

ADMINS = (
    ('admin', 'name@domain.tld'),
)

ADMIN_ID = 1

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'nivl',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}

AKISMET_API_KEY = ''  # http://akismet.com/get/

SECRET_KEY = ''

#
# Django pipeline
# http://django-pipeline.readthedocs.org/en/latest/compressors.html
#

PIPELINE_UGLIFYJS_BINARY = '/usr/bin/uglifyjs'
PIPELINE_CSSTIDY_BINARY = '/usr/bin/csstidy'
PIPELINE_YUI_BINARY = '/usr/bin/yuicompressor'
PIPELINE_LESS_BINARY = '/usr/bin/lessc'

PIPELINE_JS_COMPRESSOR = 'pipeline.compressors.uglifyjs.UglifyJSCompressor'
PIPELINE_CSS_COMPRESSOR = 'pipeline.compressors.cssmin.CssminCompressor'
