from commons import *

#
# Johnny cache
#

MIDDLEWARE_CLASSES = (
    'johnny.middleware.LocalStoreClearMiddleware',
    'johnny.middleware.QueryCacheMiddleware',
) + MIDDLEWARE_CLASSES


CACHES = {
    'default': dict(BACKEND='johnny.backends.memcached.MemcachedCache',
                    LOCATION=['127.0.0.1:11211'],
                    JOHNNY_CACHE=True,
                    )
}

JOHNNY_MIDDLEWARE_KEY_PREFIX = 'jc_??PROJECT_NAME??'

#
# Django pipeline
#

INSTALLED_APPS += ('pipeline',)

PIPELINE_COMPILERS = (
    'pipeline.compilers.less.LessCompiler',
)

PIPELINE_LESS_ARGUMENTS = '-x'

STATICFILES_STORAGE = 'pipeline.storage.PipelineCachedStorage'

PIPELINE_JS = {
    'assets': {'source_filenames': ('django_js_utils.js',
                                    'js/*.js',
                                    'bootstrap/js/bootstrap.min.js',
                                    ),
               'output_filename': 'commons/compiled/assets.js',
               },

    'main': {'source_filenames': ('commons/js/app/misc/utils/*.js',
                                  'commons/js/app/misc/funcs/*.js',
                                  'commons/js/app/misc/reload.js',

                                  'commons/js/app/*.js',

                                  ),
             'output_filename': 'commons/compiled/scripts.js',
             },
}

PIPELINE_CSS = {
    'assets': {'source_filenames': ('bootstrap/css/bootstrap.min.css',
                                    ),
               'output_filename': 'commons/compiled/assets.css',
               'variant': 'datauri',
               },

    'main': {'source_filenames': ('commons/css/app/main.less',
                                  'commons/css/app/main-responsive.less',
                                  ),
             'output_filename': 'commons/compiled/styles.css',
             'variant': 'datauri',
             },


    'error': {'source_filenames': ('bootstrap/css/bootstrap.min.css',
                                   'commons/css/app/error.less',
                                   ),
              'output_filename': 'commons/compiled/error.css',
              'variant': 'datauri',
              },
}

PIPELINE = not DEBUG
PIPELINE_DISABLE_WRAPPER = True


#
# Hamlpy
#

HAMLPY_ATTR_WRAPPER = '"'

if not DEBUG:
    TEMPLATE_LOADERS = (
        ('django.template.loaders.cached.Loader', (
            'hamlpy.template.loaders.HamlPyFilesystemLoader',
            'hamlpy.template.loaders.HamlPyAppDirectoriesLoader',
            )),
        ) + TEMPLATE_LOADERS
else:
    TEMPLATE_LOADERS = (
        'hamlpy.template.loaders.HamlPyFilesystemLoader',
        'hamlpy.template.loaders.HamlPyAppDirectoriesLoader',
        ) + TEMPLATE_LOADERS


#
# Others
#

INSTALLED_APPS += (
    'bootstrapform',
    'django_js_utils',
    'south',
)
