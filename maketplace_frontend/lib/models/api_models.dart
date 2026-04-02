// lib/models/api_models.dart
// ============================================
// Modèles de données correspondant au backend Django
// ============================================

// ─── USER ────────────────────────────────────
class UserModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String address;
  final bool isAdmin;
  final String dateJoined;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.isAdmin,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? 0,
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        isAdmin: json['is_admin'] ?? false,
        dateJoined: json['date_joined'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'phone': phone,
        'address': address,
        'is_admin': isAdmin,
      };
}

// ─── CATEGORY ────────────────────────────────
class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;
  final String backgroundColor;
  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imageUrl,
    required this.backgroundColor,
    required this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        description: json['description'] ?? '',
        imageUrl: json['image'],
        backgroundColor: json['background_color'] ?? '#F0F0F0',
        productsCount: json['products_count'] ?? 0,
      );
}

// ─── PRODUCT ─────────────────────────────────
class ProductModel {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final int price;
  final String priceDisplay;
  final String unit;
  final int? categoryId;
  final String categoryName;
  final String origin;
  final int stock;
  final bool isFeatured;
  final bool isInStock;
  final List<String> ingredientsList;
  final String backgroundColor;

  ProductModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.priceDisplay,
    required this.unit,
    this.categoryId,
    required this.categoryName,
    required this.origin,
    required this.stock,
    required this.isFeatured,
    required this.isInStock,
    required this.ingredientsList,
    required this.backgroundColor,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        description: json['description'] ?? '',
        imageUrl: json['image'] ?? '',
        price: json['price'] ?? 0,
        priceDisplay: json['price_display'] ?? '${json['price']} FCFA',
        unit: json['unit'] ?? 'pcs',
        categoryId: json['category'],
        categoryName: json['category_name'] ?? '',
        origin: json['origin'] ?? '',
        stock: json['stock'] ?? 0,
        isFeatured: json['is_featured'] ?? false,
        isInStock: json['is_in_stock'] ?? false,
        ingredientsList: List<String>.from(json['ingredients_list'] ?? []),
        backgroundColor: json['background_color'] ?? '#FFFFFF',
      );

  String get fullImageUrl {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return 'http://10.0.2.2:8000$imageUrl';
  }
}

// ─── FEATURED PRODUCT ────────────────────────
class FeaturedProductModel {
  final int id;
  final ProductModel product;
  final String label;
  final int order;

  FeaturedProductModel({
    required this.id,
    required this.product,
    required this.label,
    required this.order,
  });

  factory FeaturedProductModel.fromJson(Map<String, dynamic> json) =>
      FeaturedProductModel(
        id: json['id'] ?? 0,
        product: ProductModel.fromJson(json['product']),
        label: json['label'] ?? '',
        order: json['order'] ?? 0,
      );
}

// ─── PROMOTION ───────────────────────────────
class PromotionModel {
  final int id;
  final String title;
  final String subtitle;
  final String validityText;
  final int discountPercent;
  final ProductModel? product;
  final String? imageUrl;
  final int discountedPrice;

  PromotionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.validityText,
    required this.discountPercent,
    this.product,
    this.imageUrl,
    required this.discountedPrice,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        validityText: json['validity_text'] ?? '',
        discountPercent: json['discount_percent'] ?? 0,
        product: json['product'] != null
            ? ProductModel.fromJson(json['product'])
            : null,
        imageUrl: json['image'],
        discountedPrice: json['discounted_price'] ?? 0,
      );
}

// ─── CART ITEM ───────────────────────────────
class CartItemModel {
  final int id;
  final ProductModel product;
  int quantity;
  final int lineTotal;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.lineTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] ?? 0,
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'] ?? 1,
        lineTotal: json['line_total'] ?? 0,
      );
}

// ─── CART ────────────────────────────────────
class CartModel {
  final int id;
  final List<CartItemModel> items;
  final int totalItems;
  final int subtotal;
  final int deliveryFee;
  final int total;

  CartModel({
    required this.id,
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'] ?? 0,
        items: (json['items'] as List? ?? [])
            .map((e) => CartItemModel.fromJson(e))
            .toList(),
        totalItems: json['total_items'] ?? 0,
        subtotal: json['subtotal'] ?? 0,
        deliveryFee: json['delivery_fee'] ?? 0,
        total: json['total'] ?? 0,
      );
}

// ─── ORDER ITEM ──────────────────────────────
class OrderItemModel {
  final int id;
  final String productTitle;
  final String productImage;
  final int unitPrice;
  final int quantity;
  final int lineTotal;

  OrderItemModel({
    required this.id,
    required this.productTitle,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        id: json['id'] ?? 0,
        productTitle: json['product_title'] ?? '',
        productImage: json['product_image'] ?? '',
        unitPrice: json['unit_price'] ?? 0,
        quantity: json['quantity'] ?? 1,
        lineTotal: json['line_total'] ?? 0,
      );
}

// ─── ORDER ───────────────────────────────────
class OrderModel {
  final int id;
  final String status;
  final String statusDisplay;
  final String paymentMethod;
  final String paymentDisplay;
  final bool isPaid;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String deliveryCity;
  final int subtotal;
  final int deliveryFee;
  final int total;
  final String note;
  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.statusDisplay,
    required this.paymentMethod,
    required this.paymentDisplay,
    required this.isPaid,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.note,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] ?? 0,
        status: json['status'] ?? 'pending',
        statusDisplay: json['status_display'] ?? '',
        paymentMethod: json['payment_method'] ?? '',
        paymentDisplay: json['payment_display'] ?? '',
        isPaid: json['is_paid'] ?? false,
        deliveryName: json['delivery_name'] ?? '',
        deliveryPhone: json['delivery_phone'] ?? '',
        deliveryAddress: json['delivery_address'] ?? '',
        deliveryCity: json['delivery_city'] ?? 'Yaoundé',
        subtotal: json['subtotal'] ?? 0,
        deliveryFee: json['delivery_fee'] ?? 0,
        total: json['total'] ?? 0,
        note: json['note'] ?? '',
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItemModel.fromJson(e))
            .toList(),
        createdAt: json['created_at'] ?? '',
      );
}

// ─── HOME DATA ───────────────────────────────
class HomeData {
  final List<FeaturedProductModel> featuredProducts;
  final List<PromotionModel> promotions;
  final List<CategoryModel> categories;

  HomeData({
    required this.featuredProducts,
    required this.promotions,
    required this.categories,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        featuredProducts: (json['featured_products'] as List? ?? [])
            .map((e) => FeaturedProductModel.fromJson(e))
            .toList(),
        promotions: (json['promotions'] as List? ?? [])
            .map((e) => PromotionModel.fromJson(e))
            .toList(),
        categories: (json['categories'] as List? ?? [])
            .map((e) => CategoryModel.fromJson(e))
            .toList(),
      );
}
