from django.urls import path
from .views import (
    HomeView,
    CategoryListView,
    CategoryAdminListCreateView, CategoryAdminDetailView,
    ProductListView, ProductDetailView,
    ProductAdminListCreateView, ProductAdminDetailView,
    FeaturedProductAdminListCreateView, FeaturedProductAdminDetailView,
    PromotionAdminListCreateView, PromotionAdminDetailView,
)

urlpatterns = [
    # Accueil (page principale app Flutter)
    path('home/', HomeView.as_view(), name='home'),

    # Produits publics
    path('', ProductListView.as_view(), name='product-list'),
    path('<int:pk>/', ProductDetailView.as_view(), name='product-detail'),

    # Catégories publiques
    path('categories/', CategoryListView.as_view(), name='category-list'),

    # ===== ROUTES ADMIN =====
    # Catégories
    path('admin/categories/', CategoryAdminListCreateView.as_view(), name='admin-categories'),
    path('admin/categories/<int:pk>/', CategoryAdminDetailView.as_view(), name='admin-category-detail'),

    # Produits
    path('admin/products/', ProductAdminListCreateView.as_view(), name='admin-products'),
    path('admin/products/<int:pk>/', ProductAdminDetailView.as_view(), name='admin-product-detail'),

    # Produits phares
    path('admin/featured/', FeaturedProductAdminListCreateView.as_view(), name='admin-featured'),
    path('admin/featured/<int:pk>/', FeaturedProductAdminDetailView.as_view(), name='admin-featured-detail'),

    # Promotions
    path('admin/promotions/', PromotionAdminListCreateView.as_view(), name='admin-promotions'),
    path('admin/promotions/<int:pk>/', PromotionAdminDetailView.as_view(), name='admin-promotion-detail'),
]
