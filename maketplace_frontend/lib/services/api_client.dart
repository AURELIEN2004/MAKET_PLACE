// // lib/services/api_client.dart
// // ============================================
// // Client HTTP centralisé avec refresh token auto
// // ============================================
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'token_service.dart';
// import '../utils/api_constants.dart';

// class ApiClient {
//   // GET
//   static Future<http.Response> get(String url) async {
//     final headers = await TokenService.authHeaders();
//     var response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 401) {
//       final refreshed = await _refreshToken();
//       if (refreshed) {
//         final newHeaders = await TokenService.authHeaders();
//         response = await http.get(Uri.parse(url), headers: newHeaders);
//       }
//     }
//     return response;
//   }

//   // POST
//   static Future<http.Response> post(
//     String url, {
//     Map<String, dynamic>? body,
//     bool requiresAuth = true,
//   }) async {
//     final headers = requiresAuth
//         ? await TokenService.authHeaders()
//         : {'Content-Type': 'application/json'};

//     var response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: body != null ? jsonEncode(body) : null,
//     );

//     if (response.statusCode == 401 && requiresAuth) {
//       final refreshed = await _refreshToken();
//       if (refreshed) {
//         final newHeaders = await TokenService.authHeaders();
//         response = await http.post(
//           Uri.parse(url),
//           headers: newHeaders,
//           body: body != null ? jsonEncode(body) : null,
//         );
//       }
//     }
//     return response;
//   }

//   // PUT / PATCH
//   static Future<http.Response> put(
//     String url, {
//     Map<String, dynamic>? body,
//   }) async {
//     final headers = await TokenService.authHeaders();
//     var response = await http.put(
//       Uri.parse(url),
//       headers: headers,
//       body: body != null ? jsonEncode(body) : null,
//     );
//     if (response.statusCode == 401) {
//       final refreshed = await _refreshToken();
//       if (refreshed) {
//         final newHeaders = await TokenService.authHeaders();
//         response = await http.put(
//           Uri.parse(url),
//           headers: newHeaders,
//           body: body != null ? jsonEncode(body) : null,
//         );
//       }
//     }
//     return response;
//   }

//   // DELETE
//   static Future<http.Response> delete(
//     String url, {
//     Map<String, dynamic>? body,
//   }) async {
//     final headers = await TokenService.authHeaders();
//     var response = await http.delete(
//       Uri.parse(url),
//       headers: headers,
//       body: body != null ? jsonEncode(body) : null,
//     );
//     if (response.statusCode == 401) {
//       final refreshed = await _refreshToken();
//       if (refreshed) {
//         final newHeaders = await TokenService.authHeaders();
//         response = await http.delete(
//           Uri.parse(url),
//           headers: newHeaders,
//           body: body != null ? jsonEncode(body) : null,
//         );
//       }
//     }
//     return response;
//   }

//   // Multipart POST (pour l'upload d'images)
//   static Future<http.Response> postMultipart(
//     String url, {
//     required Map<String, String> fields,
//     String? fileField,
//     String? filePath,
//   }) async {
//     final token = await TokenService.getAccessToken();
//     final request = http.MultipartRequest('POST', Uri.parse(url));
//     if (token != null) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }
//     request.fields.addAll(fields);
//     if (fileField != null && filePath != null) {
//       request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
//     }
//     final streamed = await request.send();
//     return await http.Response.fromStream(streamed);
//   }

//   // Refresh automatique du token d'accès
//   static Future<bool> _refreshToken() async {
//     try {
//       final refreshToken = await TokenService.getRefreshToken();
//       if (refreshToken == null) return false;

//       final response = await http.post(
//         Uri.parse(ApiConstants.tokenRefresh),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'refresh': refreshToken}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         await TokenService.saveTokens(
//           access: data['access'],
//           refresh: data['refresh'] ?? refreshToken,
//         );
//         return true;
//       }
//     } catch (_) {}
//     return false;
//   }

//   // Décoder la réponse JSON de façon sécurisée
//   static dynamic decodeResponse(http.Response response) {
//     return jsonDecode(utf8.decode(response.bodyBytes));
//   }

//   // Extraire le message d'erreur de la réponse Django
//   static String extractError(http.Response response) {
//     try {
//       final data = jsonDecode(utf8.decode(response.bodyBytes));
//       if (data is Map) {
//         // Django retourne souvent { "field": ["message"] } ou { "detail": "message" }
//         if (data.containsKey('detail')) return data['detail'].toString();
//         final firstKey = data.keys.first;
//         final val = data[firstKey];
//         if (val is List) return val.first.toString();
//         return val.toString();
//       }
//     } catch (_) {}
//     return 'Erreur serveur (${response.statusCode})';
//   }
// }



// lib/services/api_client.dart
// ============================================
// Client HTTP compatible Web + Android + iOS
// Sur le Web, flutter_secure_storage utilise localStorage automatiquement
// ============================================
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'token_service.dart';
import '../utils/api_constants.dart';

class ApiClient {
  // ── GET ───────────────────────────────────────
  static Future<http.Response> get(String url) async {
    final headers = await TokenService.authHeaders();
    http.Response response;
    try {
      response = await http.get(Uri.parse(url), headers: headers);
    } catch (e) {
      return _networkErrorResponse(e);
    }
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newHeaders = await TokenService.authHeaders();
        try {
          response = await http.get(Uri.parse(url), headers: newHeaders);
        } catch (e) {
          return _networkErrorResponse(e);
        }
      }
    }
    return response;
  }

  // ── POST ──────────────────────────────────────
  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final headers = requiresAuth
        ? await TokenService.authHeaders()
        : {'Content-Type': 'application/json'};

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    } catch (e) {
      return _networkErrorResponse(e);
    }

    if (response.statusCode == 401 && requiresAuth) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newHeaders = await TokenService.authHeaders();
        try {
          response = await http.post(
            Uri.parse(url),
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
        } catch (e) {
          return _networkErrorResponse(e);
        }
      }
    }
    return response;
  }

  // ── PUT ───────────────────────────────────────
  static Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await TokenService.authHeaders();
    http.Response response;
    try {
      response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    } catch (e) {
      return _networkErrorResponse(e);
    }
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newHeaders = await TokenService.authHeaders();
        try {
          response = await http.put(
            Uri.parse(url),
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
        } catch (e) {
          return _networkErrorResponse(e);
        }
      }
    }
    return response;
  }

  // ── DELETE ────────────────────────────────────
  static Future<http.Response> delete(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await TokenService.authHeaders();
    http.Response response;
    try {
      response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    } catch (e) {
      return _networkErrorResponse(e);
    }
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newHeaders = await TokenService.authHeaders();
        try {
          response = await http.delete(
            Uri.parse(url),
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
        } catch (e) {
          return _networkErrorResponse(e);
        }
      }
    }
    return response;
  }

  // ── Refresh token ─────────────────────────────
  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse(ApiConstants.tokenRefresh),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await TokenService.saveTokens(
          access: data['access'],
          refresh: data['refresh'] ?? refreshToken,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  // ── Helpers ───────────────────────────────────
  static dynamic decodeResponse(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static String extractError(http.Response response) {
    // Erreur réseau simulée
    if (response.statusCode == 0) {
      return kIsWeb
          ? 'Impossible de contacter le serveur. Vérifiez que Django tourne sur localhost:8000 et que CORS est activé.'
          : 'Impossible de contacter le serveur. Vérifiez votre connexion.';
    }
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is Map) {
        if (data.containsKey('detail')) return data['detail'].toString();
        final firstKey = data.keys.first;
        final val = data[firstKey];
        if (val is List) return val.first.toString();
        return val.toString();
      }
    } catch (_) {}
    return 'Erreur serveur (${response.statusCode})';
  }

  /// Crée une fausse réponse 0 pour les erreurs réseau
  static http.Response _networkErrorResponse(Object error) {
    return http.Response(
      jsonEncode({'detail': error.toString()}),
      0,
      headers: {'content-type': 'application/json'},
    );
  }
}