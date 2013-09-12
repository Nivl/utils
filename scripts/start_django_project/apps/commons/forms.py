from django import forms
from django.utils.translation import ugettext_lazy as _
import happyforms


class SingleFieldForm(happyforms.Form):
    single = None

    class Meta:
        abstract = True

    def __init__(self, data=None, files=None, is_required=True, *args, **kwargs):
        super(SingleFieldForm, self).__init__(data=data, files=files, *args, **kwargs)
        self.fields['single'].required = is_required


class SingleDateFieldForm(SingleFieldForm):
    single = forms.DateField()


class SingleCharFieldForm(SingleFieldForm):
    single = forms.CharField()


class SingleBooleanFieldForm(SingleFieldForm):
    single = forms.BooleanField(
        required=False)

    def __init__(self, data=None, files=None, is_required=False, *args, **kwargs):
        super(SingleFieldForm, self).__init__(data=data, files=files, *args, **kwargs)


class SingleTextareaForm(SingleFieldForm):
    single = forms.CharField(
        widget=forms.Textarea(),)

    def __init__(self, data=None, files=None, size=97, prefix='single_', *args, **kwargs):
        super(SingleTextareaForm, self).__init__(data=data, files=files, prefix=prefix, *args, **kwargs)

        self.fields['single'].widget.attrs['style'] = 'width: ' + str(size) + '%;'


class SingleChoiceFieldForm(SingleFieldForm):
    single = forms.ChoiceField()

    def __init__(self, data=None, files=None, choices=[], *args, **kwargs):
        super(SingleChoiceFieldForm, self).__init__(data=data, files=files, *args, **kwargs)
        self.fields['single'].choices = choices


class SingleMultipleChoiceFieldForm(SingleFieldForm):
    single = forms.ModelMultipleChoiceField(
        queryset=None,)

    def __init__(self, data=None, files=None, queryset=None, is_required=False, *args, **kwargs):
        super(SingleMultipleChoiceFieldForm, self).__init__(data=data, files=files, is_required=False, *args, **kwargs)
        self.fields['single'].queryset = queryset

