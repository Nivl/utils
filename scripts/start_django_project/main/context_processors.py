from django.contrib.sites.models import Site


def app(context):
    return {'DOMAIN_NAME': Site.objects.get_current().domain}
