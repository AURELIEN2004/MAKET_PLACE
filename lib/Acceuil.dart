import 'package:flutter/material.dart';
import 'package:foodexpress/Produit.dart';
import 'package:foodexpress/authentification/authentification.dart';
import 'package:foodexpress/favorites.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Acceuil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Acceuil extends StatefulWidget {
  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.red, size: 20),
            SizedBox(width: 4),
            Text(
              'Yaoundé',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorites()),
              );
            },          ),
            
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Produits phares
            Text(
              'Produits phares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ProductCard(
                    image: 'assets/images/legumes_frais.png',
                    title: 'Légumes frais du jour',
                    backgroundColor: Colors.green[100]!,
                    width: 200,
                  ),
                  SizedBox(width: 12),
                  ProductCard(
                    image: 'assets/images/fruits_bio.png',
                    title: 'Fruits tropicaux',
                    backgroundColor: Colors.green[100]!,
                    width: 200,
                  ),
                  SizedBox(width: 12),
                  ProductCard(
                    image: 'assets/images/all_viandes.png',
                    title: 'viandes de qualité',
                    backgroundColor: Colors.orange[100]!,
                    width: 200,
                  ),
                  SizedBox(width: 16),
                   ProductCard(
                    image: 'assets/images/autre_produit.png',
                    title: 'Autres produits',
                    backgroundColor: Colors.orange[100]!,
                    width: 200,
                  ),
                  SizedBox(width: 16), // Padding à la fin
                ],
              ),
            ),
            SizedBox(height: 24),
               
            // Section Promotion en cours
            Text(
              'Promotions en cours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PromotionCard(
                    title: 'Profiter de nos offres spéciales !',
                    subtitle: '30% de réduction sur les produits sélectionnés',
                    validityText: 'Valable jusqu\'au 30 septembre',
                    image: 'assets/images/oeufs_promotion.png',
                    productTitle: 'Oeufs frais',
                  ),
                  SizedBox(width: 12),
                  PromotionCard(
                    title: 'Offre limitée !',
                    subtitle: '25% de réduction sur les fruits',
                    validityText: 'Valable jusqu\'au 15 octobre',
                    image: 'assets/images/fruits_bio.png',
                    productTitle: 'Fruits bio',
                  ),
                  SizedBox(width: 12),
                  PromotionCard(
                    title: 'Promotion flash !',
                    subtitle: '40% de réduction sur les miels',
                    validityText: 'Valable jusqu\'au 20 septembre',
                    image: 'assets/images/miel.png',
                    productTitle: 'Miel frais',
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section Catégories
            Text(
              'Catégories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                CategoryCard(
                  title: 'Fruits',
                  backgroundColor: Colors.orange[100]!,
                  image: 'assets/images/fruits_categorie.png',
                ),
                CategoryCard(
                  title: 'Légumes',
                  backgroundColor: Colors.green[100]!,
                  image: 'assets/images/legumes_categorie.png',
                ),
                CategoryCard(
                  title: 'Produits laitiers',
                  backgroundColor: Colors.blue[100]!,
                  image: 'assets/images/produits_laitiers.png',
                ),
                CategoryCard(
                  title: 'Viandes',
                  backgroundColor: Colors.red[100]!,
                  image: 'assets/images/viandes.png',
                ),
                CategoryCard(
                  title: 'Boulangerie',
                  backgroundColor: Colors.brown[100]!,
                  image: 'assets/images/boulangerie.png',
                ),
                CategoryCard(
                  title: 'Boissons',
                  backgroundColor: Colors.teal[100]!,
                  image: 'assets/images/boissons (2).png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final Color backgroundColor;
  final double width;

  const ProductCard({
    Key? key,
    required this.image,
    required this.title,
    required this.backgroundColor,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Image en arrière-plan
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Widget de fallback si l'image n'est pas trouvée
                  return Container(
                    color: backgroundColor,
                    child: Icon(
                      title.contains('Légumes') ? Icons.eco : Icons.apple,
                      color: title.contains('Légumes') ? Colors.green : Colors.orange,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            // Overlay gradient pour améliorer la lisibilité du texte
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            // Texte en bas
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String validityText;
  final String image;
  final String productTitle;

  const PromotionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.validityText,
    required this.image,
    required this.productTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  validityText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            child: ProductCard(
              image: image,
              title: productTitle,
              backgroundColor: Colors.green[100]!,
              width: 80,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String image;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigation vers la catégorie
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Image de la catégorie
                Positioned.fill(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: backgroundColor,
                        child: Icon(
                          _getIconForCategory(title),
                          size: 40,
                          color: _getColorForCategory(title),
                        ),
                      );
                    },
                  ),
                ),
                // Overlay gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                // Titre en bas
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String categoryTitle) {
    switch (categoryTitle.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'légumes':
        return Icons.eco;
      case 'produits laitiers':
        return Icons.local_drink;
      case 'viandes':
        return Icons.restaurant;
      case 'boulangerie':
        return Icons.bakery_dining;
      case 'boissons':
        return Icons.local_cafe;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getColorForCategory(String categoryTitle) {
    switch (categoryTitle.toLowerCase()) {
      case 'fruits':
        return Colors.orange[600]!;
      case 'légumes':
        return Colors.green[600]!;
      case 'produits laitiers':
        return Colors.blue[600]!;
      case 'viandes':
        return Colors.red[600]!;
      case 'boulangerie':
        return Colors.brown[600]!;
      case 'boissons':
        return Colors.teal[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}