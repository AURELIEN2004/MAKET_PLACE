from rest_framework.permissions import BasePermission, SAFE_METHODS


class IsAdminOrReadOnly(BasePermission):
    """
    Lecture autorisée pour tous les utilisateurs authentifiés.
    Écriture (POST, PUT, DELETE) réservée aux admins.
    """
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return request.user and request.user.is_authenticated
        return request.user and request.user.is_authenticated and request.user.is_marketplace_admin


class IsAdmin(BasePermission):
    """Accès réservé aux admins marketplace uniquement"""
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated and request.user.is_marketplace_admin


class IsPublicOrAuthenticated(BasePermission):
    """Lecture publique (sans auth), écriture nécessite auth"""
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return request.user and request.user.is_authenticated
