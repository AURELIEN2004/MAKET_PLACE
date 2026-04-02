from django.contrib import admin
from .models import Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = ['product_title', 'unit_price', 'quantity', 'line_total']


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'status', 'payment_method', 'is_paid', 'total', 'created_at']
    list_filter = ['status', 'payment_method', 'is_paid']
    search_fields = ['user__email', 'user__name', 'delivery_name', 'delivery_phone']
    list_editable = ['status', 'is_paid']
    readonly_fields = ['subtotal', 'delivery_fee', 'total', 'created_at', 'updated_at']
    ordering = ['-created_at']
    inlines = [OrderItemInline]

    fieldsets = (
        ('Commande', {'fields': ('user', 'status', 'note')}),
        ('Livraison', {'fields': ('delivery_name', 'delivery_phone', 'delivery_address', 'delivery_city')}),
        ('Paiement', {'fields': ('payment_method', 'is_paid')}),
        ('Montants', {'fields': ('subtotal', 'delivery_fee', 'total')}),
        ('Dates', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )
