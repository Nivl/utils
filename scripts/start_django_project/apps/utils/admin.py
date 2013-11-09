from django.contrib import admin

class CommonAdmin(admin.ModelAdmin):
    prepopulated_fields = {'slug': ('name',)}