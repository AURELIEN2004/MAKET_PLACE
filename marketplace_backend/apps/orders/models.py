from django.db import models
from apps.accounts.models import User
from apps.products.models import Product


class Order(models.Model):
    """Commande passée par un client"""

    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('confirmed', 'Confirmée'),
        ('preparing', 'En préparation'),
        ('delivering', 'En livraison'),
        ('delivered', 'Livrée'),
        ('cancelled', 'Annulée'),
    ]

    PAYMENT_CHOICES = [
        ('mobile_money', 'Mobile Money'),
        ('cash_on_delivery', 'Paiement à la livraison'),
    ]

    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='orders')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    payment_method = models.CharField(max_length=20, choices=PAYMENT_CHOICES, default='cash_on_delivery')
    is_paid = models.BooleanField(default=False)

    # Infos livraison (snapshot au moment de la commande)
    delivery_name = models.CharField(max_length=150)
    delivery_phone = models.CharField(max_length=20)
    delivery_address = models.TextField()
    delivery_city = models.CharField(max_length=100, default='Yaoundé')

    # Montants (snapshot au moment de la commande)
    subtotal = models.PositiveIntegerField(default=0)
    delivery_fee = models.PositiveIntegerField(default=500)
    total = models.PositiveIntegerField(default=0)

    note = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Commande'
        verbose_name_plural = 'Commandes'
        ordering = ['-created_at']

    def __str__(self):
        return f"Commande #{self.id} - {self.user.name if self.user else 'Anonyme'} ({self.get_status_display()})"

    def save(self, *args, **kwargs):
        self.total = self.subtotal + self.delivery_fee
        super().save(*args, **kwargs)


class OrderItem(models.Model):
    """Ligne d'une commande (snapshot produit)"""
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True)
    product_title = models.CharField(max_length=200)   # Snapshot du titre
    product_image = models.CharField(max_length=500, blank=True)  # Snapshot URL image
    unit_price = models.PositiveIntegerField()          # Prix au moment de la commande
    quantity = models.PositiveIntegerField()

    class Meta:
        verbose_name = "Ligne de commande"
        verbose_name_plural = "Lignes de commande"

    def __str__(self):
        return f"{self.quantity}x {self.product_title}"

    @property
    def line_total(self):
        return self.unit_price * self.quantity
