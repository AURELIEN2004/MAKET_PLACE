from rest_framework import generics, filters, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q

from .models import Category, Product, FeaturedProduct, Promotion
from .permissions import IsAdminOrReadOnly, IsAdmin, IsPublicOrAuthenticated
from .serializers import (
    CategorySerializer, CategoryAdminSerializer,
    ProductListSerializer, ProductDetailSerializer, ProductAdminSerializer,
    FeaturedProductSerializer, FeaturedProductAdminSerializer,
    PromotionSerializer, PromotionAdminSerializer,
)


# ============================================
# HOME SCREEN - Vue groupée pour la page d'accueil
# ============================================
class HomeView(APIView):
    """
    GET /api/products/home/
    Retourne en une seule requête:
      - produits_phares
      - promotions_en_cours
      - categories
    """
    permission_classes = [IsPublicOrAuthenticated]

    def get(self, request):
        featured = FeaturedProduct.objects.filter(is_active=True).select_related('product__category')
        promotions = Promotion.objects.filter(is_active=True).select_related('product')
        categories = Category.objects.filter(is_active=True)

        return Response({
            'featured_products': FeaturedProductSerializer(featured, many=True, context={'request': request}).data,
            'promotions': PromotionSerializer(promotions, many=True, context={'request': request}).data,
            'categories': CategorySerializer(categories, many=True, context={'request': request}).data,
        })


# ============================================
# CATEGORIES
# ============================================
class CategoryListView(generics.ListAPIView):
    """GET /api/products/categories/ - Liste publique des catégories"""
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [IsPublicOrAuthenticated]


class CategoryAdminListCreateView(generics.ListCreateAPIView):
    """
    GET  /api/products/admin/categories/      -> Liste (admin)
    POST /api/products/admin/categories/      -> Créer une catégorie (admin)
    """
    queryset = Category.objects.all()
    serializer_class = CategoryAdminSerializer
    permission_classes = [IsAdmin]


class CategoryAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/products/admin/categories/<id>/
    """
    queryset = Category.objects.all()
    serializer_class = CategoryAdminSerializer
    permission_classes = [IsAdmin]


# ============================================
# PRODUCTS
# ============================================
class ProductListView(generics.ListAPIView):
    """
    GET /api/products/
    Filtres: ?category=<id> | ?search=<q> | ?min_price=<n> | ?max_price=<n> | ?origin=<str>
    Tri: ?ordering=price | ?ordering=-price | ?ordering=title
    """
    serializer_class = ProductListSerializer
    permission_classes = [IsPublicOrAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'subtitle', 'description', 'category__name', 'origin']
    ordering_fields = ['price', 'title', 'created_at']
    ordering = ['-created_at']

    def get_queryset(self):
        qs = Product.objects.filter(is_active=True).select_related('category')
        
        # Filtre par catégorie
        category = self.request.query_params.get('category')
        if category:
            qs = qs.filter(category__id=category)

        # Filtre par tranche de prix
        min_price = self.request.query_params.get('min_price')
        max_price = self.request.query_params.get('max_price')
        if min_price:
            qs = qs.filter(price__gte=min_price)
        if max_price:
            qs = qs.filter(price__lte=max_price)

        # Filtre par origine
        origin = self.request.query_params.get('origin')
        if origin:
            qs = qs.filter(origin__icontains=origin)

        # Filtre produits phares
        featured = self.request.query_params.get('featured')
        if featured == 'true':
            qs = qs.filter(is_featured=True)

        return qs


class ProductDetailView(generics.RetrieveAPIView):
    """GET /api/products/<id>/ - Détail d'un produit"""
    queryset = Product.objects.filter(is_active=True)
    serializer_class = ProductDetailSerializer
    permission_classes = [IsPublicOrAuthenticated]


# ============================================
# ADMIN - PRODUCTS
# ============================================
class ProductAdminListCreateView(generics.ListCreateAPIView):
    """
    GET  /api/products/admin/products/    -> Tous les produits (admin)
    POST /api/products/admin/products/    -> Créer un produit (admin)
    """
    queryset = Product.objects.all().select_related('category')
    serializer_class = ProductAdminSerializer
    permission_classes = [IsAdmin]


class ProductAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/products/admin/products/<id>/
    """
    queryset = Product.objects.all()
    serializer_class = ProductAdminSerializer
    permission_classes = [IsAdmin]


# ============================================
# ADMIN - FEATURED PRODUCTS (Produits phares)
# ============================================
class FeaturedProductAdminListCreateView(generics.ListCreateAPIView):
    """
    GET  /api/products/admin/featured/    -> Liste des produits phares
    POST /api/products/admin/featured/    -> Ajouter un produit phare
    """
    queryset = FeaturedProduct.objects.all().select_related('product')
    serializer_class = FeaturedProductAdminSerializer
    permission_classes = [IsAdmin]


class FeaturedProductAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/products/admin/featured/<id>/
    """
    queryset = FeaturedProduct.objects.all()
    serializer_class = FeaturedProductAdminSerializer
    permission_classes = [IsAdmin]


# ============================================
# ADMIN - PROMOTIONS (Promotions en cours)
# ============================================
class PromotionAdminListCreateView(generics.ListCreateAPIView):
    """
    GET  /api/products/admin/promotions/   -> Liste des promotions
    POST /api/products/admin/promotions/   -> Créer une promotion
    """
    queryset = Promotion.objects.all().select_related('product')
    serializer_class = PromotionAdminSerializer
    permission_classes = [IsAdmin]


class PromotionAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/products/admin/promotions/<id>/
    """
    queryset = Promotion.objects.all()
    serializer_class = PromotionAdminSerializer
    permission_classes = [IsAdmin]
