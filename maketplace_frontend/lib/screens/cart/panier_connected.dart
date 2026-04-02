// lib/screens/cart/panier_connected.dart
// ============================================
// Panier connecté à l'API Django — remplace panier.dart
// ============================================
import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../models/api_models.dart';
import '../orders/commande_connected.dart';

class PanierConnected extends StatefulWidget {
  const PanierConnected({super.key});

  @override
  State<PanierConnected> createState() => _PanierConnectedState();
}

class _PanierConnectedState extends State<PanierConnected> {
  CartModel? _cart;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    final cart = await CartService.getCart();
    if (mounted) setState(() { _cart = cart; _isLoading = false; });
  }

  Future<void> _updateQuantity(CartItemModel item, int newQty) async {
    if (newQty <= 0) {
      await CartService.removeItem(item.id);
    } else {
      await CartService.updateQuantity(
          cartItemId: item.id, quantity: newQty);
    }
    _loadCart();
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vider le panier'),
        content: const Text('Voulez-vous supprimer tous les articles ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Vider', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await CartService.clearCart();
      _loadCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Panier',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_cart != null && _cart!.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _clearCart,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
          : _cart == null || _cart!.items.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cart!.items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) =>
                            _CartItemCard(
                          item: _cart!.items[i],
                          onUpdateQty: (qty) =>
                              _updateQuantity(_cart!.items[i], qty),
                        ),
                      ),
                    ),
                    _buildSummary(),
                  ],
                ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Votre panier est vide',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Ajoutez des produits pour les retrouver ici',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14)),
            child: const Text('Parcourir les produits'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        children: [
          const Text('Résumé',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _SummaryRow('Sous-total', '${_cart!.subtotal} F'),
          const SizedBox(height: 4),
          _SummaryRow('Livraison', '${_cart!.deliveryFee} F'),
          const Divider(height: 20),
          _SummaryRow('Total', '${_cart!.total} F', bold: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommandeConnected(cart: _cart!),
                ),
              ).then((_) => _loadCart()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Passer la commande',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final void Function(int) onUpdateQty;

  const _CartItemCard({required this.item, required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70,
              height: 70,
              child: item.product.fullImageUrl.isNotEmpty
                  ? Image.network(item.product.fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[200]))
                  : Container(color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (item.product.subtitle.isNotEmpty)
                  Text(item.product.subtitle,
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Text('${item.product.price} F',
                    style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Contrôles quantité + suppression
          Column(
            children: [
              Row(
                children: [
                  _SmallBtn(
                    icon: Icons.remove,
                    onTap: () => onUpdateQty(item.quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _SmallBtn(
                    icon: Icons.add,
                    onTap: () => onUpdateQty(item.quantity + 1),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => onUpdateQty(0),
                child: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
      color: bold ? Colors.redAccent : Colors.black87,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
