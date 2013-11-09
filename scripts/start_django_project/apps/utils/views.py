# -*- coding: utf-8 -*-

from django.views.generic.base import TemplateView
from django.conf import settings
# Some models needs to be imported to deal with manyToMany through getattr on sys.modules[__name__]


class TexplainView(TemplateView):
    def get_context_data(self, **kwargs):
        context = super(TexplainView, self).get_context_data(**kwargs)
        context['site'] = settings.SITE_ID
        return context

    def render_to_response(self, context, **kwargs):
        return super(TexplainView, self).render_to_response(
            context,
            content_type='text/plain',
            **kwargs)