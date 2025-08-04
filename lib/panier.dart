import 'package:flutter/material.dart';
import 'package:foodexpress/commande.dart';
import 'package:foodexpress/models/product_model.dart';
// Import your product_model.dart and commande.dart files here
// import 'product_model.dart';
// import 'commande.dart';

class Panier extends StatefulWidget {
  const Panier({super.key});

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  final CartManager _cartManager = CartManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          if (_cartManager.items.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Vider le panier'),
                      content: Text('Êtes-vous sûr de vouloir vider votre panier ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _cartManager.clearCart();
                          });
                            Navigator.of(context).pop();
                          },
                          child: Text('Vider', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: _cartManager.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Votre panier est vide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des produits pour commencer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Liste des produits dans le panier
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _cartManager.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = _cartManager.items[index];
                      return ItemCard(
                        cartItem: cartItem,
                        onQuantityChanged: (newQuantity) {
                          setState(() {
                            _cartManager.updateQuantity(cartItem.product.id, newQuantity);
                          });
                        },
                        onRemove: () {
                          setState(() {
                            _cartManager.removeFromCart(cartItem.product.id);
                          });
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Résumé de la commande
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Résumé",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        SummaryRow(
                          label: "Sous-total", 
                          value: "${_cartManager.total.toStringAsFixed(0)} F"
                        ),
                        SummaryRow(label: "Livraison", value: "500 F"),
                        const Divider(),
                        SummaryRow(
                          label: "Total", 
                          value: "${(_cartManager.total + 500).toStringAsFixed(0)} F",
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Bouton passer commande
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cartManager.items.isEmpty ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Commande()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Passer la commande",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const ItemCard({
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double itemPrice = double.tryParse(cartItem.product.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    double totalPrice = itemPrice * cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image du produit
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cartItem.product.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cartItem.product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shopping_bag,
                      color: Colors.grey[600],
                      size: 30,
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(width: 12),
            
            // Informations du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    cartItem.product.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${totalPrice.toStringAsFixed(0)} F",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Contrôles de quantité et suppression
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          onQuantityChanged(cartItem.quantity - 1);
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: 20,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Container(
                      width: 32,
                      child: Text(
                        "${cartItem.quantity}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onQuantityChanged(cartItem.quantity + 1);
                      },
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 20,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Supprimer le produit'),
                          content: Text('Voulez-vous supprimer ${cartItem.product.title} du panier ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                onRemove();
                                Navigator.of(context).pop();
                              },
                              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  iconSize: 20,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.redAccent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}