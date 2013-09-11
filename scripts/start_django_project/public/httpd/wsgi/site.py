import os
import sys

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", '??PROJECT_NAME??'))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "??PROJECT_NAME??.settings")

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()

import ??PROJECT_NAME??.monitor
??PROJECT_NAME??.monitor.start(interval=1.0)
