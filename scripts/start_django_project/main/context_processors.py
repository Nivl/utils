from django.conf import settings


def app(context):
    return {'DOMAIN_NAME': settings.DOMAIN_NAME}
