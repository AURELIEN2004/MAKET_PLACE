from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Cart, CartItem
from .serializers import CartSerializer, CartItemSerializer
from apps.products.models import Product


def get_or_create_cart(user):
    cart, _ = Cart.objects.get_or_create(user=user)
    return cart


class CartView(APIView):
    """
    GET    /api/cart/       -> Voir le panier complet
    DELETE /api/cart/clear/ -> Vider le panier
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cart = get_or_create_cart(request.user)
        serializer = CartSerializer(cart, context={'request': request})
        return Response(serializer.data)


class CartClearView(APIView):
    """DELETE /api/cart/clear/ -> Vider tout le panier"""
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        cart = get_or_create_cart(request.user)
        cart.items.all().delete()
        return Response({"message": "Panier vidé."}, status=status.HTTP_200_OK)


class CartAddItemView(APIView):
    """
    POST /api/cart/add/
    Body: { "product_id": <id>, "quantity": <n> }
    Ajoute un produit ou incrémente sa quantité si déjà présent.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = CartItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        cart = get_or_create_cart(request.user)
        product_id = serializer.validated_data['product_id']
        quantity = serializer.validated_data['quantity']
        product = Product.objects.get(id=product_id)

        # Vérifier stock
        if product.stock < quantity:
            return Response(
                {"error": f"Stock insuffisant. Disponible : {product.stock}"},
                status=status.HTTP_400_BAD_REQUEST
            )

        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )

        if not created:
            # Produit déjà dans le panier -> incrémenter
            new_qty = cart_item.quantity + quantity
            if product.stock < new_qty:
                return Response(
                    {"error": f"Stock insuffisant. Maximum disponible : {product.stock}"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            cart_item.quantity = new_qty
            cart_item.save()

        cart_serializer = CartSerializer(cart, context={'request': request})
        return Response(cart_serializer.data, status=status.HTTP_200_OK)


class CartUpdateItemView(APIView):
    """
    PUT /api/cart/items/<item_id>/
    Body: { "quantity": <n> }
    Modifie la quantité d'un article. Si quantity=0, supprime l'article.
    """
    permission_classes = [IsAuthenticated]

    def put(self, request, item_id):
        cart = get_or_create_cart(request.user)
        try:
            cart_item = cart.items.get(id=item_id)
        except CartItem.DoesNotExist:
            return Response({"error": "Article introuvable dans le panier."}, status=status.HTTP_404_NOT_FOUND)

        quantity = request.data.get('quantity', 1)
        try:
            quantity = int(quantity)
        except (ValueError, TypeError):
            return Response({"error": "Quantité invalide."}, status=status.HTTP_400_BAD_REQUEST)

        if quantity <= 0:
            cart_item.delete()
            return Response({"message": "Article supprimé du panier."}, status=status.HTTP_200_OK)

        if cart_item.product.stock < quantity:
            return Response(
                {"error": f"Stock insuffisant. Disponible : {cart_item.product.stock}"},
                status=status.HTTP_400_BAD_REQUEST
            )

        cart_item.quantity = quantity
        cart_item.save()

        cart_serializer = CartSerializer(cart, context={'request': request})
        return Response(cart_serializer.data)

    def delete(self, request, item_id):
        cart = get_or_create_cart(request.user)
        try:
            cart_item = cart.items.get(id=item_id)
            cart_item.delete()
            cart_serializer = CartSerializer(cart, context={'request': request})
            return Response(cart_serializer.data)
        except CartItem.DoesNotExist:
            return Response({"error": "Article introuvable."}, status=status.HTTP_404_NOT_FOUND)
