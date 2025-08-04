// product_model.dart
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final String price;
  final List<String> ingredients;
  final Color backgroundColor;
  // Nouvelles propriétés ajoutées pour le filtrage
  final String category;       // Catégorie du produit (Fruits, Légumes, etc.)
  final String origin;         // Origine/localisation du produit
  final int numericPrice;      // Prix numérique pour le tri et filtrage

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.price,
    required this.ingredients,
    required this.backgroundColor,
    // Nouvelles propriétés requises
    required this.category,
    required this.origin,
    required this.numericPrice,
  });

  // Méthode pour créer une copie du produit avec des propriétés modifiées
  Product copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? image,
    String? price,
    List<String>? ingredients,
    Color? backgroundColor,
    String? category,
    String? origin,
    int? numericPrice,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      numericPrice: numericPrice ?? this.numericPrice,
    );
  }

  // Conversion vers Map pour la sérialisation (utile pour le stockage local)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
      'price': price,
      'ingredients': ingredients,
      'backgroundColor': backgroundColor.value,
      'category': category,
      'origin': origin,
      'numericPrice': numericPrice,
    };
  }

  // Création d'un produit depuis une Map (utile pour la désérialisation)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      backgroundColor: Color(map['backgroundColor'] ?? Colors.grey.value),
      category: map['category'] ?? '',
      origin: map['origin'] ?? '',
      numericPrice: map['numericPrice']?.toInt() ?? 0,
    );
  }

  // Méthode pour vérifier si le produit correspond à une recherche
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    String lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
           subtitle.toLowerCase().contains(lowerQuery) ||
           description.toLowerCase().contains(lowerQuery) ||
           category.toLowerCase().contains(lowerQuery) ||
           origin.toLowerCase().contains(lowerQuery);
  }

  // Méthode pour vérifier si le produit est dans une tranche de prix
  bool isInPriceRange(String priceRange) {
    switch (priceRange) {
      case 'Moins de 500 fcfa':
        return numericPrice < 500;
      case '500 fcfa - 1000 fcfa':
        return numericPrice >= 500 && numericPrice <= 1000;
      case '1000 fcfa - 5000 fcfa':
        return numericPrice >= 1000 && numericPrice <= 5000;
      case 'Plus de 5000 fcfa':
        return numericPrice > 5000;
      default:
        return true;
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, category: $category, origin: $origin, price: $numericPrice}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Calcul du prix total pour cet item
  int get totalPrice {
    return product.numericPrice * quantity;
  }

  // Méthode pour créer une copie avec une quantité différente
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItem{product: ${product.title}, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && 
           other.product.id == product.id &&
           other.quantity == quantity;
  }

  @override
  int get hashCode => product.id.hashCode ^ quantity.hashCode;
}

// Gestionnaire de panier simple (singleton)
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(Product product, int quantity) {
    // Vérifier si le produit existe déjà dans le panier
    int existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Augmenter la quantité si le produit existe déjà
      _items[existingIndex].quantity += quantity;
    } else {
      // Ajouter un nouveau produit au panier
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int newQuantity) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  // Calcul du total en utilisant le prix numérique
  double get total {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Nombre total d'articles (en comptant les quantités)
  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Nombre de types d'articles différents
  int get itemCount => _items.length;

  // Vérifier si un produit est dans le panier
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Obtenir la quantité d'un produit spécifique
  int getQuantity(String productId) {
    CartItem? item = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == productId,
      orElse: () => null,
    );
    return item?.quantity ?? 0;
  }

  // Obtenir un item spécifique du panier
  CartItem? getCartItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  void clearCart() {
    _items.clear();
  }

  // Méthode pour obtenir les produits par catégorie dans le panier
  Map<String, List<CartItem>> getItemsByCategory() {
    Map<String, List<CartItem>> categorizedItems = {};
    
    for (CartItem item in _items) {
      String category = item.product.category;
      if (!categorizedItems.containsKey(category)) {
        categorizedItems[category] = [];
      }
      categorizedItems[category]!.add(item);
    }
    
    return categorizedItems;
  }

  // Méthode pour obtenir un résumé du panier
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': itemCount,
      'totalQuantity': totalQuantity,
      'total': total,
      'categories': getItemsByCategory().keys.toList(),
    };
  }
}