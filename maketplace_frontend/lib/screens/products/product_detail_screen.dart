// lib/screens/products/product_detail_screen.dart
// ============================================
// Détail produit connecté — remplace Details.dart (statique)
// ============================================
import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../models/api_models.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductModel? _product;
  bool _isLoading = true;
  int _quantity = 1;
  bool _addingToCart = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final p = await ProductService.getProductDetail(widget.productId);
    if (mounted) {
      setState(() {
        _product = p;
        _isLoading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    if (_product == null) return;
    setState(() => _addingToCart = true);

    final result = await CartService.addToCart(
      productId: _product!.id,
      quantity: _quantity,
    );

    if (!mounted) return;
    setState(() => _addingToCart = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.success
            ? '${_product!.title} ajouté au panier ✓'
            : result.error ?? 'Erreur'),
        backgroundColor: result.success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      );
    }
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Produit introuvable')),
      );
    }

    final p = _product!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${p.title} Details',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.grey[100],
              child: p.fullImageUrl.isNotEmpty
                  ? Image.network(p.fullImageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.local_grocery_store,
                              size: 80, color: Colors.grey))
                  : const Icon(Icons.local_grocery_store,
                      size: 80, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Titre & catégorie ─────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            if (p.subtitle.isNotEmpty)
                              Text(p.subtitle,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14)),
                          ],
                        ),
                      ),
                      if (p.categoryName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(p.categoryName,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Description ───────────────
                  Text(p.description,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.5)),
                  const SizedBox(height: 16),

                  // ── Prix ─────────────────────
                  Text(p.priceDisplay,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 4),

                  if (p.origin.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(p.origin,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                          p.isInStock ? Icons.check_circle : Icons.cancel,
                          size: 14,
                          color: p.isInStock ? Colors.green : Colors.red),
                      const SizedBox(width: 4),
                      Text(
                          p.isInStock
                              ? 'En stock (${p.stock} disponibles)'
                              : 'Rupture de stock',
                          style: TextStyle(
                              color: p.isInStock ? Colors.green : Colors.red,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Quantité ─────────────────
                  const Text('Quantité',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyBtn(
                        icon: Icons.remove,
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('$_quantity',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      _QtyBtn(
                        icon: Icons.add,
                        onPressed: _quantity < p.stock
                            ? () => setState(() => _quantity++)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Bouton panier ─────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: p.isInStock && !_addingToCart
                          ? _addToCart
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _addingToCart
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(
                              p.isInStock
                                  ? 'Ajouter au panier'
                                  : 'Indisponible',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Ingrédients ───────────────
                  if (p.ingredientsList.isNotEmpty) ...[
                    const Text('Ingrédients',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: p.ingredientsList
                          .map((ing) => Chip(
                                label: Text(ing,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor: Colors.grey[100],
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _QtyBtn({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}
