from django.contrib import admin
from .models import Category, Product, FeaturedProduct, Promotion


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'is_active', 'order', 'created_at']
    list_filter = ['is_active']
    search_fields = ['name']
    prepopulated_fields = {'slug': ('name',)}
    ordering = ['order', 'name']


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'price', 'stock', 'is_featured', 'is_active', 'created_at']
    list_filter = ['category', 'is_featured', 'is_active', 'unit']
    search_fields = ['title', 'subtitle', 'description', 'origin']
    list_editable = ['is_featured', 'is_active', 'stock']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('Informations principales', {
            'fields': ('title', 'subtitle', 'description', 'category', 'image')
        }),
        ('Prix & Stock', {
            'fields': ('price', 'unit', 'stock')
        }),
        ('Détails', {
            'fields': ('origin', 'ingredients', 'background_color')
        }),
        ('Visibilité', {
            'fields': ('is_active', 'is_featured')
        }),
        ('Dates', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(FeaturedProduct)
class FeaturedProductAdmin(admin.ModelAdmin):
    list_display = ['label', 'product', 'order', 'is_active', 'created_at']
    list_filter = ['is_active']
    list_editable = ['order', 'is_active']
    search_fields = ['label', 'product__title']
    autocomplete_fields = ['product']


@admin.register(Promotion)
class PromotionAdmin(admin.ModelAdmin):
    list_display = ['title', 'discount_percent', 'product', 'is_active', 'start_date', 'end_date']
    list_filter = ['is_active']
    search_fields = ['title', 'subtitle', 'product__title']
    list_editable = ['is_active', 'discount_percent']
    autocomplete_fields = ['product']
