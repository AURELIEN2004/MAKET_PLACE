import 'package:flutter/material.dart';


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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
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
              width: double.infinity,
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
            'Profiter de nos offres spéciales !',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            '30% de réduction sur les produits sélectionnés',
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 14, 13, 13),
            ),
          ),
          Text(
            'Valable jusqu\'au 30 septembre',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    ),
    SizedBox(width: 12),
    ProductCard(
      image: 'assets/images/oeufs_promotion.png',
      title: 'Oeufs frais',
      backgroundColor: Colors.green[100]!,
      width: 200,
    ),
  ],
)

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
                  icon: Icons.apple,
                  iconColor: Colors.orange[600]!,
                ),
                CategoryCard(
                  title: 'Légumes',
                  backgroundColor: Colors.green[100]!,
                  icon: Icons.eco,
                  iconColor: Colors.green[600]!,
                ),
                CategoryCard(
                  title: 'Produits laitiers',
                  backgroundColor: Colors.blue[100]!,
                  icon: Icons.local_drink,
                  iconColor: Colors.blue[600]!,
                ),
                CategoryCard(
                  title: 'Viandes',
                  backgroundColor: Colors.red[100]!,
                  icon: Icons.restaurant,
                  iconColor: Colors.red[600]!,
                ),
                CategoryCard(
                  title: 'Boulangerie',
                  backgroundColor: Colors.brown[100]!,
                  icon: Icons.bakery_dining,
                  iconColor: Colors.brown[600]!,
                ),
                CategoryCard(
                  title: 'Boissons',
                  backgroundColor: Colors.teal[100]!,
                  icon: Icons.local_cafe,
                  iconColor: Colors.teal[600]!,
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

class CategoryCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
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
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: iconColor,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}