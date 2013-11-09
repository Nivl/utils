from django.conf import settings
from models import Logger404


def _is_ignorable_404(uri):
    """
    Returns True if a 404 at the given URL *shouldn't* notify the site managers.
    """
    if getattr(settings, 'IGNORABLE_404_STARTS', ()):
        import warnings
        warnings.warn('The IGNORABLE_404_STARTS setting has been deprecated '
                      'in favor of IGNORABLE_404_URLS.', DeprecationWarning)
        for start in settings.IGNORABLE_404_STARTS:
            if uri.startswith(start):
                return True
    if getattr(settings, 'IGNORABLE_404_ENDS', ()):
        import warnings
        warnings.warn('The IGNORABLE_404_ENDS setting has been deprecated '
                      'in favor of IGNORABLE_404_URLS.', DeprecationWarning)
        for end in settings.IGNORABLE_404_ENDS:
            if uri.endswith(end):
                return True
    return any(pattern.search(uri) for pattern in settings.IGNORABLE_404_URLS)


class LoggerMiddleware():
    def process_response(self, request, response):
        if response.status_code == 404 and \
                not _is_ignorable_404(request.get_full_path()):
            l, _ = Logger404.objects.get_or_create(
                url=request.build_absolute_uri(),
                defaults={
                    'host': request.META.get('HTTP_HOST', ''),
                    'referer': request.META.get('HTTP_REFERER', ''),
                    'user_agent': request.META.get('HTTP_USER_AGENT', ''),
                    'remote_addr': request.META.get('REMOTE_ADDR', ''),
                    'remote_host': request.META.get('REMOTE_HOST', ''),
                    'method': request.META.get('REQUEST_METHOD', '')
                    })
            l.hit = l.hit + 1
            l.save()
        return response
