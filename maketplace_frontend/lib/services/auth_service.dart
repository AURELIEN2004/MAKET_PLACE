// lib/services/auth_service.dart
// ============================================
// Service d'authentification — remplace Supabase
// ============================================
import '../utils/api_constants.dart';
import '../models/api_models.dart';
import 'api_client.dart';
import 'token_service.dart';

class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;

  AuthResult({required this.success, this.error, this.user});
}

class AuthService {
  // ─── INSCRIPTION ─────────────────────────────
  static Future<AuthResult> register({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String password2,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.register,
      body: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
        'password2': password2,
      },
      requiresAuth: false,
    );

    if (response.statusCode == 201) {
      final data = ApiClient.decodeResponse(response);
      await TokenService.saveTokens(
        access: data['tokens']['access'],
        refresh: data['tokens']['refresh'],
      );
      return AuthResult(
        success: true,
        user: UserModel.fromJson(data['user']),
      );
    }
    return AuthResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── CONNEXION ───────────────────────────────
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    if (response.statusCode == 200) {
      final data = ApiClient.decodeResponse(response);
      await TokenService.saveTokens(
        access: data['access'],
        refresh: data['refresh'],
      );
      return AuthResult(
        success: true,
        user: UserModel.fromJson(data['user']),
      );
    }
    return AuthResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── DÉCONNEXION ─────────────────────────────
  static Future<void> logout() async {
    try {
      final refresh = await TokenService.getRefreshToken();
      if (refresh != null) {
        await ApiClient.post(
          ApiConstants.logout,
          body: {'refresh': refresh},
        );
      }
    } catch (_) {}
    await TokenService.clearTokens();
  }

  // ─── PROFIL UTILISATEUR ──────────────────────
  static Future<UserModel?> getProfile() async {
    final response = await ApiClient.get(ApiConstants.profile);
    if (response.statusCode == 200) {
      return UserModel.fromJson(ApiClient.decodeResponse(response));
    }
    return null;
  }

  // ─── MODIFIER LE PROFIL ──────────────────────
  static Future<AuthResult> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (address != null) body['address'] = address;

    final response = await ApiClient.put(ApiConstants.profile, body: body);
    if (response.statusCode == 200) {
      return AuthResult(
        success: true,
        user: UserModel.fromJson(ApiClient.decodeResponse(response)),
      );
    }
    return AuthResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── CHANGER MOT DE PASSE ────────────────────
  static Future<AuthResult> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPassword2,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.changePassword,
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password2': newPassword2,
      },
    );
    if (response.statusCode == 200) {
      return AuthResult(success: true);
    }
    return AuthResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── VÉRIFIER SI CONNECTÉ ────────────────────
  static Future<bool> isLoggedIn() => TokenService.isLoggedIn();
}
