from django.conf import settings
import akismet


def akismet_is_valid(request, data, user_email='', user_url=''):
    data = data.encode('ascii', 'ignore')
    user_data = {'user_ip': request.META.get('REMOTE_ADDR'),
                 'user_agent':  request.META.get('HTTP_USER_AGENT'),
                 'referrer':  request.META.get('HTTP_REFERER', 'unknown'),
                 'user_agent':  request.META.get('HTTP_USER_AGENT'),
                 'comment_author_url':  user_url,
                 'comment_author_email':  user_email, }

    domain = "http://" + settings.DOMAIN_NAME
    key = settings.AKISMET_API_KEY

    try:
        api = akismet.Akismet(key, domain)

        if api.verify_key():
            is_spam = api.comment_check(data, user_data)
            if is_spam:
                return False
    except (akismet.AkismetError, akismet.APIKeyError):
        pass
    return True
