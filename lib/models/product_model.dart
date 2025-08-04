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

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.price,
    required this.ingredients,
    required this.backgroundColor,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

// Gestionnaire de panier simple (singleton)
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

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

  double get total {
    return _items.fold(0, (sum, item) {
      double price = double.tryParse(item.product.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  int get itemCount => _items.length;

  void clearCart() {
    _items.clear();
  }
}