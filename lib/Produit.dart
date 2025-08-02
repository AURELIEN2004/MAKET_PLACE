import 'package:flutter/material.dart';



class Produit extends StatelessWidget {
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

                FilterButton(text: 'Prix',
                 icon: Icons.price_change,
                  trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[700]),
                 ),
                SizedBox(width: 8),

                FilterButton(text: 'Origine',
                 icon: Icons.location_on,
                  trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Section Tomates - Pommes
            ProductSection(
              leftProduct: ProductInfo(
                title: 'Tomates',
                subtitle: 'Fraîches, locales',
                image: 'assets/images/tomates.jpg',
                backgroundColor: Colors.red[100]!,
              ),
              rightProduct: ProductInfo(
                title: 'Pommes',
                subtitle: 'Douces et croquantes',
                image: 'assets/images/pommes.jpg',
                backgroundColor: Colors.green[50]!,
              ),
            ),
            SizedBox(height: 16),

            // Section Carottes - Lait
            ProductSection(
              leftProduct: ProductInfo(
                title: 'Carottes',
                subtitle: 'Bio, du terroir',
                image: 'assets/images/carottes.jpg',
                backgroundColor: Colors.orange[100]!,
              ),
              rightProduct: ProductInfo(
                title: 'Lait',
                subtitle: 'Frais du jour',
                image: 'assets/images/lait.jpg',
                backgroundColor: Colors.blue[50]!,
              ),
            ),
            SizedBox(height: 16),

            // Section Fromage - Œufs
            ProductSection(
              leftProduct: ProductInfo(
                title: 'Fromage',
                subtitle: 'Artisanal',
                image: 'assets/images/fromage.jpg',
                backgroundColor: Colors.yellow[100]!,
              ),
              rightProduct: ProductInfo(
                title: 'Œufs',
                subtitle: 'De poules élevées au sol',
                image: 'assets/images/oeufs.jpg',
                backgroundColor: Colors.brown[50]!,
              ),
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

class ProductInfo {
  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;

  ProductInfo({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
  });
}

class ProductSection extends StatelessWidget {
  final ProductInfo leftProduct;
  final ProductInfo rightProduct;

  const ProductSection({
    Key? key,
    required this.leftProduct,
    required this.rightProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProductCard(
            title: leftProduct.title,
            subtitle: leftProduct.subtitle,
            image: leftProduct.image,
            backgroundColor: leftProduct.backgroundColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ProductCard(
            title: rightProduct.title,
            subtitle: rightProduct.subtitle,
            image: rightProduct.image,
            backgroundColor: rightProduct.backgroundColor,
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;

  const ProductCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: backgroundColor,
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
          onTap: () {
            // Navigation vers le détail du produit
          },
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
                                       'assets/images/legumes_frais.png',

                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: backgroundColor,
                          child: Icon(
                            _getIconForProduct(title),
                            size: 40,
                            color: _getColorForProduct(title),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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