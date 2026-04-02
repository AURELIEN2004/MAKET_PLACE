from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    LoginView, RegisterView, LogoutView,
    ProfileView, ChangePasswordView,
    DeliveryAddressListCreateView, DeliveryAddressDetailView
)

urlpatterns = [
    # Authentification
    path('login/', LoginView.as_view(), name='auth-login'),
    path('register/', RegisterView.as_view(), name='auth-register'),
    path('logout/', LogoutView.as_view(), name='auth-logout'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token-refresh'),

    # Profil
    path('profile/', ProfileView.as_view(), name='auth-profile'),
    path('change-password/', ChangePasswordView.as_view(), name='auth-change-password'),

    # Adresses de livraison
    path('addresses/', DeliveryAddressListCreateView.as_view(), name='addresses-list'),
    path('addresses/<int:pk>/', DeliveryAddressDetailView.as_view(), name='addresses-detail'),
]
