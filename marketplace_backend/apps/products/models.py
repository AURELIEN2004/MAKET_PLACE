from django.db import models
from django.core.validators import MinValueValidator


class Category(models.Model):
    """Catégorie de produit (Fruits, Légumes, Viandes, etc.)"""
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='categories/', null=True, blank=True)
    background_color = models.CharField(max_length=7, default='#F0F0F0', help_text='Couleur hex, ex: #FF5733')
    is_active = models.BooleanField(default=True)
    order = models.PositiveIntegerField(default=0, help_text='Ordre d\'affichage')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Catégorie'
        verbose_name_plural = 'Catégories'
        ordering = ['order', 'name']

    def __str__(self):
        return self.name


class Product(models.Model):
    """Produit principal"""
    UNIT_CHOICES = [
        ('kg', 'Kilogramme'),
        ('g', 'Gramme'),
        ('l', 'Litre'),
        ('pcs', 'Pièce(s)'),
        ('lot', 'Lot'),
    ]

    id = models.AutoField(primary_key=True)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, related_name='products')
    title = models.CharField(max_length=200)
    subtitle = models.CharField(max_length=200, blank=True)
    description = models.TextField()
    image = models.ImageField(upload_to='products/')
    price = models.PositiveIntegerField(validators=[MinValueValidator(1)], help_text='Prix en FCFA')
    unit = models.CharField(max_length=10, choices=UNIT_CHOICES, default='pcs')
    origin = models.CharField(max_length=100, blank=True, help_text='Origine du produit (ex: Local, Importé)')
    stock = models.PositiveIntegerField(default=0)
    ingredients = models.TextField(blank=True, help_text='Ingrédients séparés par virgule')
    background_color = models.CharField(max_length=7, default='#FFFFFF')
    
    is_active = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=False, verbose_name='Produit phare')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Produit'
        verbose_name_plural = 'Produits'
        ordering = ['-created_at']

    def __str__(self):
        return self.title

    @property
    def price_display(self):
        return f"{self.price} FCFA"

    @property
    def ingredients_list(self):
        if self.ingredients:
            return [i.strip() for i in self.ingredients.split(',')]
        return []

    @property
    def is_in_stock(self):
        return self.stock > 0


class FeaturedProduct(models.Model):
    """Produits phares mis en avant sur la page d'accueil"""
    product = models.OneToOneField(Product, on_delete=models.CASCADE, related_name='featured')
    label = models.CharField(max_length=100, help_text='Titre affiché sur la bannière (ex: Légumes frais du jour)')
    order = models.PositiveIntegerField(default=0)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Produit phare'
        verbose_name_plural = 'Produits phares'
        ordering = ['order']

    def __str__(self):
        return f"Phare: {self.label}"


class Promotion(models.Model):
    """Promotions / Offres spéciales"""
    title = models.CharField(max_length=200, help_text='Ex: Profitez de nos offres spéciales !')
    subtitle = models.CharField(max_length=300, help_text='Ex: 30% de réduction sur les produits sélectionnés')
    validity_text = models.CharField(max_length=200, help_text='Ex: Valable jusqu\'au 30 septembre')
    discount_percent = models.PositiveIntegerField(default=0, help_text='Pourcentage de réduction (0 si non applicable)')
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True, blank=True, related_name='promotions')
    image = models.ImageField(upload_to='promotions/', null=True, blank=True)
    is_active = models.BooleanField(default=True)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Promotion'
        verbose_name_plural = 'Promotions'
        ordering = ['order', '-created_at']

    def __str__(self):
        return self.title

    @property
    def discounted_price(self):
        if self.product and self.discount_percent > 0:
            return int(self.product.price * (1 - self.discount_percent / 100))
        return self.product.price if self.product else 0
