from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, DeliveryAddress


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['email', 'name', 'phone', 'is_admin', 'is_active', 'date_joined']
    list_filter = ['is_admin', 'is_active', 'is_staff']
    search_fields = ['email', 'name', 'phone']
    ordering = ['-date_joined']

    fieldsets = (
        ('Identifiants', {'fields': ('email', 'password')}),
        ('Informations personnelles', {'fields': ('name', 'phone', 'address')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_admin', 'is_superuser', 'groups', 'user_permissions')}),
        ('Dates', {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'name', 'phone', 'password1', 'password2', 'is_admin'),
        }),
    )
    readonly_fields = ['date_joined']


@admin.register(DeliveryAddress)
class DeliveryAddressAdmin(admin.ModelAdmin):
    list_display = ['user', 'label', 'city', 'is_default']
    list_filter = ['city', 'is_default']
    search_fields = ['user__email', 'user__name', 'address']
