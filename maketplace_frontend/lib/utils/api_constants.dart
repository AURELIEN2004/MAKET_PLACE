// // lib/utils/api_constants.dart
// // ============================================
// // Configuration de l'API Django
// // ============================================

// class ApiConstants {
//   // ⚠️ Remplacez par l'IP de votre machine en développement
//   // Android emulator : 10.0.2.2
//   // iOS simulator   : localhost ou 127.0.0.1
//   // Appareil physique : IP locale ex: 192.168.1.100
//   static const String baseUrl = 'http://10.0.2.2:8000/api';

//   // Auth
//   static const String login = '$baseUrl/auth/login/';
//   static const String register = '$baseUrl/auth/register/';
//   static const String logout = '$baseUrl/auth/logout/';
//   static const String tokenRefresh = '$baseUrl/auth/token/refresh/';
//   static const String profile = '$baseUrl/auth/profile/';
//   static const String changePassword = '$baseUrl/auth/change-password/';
//   static const String addresses = '$baseUrl/auth/addresses/';

//   // Produits
//   static const String home = '$baseUrl/products/home/';
//   static const String products = '$baseUrl/products/';
//   static const String categories = '$baseUrl/products/categories/';

//   // Panier
//   static const String cart = '$baseUrl/cart/';
//   static const String cartAdd = '$baseUrl/cart/add/';
//   static const String cartClear = '$baseUrl/cart/clear/';

//   // Commandes
//   static const String orders = '$baseUrl/orders/';
//   static const String createOrder = '$baseUrl/orders/create/';

//   // Helpers
//   static String productDetail(int id) => '$baseUrl/products/$id/';
//   static String cartItem(int id) => '$baseUrl/cart/items/$id/';
//   static String orderDetail(int id) => '$baseUrl/orders/$id/';
//   static String cancelOrder(int id) => '$baseUrl/orders/$id/cancel/';
//   static String addressDetail(int id) => '$baseUrl/auth/addresses/$id/';
// }


// lib/utils/api_constants.dart
// ============================================
// Configuration automatique selon la plateforme
// ============================================
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiConstants {
  /// URL de base détectée automatiquement selon la plateforme
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web (Chrome) → le serveur Django tourne sur localhost
      return 'http://localhost:8000/api';
    }
    try {
      if (Platform.isAndroid) {
        // Émulateur Android → 10.0.2.2 pointe vers localhost de la machine hôte
        return 'http://10.0.2.2:8000/api';
      }
      if (Platform.isIOS) {
        // Simulateur iOS → localhost fonctionne directement
        return 'http://localhost:8000/api';
      }
    } catch (_) {}
    // Fallback
    return 'http://localhost:8000/api';
  }

  // ── Auth ──────────────────────────────────────
  static String get login           => '$baseUrl/auth/login/';
  static String get register        => '$baseUrl/auth/register/';
  static String get logout          => '$baseUrl/auth/logout/';
  static String get tokenRefresh    => '$baseUrl/auth/token/refresh/';
  static String get profile         => '$baseUrl/auth/profile/';
  static String get changePassword  => '$baseUrl/auth/change-password/';
  static String get addresses       => '$baseUrl/auth/addresses/';

  // ── Produits ──────────────────────────────────
  static String get home            => '$baseUrl/products/home/';
  static String get products        => '$baseUrl/products/';
  static String get categories      => '$baseUrl/products/categories/';

  // ── Panier ────────────────────────────────────
  static String get cart            => '$baseUrl/cart/';
  static String get cartAdd         => '$baseUrl/cart/add/';
  static String get cartClear       => '$baseUrl/cart/clear/';

  // ── Commandes ─────────────────────────────────
  static String get orders          => '$baseUrl/orders/';
  static String get createOrder     => '$baseUrl/orders/create/';

  // ── Helpers dynamiques ────────────────────────
  static String productDetail(int id) => '$baseUrl/products/$id/';
  static String cartItem(int id)      => '$baseUrl/cart/items/$id/';
  static String orderDetail(int id)   => '$baseUrl/orders/$id/';
  static String cancelOrder(int id)   => '$baseUrl/orders/$id/cancel/';
  static String addressDetail(int id) => '$baseUrl/auth/addresses/$id/';

  /// Construit l'URL complète d'une image retournée par Django
  static String mediaUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final host = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
    return '$host$path';
  }
}