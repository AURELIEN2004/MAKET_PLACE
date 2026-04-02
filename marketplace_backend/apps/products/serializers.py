from rest_framework import serializers
from .models import Category, Product, FeaturedProduct, Promotion


class CategorySerializer(serializers.ModelSerializer):
    products_count = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'description', 'image', 'background_color', 'products_count', 'order']

    def get_products_count(self, obj):
        return obj.products.filter(is_active=True).count()


class CategoryAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'


class ProductListSerializer(serializers.ModelSerializer):
    """Sérialiseur allégé pour les listes"""
    category_name = serializers.CharField(source='category.name', read_only=True)
    price_display = serializers.ReadOnlyField()
    is_in_stock = serializers.ReadOnlyField()
    ingredients_list = serializers.ReadOnlyField()

    class Meta:
        model = Product
        fields = [
            'id', 'title', 'subtitle', 'image', 'price', 'price_display',
            'category', 'category_name', 'origin', 'unit',
            'is_featured', 'is_in_stock', 'background_color',
            'ingredients_list', 'stock',
        ]


class ProductDetailSerializer(serializers.ModelSerializer):
    """Sérialiseur complet pour la page détail"""
    category_name = serializers.CharField(source='category.name', read_only=True)
    price_display = serializers.ReadOnlyField()
    is_in_stock = serializers.ReadOnlyField()
    ingredients_list = serializers.ReadOnlyField()

    class Meta:
        model = Product
        fields = '__all__'


class ProductAdminSerializer(serializers.ModelSerializer):
    """Sérialiseur pour la création/modification (admin)"""
    class Meta:
        model = Product
        fields = '__all__'


class FeaturedProductSerializer(serializers.ModelSerializer):
    product = ProductListSerializer(read_only=True)

    class Meta:
        model = FeaturedProduct
        fields = ['id', 'product', 'label', 'order', 'is_active']


class FeaturedProductAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeaturedProduct
        fields = '__all__'


class PromotionSerializer(serializers.ModelSerializer):
    product = ProductListSerializer(read_only=True)
    discounted_price = serializers.ReadOnlyField()

    class Meta:
        model = Promotion
        fields = [
            'id', 'title', 'subtitle', 'validity_text',
            'discount_percent', 'product', 'image',
            'is_active', 'start_date', 'end_date', 'discounted_price'
        ]


class PromotionAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = '__all__'
