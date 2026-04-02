from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Order, OrderItem
from .serializers import (
    OrderSerializer, CreateOrderSerializer,
    OrderStatusUpdateSerializer, AdminOrderSerializer
)
from apps.cart.models import Cart
from apps.products.permissions import IsAdmin


class OrderListView(generics.ListAPIView):
    """
    GET /api/orders/
    Historique des commandes de l'utilisateur connecté.
    """
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')


class OrderDetailView(generics.RetrieveAPIView):
    """
    GET /api/orders/<id>/
    Détail d'une commande de l'utilisateur connecté.
    """
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')


class CreateOrderView(APIView):
    """
    POST /api/orders/create/
    Crée une commande à partir du panier actuel.
    Body: { delivery_name, delivery_phone, delivery_address, delivery_city, payment_method, note }
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # Récupérer le panier
        try:
            cart = request.user.cart
        except Cart.DoesNotExist:
            return Response({"error": "Votre panier est vide."}, status=status.HTTP_400_BAD_REQUEST)

        cart_items = cart.items.select_related('product').all()
        if not cart_items.exists():
            return Response({"error": "Votre panier est vide."}, status=status.HTTP_400_BAD_REQUEST)

        # Vérifier les stocks
        for item in cart_items:
            if item.product.stock < item.quantity:
                return Response(
                    {"error": f"Stock insuffisant pour '{item.product.title}'. Disponible: {item.product.stock}"},
                    status=status.HTTP_400_BAD_REQUEST
                )

        # Créer la commande
        subtotal = cart.subtotal
        delivery_fee = cart.delivery_fee

        order = Order.objects.create(
            user=request.user,
            delivery_name=data['delivery_name'],
            delivery_phone=data['delivery_phone'],
            delivery_address=data['delivery_address'],
            delivery_city=data.get('delivery_city', 'Yaoundé'),
            payment_method=data['payment_method'],
            note=data.get('note', ''),
            subtotal=subtotal,
            delivery_fee=delivery_fee,
        )

        # Créer les lignes de commande + décrémenter le stock
        for item in cart_items:
            product = item.product
            OrderItem.objects.create(
                order=order,
                product=product,
                product_title=product.title,
                product_image=product.image.url if product.image else '',
                unit_price=product.price,
                quantity=item.quantity,
            )
            # Décrémenter le stock
            product.stock -= item.quantity
            product.save(update_fields=['stock'])

        # Vider le panier
        cart.items.all().delete()

        return Response(
            OrderSerializer(order).data,
            status=status.HTTP_201_CREATED
        )


class CancelOrderView(APIView):
    """
    POST /api/orders/<id>/cancel/
    Annule une commande (uniquement si statut 'pending').
    """
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        try:
            order = Order.objects.get(id=pk, user=request.user)
        except Order.DoesNotExist:
            return Response({"error": "Commande introuvable."}, status=status.HTTP_404_NOT_FOUND)

        if order.status != 'pending':
            return Response(
                {"error": f"Cette commande ne peut plus être annulée (statut: {order.get_status_display()})."},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Remettre les stocks
        for item in order.items.select_related('product').all():
            if item.product:
                item.product.stock += item.quantity
                item.product.save(update_fields=['stock'])

        order.status = 'cancelled'
        order.save()
        return Response({"message": "Commande annulée."})


# ============================================
# ADMIN
# ============================================
class AdminOrderListView(generics.ListAPIView):
    """
    GET /api/orders/admin/
    Toutes les commandes (admin).
    Filtres: ?status=pending | ?user_id=<id>
    """
    serializer_class = AdminOrderSerializer
    permission_classes = [IsAdmin]

    def get_queryset(self):
        qs = Order.objects.all().prefetch_related('items').select_related('user')
        status_filter = self.request.query_params.get('status')
        user_id = self.request.query_params.get('user_id')
        if status_filter:
            qs = qs.filter(status=status_filter)
        if user_id:
            qs = qs.filter(user__id=user_id)
        return qs


class AdminOrderDetailView(generics.RetrieveUpdateAPIView):
    """
    GET  /api/orders/admin/<id>/   -> Détail commande
    PUT  /api/orders/admin/<id>/   -> Modifier statut / is_paid
    """
    queryset = Order.objects.all().prefetch_related('items').select_related('user')
    permission_classes = [IsAdmin]

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return OrderStatusUpdateSerializer
        return AdminOrderSerializer

    def update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return super().update(request, *args, **kwargs)
