// lib/services/cart_service.dart
// ============================================
// Service panier — remplace CartManager local
// ============================================
import '../utils/api_constants.dart';
import '../models/api_models.dart';
import 'api_client.dart';

class CartResult {
  final bool success;
  final String? error;
  final CartModel? cart;

  CartResult({required this.success, this.error, this.cart});
}

class CartService {
  // ─── VOIR LE PANIER ──────────────────────────
  static Future<CartModel?> getCart() async {
    final response = await ApiClient.get(ApiConstants.cart);
    if (response.statusCode == 200) {
      return CartModel.fromJson(ApiClient.decodeResponse(response));
    }
    return null;
  }

  // ─── AJOUTER UN PRODUIT ──────────────────────
  static Future<CartResult> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.cartAdd,
      body: {'product_id': productId, 'quantity': quantity},
    );
    if (response.statusCode == 200) {
      return CartResult(
        success: true,
        cart: CartModel.fromJson(ApiClient.decodeResponse(response)),
      );
    }
    return CartResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── MODIFIER QUANTITÉ ───────────────────────
  static Future<CartResult> updateQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await ApiClient.put(
      ApiConstants.cartItem(cartItemId),
      body: {'quantity': quantity},
    );
    if (response.statusCode == 200) {
      return CartResult(
        success: true,
        cart: CartModel.fromJson(ApiClient.decodeResponse(response)),
      );
    }
    return CartResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── SUPPRIMER UN ARTICLE ────────────────────
  static Future<CartResult> removeItem(int cartItemId) async {
    final response = await ApiClient.delete(
      ApiConstants.cartItem(cartItemId),
    );
    if (response.statusCode == 200) {
      return CartResult(
        success: true,
        cart: CartModel.fromJson(ApiClient.decodeResponse(response)),
      );
    }
    return CartResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── VIDER LE PANIER ─────────────────────────
  static Future<bool> clearCart() async {
    final response = await ApiClient.delete(ApiConstants.cartClear);
    return response.statusCode == 200;
  }
}
