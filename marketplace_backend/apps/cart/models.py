from django.db import models
from apps.accounts.models import User
from apps.products.models import Product


class Cart(models.Model):
    """Panier d'un utilisateur (un seul panier actif par user)"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='cart')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Panier'
        verbose_name_plural = 'Paniers'

    def __str__(self):
        return f"Panier de {self.user.name}"

    @property
    def total_items(self):
        return sum(item.quantity for item in self.items.all())

    @property
    def subtotal(self):
        return sum(item.line_total for item in self.items.all())

    @property
    def delivery_fee(self):
        # Frais de livraison fixe : 500 FCFA (0 si panier vide)
        return 500 if self.items.exists() else 0

    @property
    def total(self):
        return self.subtotal + self.delivery_fee


class CartItem(models.Model):
    """Un article dans le panier"""
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Article du panier'
        verbose_name_plural = 'Articles du panier'
        unique_together = ['cart', 'product']

    def __str__(self):
        return f"{self.quantity}x {self.product.title}"

    @property
    def line_total(self):
        return self.product.price * self.quantity
