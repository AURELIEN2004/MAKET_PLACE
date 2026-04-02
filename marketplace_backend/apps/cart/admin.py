from django.contrib import admin
from .models import Cart, CartItem


class CartItemInline(admin.TabularInline):
    model = CartItem
    extra = 0
    readonly_fields = ['line_total', 'added_at']


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    list_display = ['user', 'total_items', 'subtotal', 'total', 'updated_at']
    search_fields = ['user__email', 'user__name']
    readonly_fields = ['subtotal', 'delivery_fee', 'total', 'total_items']
    inlines = [CartItemInline]
