import 'package:flutter/material.dart';
import 'package:foodexpress/details.dart';
import 'package:foodexpress/models/product_model.dart';
// Import your details.dart and product_model.dart files here
// import 'details.dart';
// import 'product_model.dart';

class Produit extends StatelessWidget {
  // Liste des produits avec leurs informations complètes
  final List<Product> products = [
    Product(
      id: '1',
      title: 'Tomates',
      subtitle: 'Fraîches, locales',
      description: 'Tomates fraîches cultivées localement, riches en vitamines et parfaites pour vos salades et plats cuisinés. Récoltées à maturité pour un goût optimal.',
      image: 'assets/images/tomates.png',
      price: '1500 F',
      ingredients: ['Tomates fraîches 100%'],
      backgroundColor: Colors.red[100]!,
    ),
    Product(
      id: '2',
      title: 'Pommes',
      subtitle: 'Douces et croquantes',
      description: 'Pommes sucrées et croquantes, parfaites pour le goûter ou en dessert. Riches en fibres et vitamines, elles sont idéales pour une alimentation saine.',
      image: 'assets/images/pommes.png',
      price: '2000 F',
      ingredients: ['Pommes fraîches 100%'],
      backgroundColor: Colors.green[50]!,
    ),
    Product(
      id: '3',
      title: 'Carottes',
      subtitle: 'Bio, du terroir',
      description: 'Carottes biologiques cultivées dans nos fermes locales. Croquantes et sucrées, elles sont parfaites crues ou cuites, riches en bêta-carotène.',
      image: 'assets/images/carottes.png',
      price: '1200 F',
      ingredients: ['Carottes biologiques 100%'],
      backgroundColor: Colors.orange[100]!,
    ),
    Product(
      id: '4',
      title: 'Lait',
      subtitle: 'Frais du jour',
      description: 'Lait frais pasteurisé du jour, provenant de vaches élevées en pâturages. Riche en calcium et protéines, idéal pour toute la famille.',
      image: 'assets/images/lait.png',
      price: '800 F',
      ingredients: ['Lait pasteurisé', 'Vitamines A et D'],
      backgroundColor: Colors.blue[50]!,
    ),
    Product(
      id: '5',
      title: 'Fromage',
      subtitle: 'Artisanal',
      description: 'Fromage artisanal fabriqué selon les méthodes traditionnelles. Affiné à la perfection, il offre un goût authentique et une texture crémeuse.',
      image: 'assets/images/fromage.png',
      price: '3500 F',
      ingredients: ['Lait', 'Ferments lactiques', 'Sel', 'Présure'],
      backgroundColor: Colors.yellow[100]!,
    ),
    Product(
      id: '6',
      title: 'Œufs',
      subtitle: 'De poules élevées au sol',
      description: 'Œufs frais de poules élevées au sol dans de bonnes conditions. Riches en protéines de haute qualité, parfaits pour tous vos plats.',
      image: 'assets/images/oeufs_promotion.png',
      price: '2500 F',
      ingredients: ['Œufs frais de poules élevées au sol'],
      backgroundColor: Colors.brown[50]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Produits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Filtres
            Row(
              children: [
                FilterButton(
                  text: 'Catégorie',
                  icon: Icons.category,
                  trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[700]),
                ),
                SizedBox(width: 8),
                FilterButton(
                  text: 'Prix',
                  icon: Icons.price_change,
                  trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[700]),
                ),
                SizedBox(width: 8),
                FilterButton(
                  text: 'Origine',
                  icon: Icons.location_on,
                  trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Grille de produits
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? trailing;

  const FilterButton({
    Key? key,
    required this.text,
    this.icon,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[700]),
            SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 4),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: product.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image du produit
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: product.backgroundColor,
                          child: Icon(
                            _getIconForProduct(product.title),
                            size: 40,
                            color: _getColorForProduct(product.title),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Informations du produit
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Prix
                        Text(
                          product.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForProduct(String productName) {
    switch (productName.toLowerCase()) {
      case 'tomates':
        return Icons.eco;
      case 'pommes':
        return Icons.apple;
      case 'carottes':
        return Icons.grass;
      case 'lait':
        return Icons.local_drink;
      case 'fromage':
        return Icons.restaurant;
      case 'œufs':
        return Icons.egg;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getColorForProduct(String productName) {
    switch (productName.toLowerCase()) {
      case 'tomates':
        return Colors.red[600]!;
      case 'pommes':
        return Colors.green[600]!;
      case 'carottes':
        return Colors.orange[600]!;
      case 'lait':
        return Colors.blue[600]!;
      case 'fromage':
        return Colors.yellow[700]!;
      case 'œufs':
        return Colors.brown[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}



