// lib/services/order_service.dart
// ============================================
// Service commandes
// ============================================
import '../utils/api_constants.dart';
import '../models/api_models.dart';
import 'api_client.dart';

class OrderResult {
  final bool success;
  final String? error;
  final OrderModel? order;

  OrderResult({required this.success, this.error, this.order});
}

class OrderService {
  // ─── HISTORIQUE DES COMMANDES ────────────────
  static Future<List<OrderModel>> getOrders() async {
    final response = await ApiClient.get(ApiConstants.orders);
    if (response.statusCode == 200) {
      final data = ApiClient.decodeResponse(response);
      final list = data is Map ? data['results'] ?? data : data;
      return (list as List).map((e) => OrderModel.fromJson(e)).toList();
    }
    return [];
  }

  // ─── DÉTAIL D'UNE COMMANDE ───────────────────
  static Future<OrderModel?> getOrderDetail(int id) async {
    final response = await ApiClient.get(ApiConstants.orderDetail(id));
    if (response.statusCode == 200) {
      return OrderModel.fromJson(ApiClient.decodeResponse(response));
    }
    return null;
  }

  // ─── PASSER UNE COMMANDE ─────────────────────
  static Future<OrderResult> createOrder({
    required String deliveryName,
    required String deliveryPhone,
    required String deliveryAddress,
    String deliveryCity = 'Yaoundé',
    required String paymentMethod, // 'mobile_money' | 'cash_on_delivery'
    String note = '',
  }) async {
    final response = await ApiClient.post(
      ApiConstants.createOrder,
      body: {
        'delivery_name': deliveryName,
        'delivery_phone': deliveryPhone,
        'delivery_address': deliveryAddress,
        'delivery_city': deliveryCity,
        'payment_method': paymentMethod,
        'note': note,
      },
    );
    if (response.statusCode == 201) {
      return OrderResult(
        success: true,
        order: OrderModel.fromJson(ApiClient.decodeResponse(response)),
      );
    }
    return OrderResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }

  // ─── ANNULER UNE COMMANDE ────────────────────
  static Future<OrderResult> cancelOrder(int id) async {
    final response = await ApiClient.post(ApiConstants.cancelOrder(id));
    if (response.statusCode == 200) {
      return OrderResult(success: true);
    }
    return OrderResult(
      success: false,
      error: ApiClient.extractError(response),
    );
  }
}
