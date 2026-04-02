// // lib/services/token_service.dart
// // ============================================
// // Gestion sécurisée des tokens JWT
// // Remplace supabase.auth.currentSession
// // ============================================
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class TokenService {
//   static const _storage = FlutterSecureStorage();
//   static const _accessKey = 'access_token';
//   static const _refreshKey = 'refresh_token';

//   // Sauvegarder les tokens après login/register
//   static Future<void> saveTokens({
//     required String access,
//     required String refresh,
//   }) async {
//     await _storage.write(key: _accessKey, value: access);
//     await _storage.write(key: _refreshKey, value: refresh);
//   }

//   // Lire le token d'accès
//   static Future<String?> getAccessToken() async {
//     return await _storage.read(key: _accessKey);
//   }

//   // Lire le refresh token
//   static Future<String?> getRefreshToken() async {
//     return await _storage.read(key: _refreshKey);
//   }

//   // Supprimer les tokens (déconnexion)
//   static Future<void> clearTokens() async {
//     await _storage.delete(key: _accessKey);
//     await _storage.delete(key: _refreshKey);
//   }

//   // Vérifier si l'utilisateur est connecté
//   static Future<bool> isLoggedIn() async {
//     final token = await getAccessToken();
//     return token != null && token.isNotEmpty;
//   }

//   // Headers d'authentification pour les requêtes
//   static Future<Map<String, String>> authHeaders() async {
//     final token = await getAccessToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }
// }


// lib/services/token_service.dart
// ============================================
// Stockage des tokens JWT — compatible Web + Mobile
// Sur Web  : flutter_secure_storage utilise localStorage du navigateur
// Sur Mobile : flutter_secure_storage utilise Keychain / Keystore
// ============================================
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TokenService {
  /// Options Web : stockage dans localStorage (sessionStorage aussi possible)
  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'marketplace_secure',
      publicKey: 'marketplace_pub_key',
    ),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, String>> authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}