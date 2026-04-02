from rest_framework import serializers
from .models import Order, OrderItem


class OrderItemSerializer(serializers.ModelSerializer):
    line_total = serializers.ReadOnlyField()

    class Meta:
        model = OrderItem
        fields = ['id', 'product', 'product_title', 'product_image', 'unit_price', 'quantity', 'line_total']
        read_only_fields = ['id']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    payment_display = serializers.CharField(source='get_payment_method_display', read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'status', 'status_display', 'payment_method', 'payment_display',
            'is_paid', 'delivery_name', 'delivery_phone', 'delivery_address', 'delivery_city',
            'subtotal', 'delivery_fee', 'total', 'note', 'items', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'status', 'is_paid', 'subtotal', 'delivery_fee', 'total', 'created_at', 'updated_at']


class CreateOrderSerializer(serializers.Serializer):
    """
    Crée une commande à partir du panier actuel de l'utilisateur.
    """
    delivery_name = serializers.CharField(max_length=150)
    delivery_phone = serializers.CharField(max_length=20)
    delivery_address = serializers.CharField()
    delivery_city = serializers.CharField(max_length=100, default='Yaoundé')
    payment_method = serializers.ChoiceField(choices=Order.PAYMENT_CHOICES)
    note = serializers.CharField(required=False, allow_blank=True, default='')


class OrderStatusUpdateSerializer(serializers.ModelSerializer):
    """Admin: modifier le statut d'une commande"""
    class Meta:
        model = Order
        fields = ['status', 'is_paid']


class AdminOrderSerializer(serializers.ModelSerializer):
    """Sérialiseur complet pour l'admin"""
    items = OrderItemSerializer(many=True, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    user_name = serializers.CharField(source='user.name', read_only=True)
    user_email = serializers.CharField(source='user.email', read_only=True)

    class Meta:
        model = Order
        fields = '__all__'
