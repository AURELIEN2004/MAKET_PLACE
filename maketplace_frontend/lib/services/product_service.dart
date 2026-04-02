// lib/services/product_service.dart
// ============================================
// Service produits / catalogue
// ============================================
import '../utils/api_constants.dart';
import '../models/api_models.dart';
import 'api_client.dart';

class ProductService {
  // ─── PAGE D'ACCUEIL (1 seul appel) ───────────
  static Future<HomeData?> getHomeData() async {
    final response = await ApiClient.get(ApiConstants.home);
    if (response.statusCode == 200) {
      return HomeData.fromJson(ApiClient.decodeResponse(response));
    }
    return null;
  }

  // ─── LISTE DES PRODUITS ──────────────────────
  static Future<List<ProductModel>> getProducts({
    String? search,
    int? categoryId,
    int? minPrice,
    int? maxPrice,
    String? origin,
    String? ordering,
    bool? featured,
  }) async {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (categoryId != null) params['category'] = categoryId.toString();
    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (origin != null && origin.isNotEmpty) params['origin'] = origin;
    if (ordering != null) params['ordering'] = ordering;
    if (featured == true) params['featured'] = 'true';

    final uri = Uri.parse(ApiConstants.products).replace(queryParameters: params);
    final response = await ApiClient.get(uri.toString());

    if (response.statusCode == 200) {
      final data = ApiClient.decodeResponse(response);
      // Gère la pagination DRF (retourne { results: [...] }) ou liste directe
      final list = data is Map ? data['results'] ?? data : data;
      return (list as List).map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  // ─── DÉTAIL D'UN PRODUIT ─────────────────────
  static Future<ProductModel?> getProductDetail(int id) async {
    final response = await ApiClient.get(ApiConstants.productDetail(id));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(ApiClient.decodeResponse(response));
    }
    return null;
  }

  // ─── CATÉGORIES ──────────────────────────────
  static Future<List<CategoryModel>> getCategories() async {
    final response = await ApiClient.get(ApiConstants.categories);
    if (response.statusCode == 200) {
      final data = ApiClient.decodeResponse(response);
      final list = data is Map ? data['results'] ?? data : data;
      return (list as List).map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }
}
