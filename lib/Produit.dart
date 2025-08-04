import 'package:flutter/material.dart';
import 'package:foodexpress/details.dart';
import 'package:foodexpress/models/product_model.dart';

class Produit extends StatefulWidget {
  @override
  _ProduitState createState() => _ProduitState();
}

class _ProduitState extends State<Produit> {
  // Liste des produits avec leurs informations complètes + catégorie et origine
  final List<Product> allProducts = [
    Product(
      id: '1',
      title: 'Tomates',
      subtitle: 'Fraîches, locales',
      description:
          'Tomates fraîches cultivées localement, riches en vitamines et parfaites pour vos salades et plats cuisinés. Récoltées à maturité pour un goût optimal.',
      image: 'assets/images/tomates.png',
      price: '1500 F',
      ingredients: ['Tomates fraîches 100%'],
      backgroundColor: Colors.red[100]!,
      category: 'Légumes',
      origin: 'Yaoundé',
      numericPrice: 1500,
    ),
    Product(
      id: '2',
      title: 'Pommes',
      subtitle: 'Douces et croquantes',
      description:
          'Pommes sucrées et croquantes, parfaites pour le goûter ou en dessert. Riches en fibres et vitamines, elles sont idéales pour une alimentation saine.',
      image: 'assets/images/pommes.png',
      price: '2000 F',
      ingredients: ['Pommes fraîches 100%'],
      backgroundColor: Colors.green[50]!,
      category: 'Fruits',
      origin: 'Douala',
      numericPrice: 2000,
    ),
    Product(
      id: '3',
      title: 'Carottes',
      subtitle: 'Bio, du terroir',
      description:
          'Carottes biologiques cultivées dans nos fermes locales. Croquantes et sucrées, elles sont parfaites crues ou cuites, riches en bêta-carotène.',
      image: 'assets/images/carottes.png',
      price: '1200 F',
      ingredients: ['Carottes biologiques 100%'],
      backgroundColor: Colors.orange[100]!,
      category: 'Légumes',
      origin: 'Bafoussam',
      numericPrice: 1200,
    ),
    Product(
      id: '4',
      title: 'Lait',
      subtitle: 'Frais du jour',
      description:
          'Lait frais pasteurisé du jour, provenant de vaches élevées en pâturages. Riche en calcium et protéines, idéal pour toute la famille.',
      image: 'assets/images/lait.png',
      price: '800 F',
      ingredients: ['Lait pasteurisé', 'Vitamines A et D'],
      backgroundColor: Colors.blue[50]!,
      category: 'Produits laitiers',
      origin: 'Garoua',
      numericPrice: 800,
    ),
    Product(
      id: '5',
      title: 'Fromage',
      subtitle: 'Artisanal',
      description:
          'Fromage artisanal fabriqué selon les méthodes traditionnelles. Affiné à la perfection, il offre un goût authentique et une texture crémeuse.',
      image: 'assets/images/fromage.png',
      price: '3500 F',
      ingredients: ['Lait', 'Ferments lactiques', 'Sel', 'Présure'],
      backgroundColor: Colors.yellow[100]!,
      category: 'Produits laitiers',
      origin: 'Maroua',
      numericPrice: 3500,
    ),
    Product(
      id: '6',
      title: 'Oeufs',
      subtitle: 'De poules élevées au sol',
      description:
          'Œufs frais de poules élevées au sol dans de bonnes conditions. Riches en protéines de haute qualité, parfaits pour tous vos plats.',
      image: 'assets/images/oeufs_promotion.png',
      price: '2500 F',
      ingredients: ['Œufs frais de poules élevées au sol'],
      backgroundColor: Colors.brown[50]!,
      category: 'Produits laitiers',
      origin: 'Bertoua',
      numericPrice: 2500,
    ),
  ];

  // Variables pour le filtrage
  List<Product> filteredProducts = [];
  String searchQuery = '';
  String? selectedCategory;
  String? selectedPriceRange;
  String? selectedOrigin;
  
  // Contrôleur pour la barre de recherche
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(allProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fonction pour filtrer les produits
  void _filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        // Filtre par recherche
        bool matchesSearch = searchQuery.isEmpty ||
            product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.subtitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(searchQuery.toLowerCase());

        // Filtre par catégorie
        bool matchesCategory = selectedCategory == null || 
            product.category == selectedCategory;

        // Filtre par prix
        bool matchesPrice = selectedPriceRange == null || 
            _isPriceInRange(product.numericPrice, selectedPriceRange!);

        // Filtre par origine
        bool matchesOrigin = selectedOrigin == null || 
            product.origin == selectedOrigin;

        return matchesSearch && matchesCategory && matchesPrice && matchesOrigin;
      }).toList();
    });
  }

  // Fonction pour vérifier si le prix est dans la plage sélectionnée
  bool _isPriceInRange(int price, String priceRange) {
    switch (priceRange) {
      case 'Moins de 500 fcfa':
        return price < 500;
      case '500 fcfa - 1000 fcfa':
        return price >= 500 && price <= 1000;
      case '1000 fcfa - 5000 fcfa':
        return price >= 1000 && price <= 5000;
      case 'Plus de 5000 fcfa':
        return price > 5000;
      default:
        return true;
    }
  }

  // Fonction pour réinitialiser les filtres
  void _resetFilters() {
    setState(() {
      searchQuery = '';
      selectedCategory = null;
      selectedPriceRange = null;
      selectedOrigin = null;
      searchController.clear();
      filteredProducts = List.from(allProducts);
    });
  }

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
        actions: [
          // Bouton pour réinitialiser les filtres
          IconButton(
            icon: Icon(Icons.clear_all, color: Colors.black),
            onPressed: _resetFilters,
            tooltip: 'Réinitialiser les filtres',
          ),
        ],
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
                controller: searchController,
                onChanged: (value) {
                  searchQuery = value;
                  _filterProducts();
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher par nom, description...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[500]),
                          onPressed: () {
                            searchController.clear();
                            searchQuery = '';
                            _filterProducts();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Filtres
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filtre par catégorie
                  PopupMenuButton<String>(
                    child: FilterButton(
                      text: selectedCategory ?? 'Catégorie',
                      icon: Icons.category,
                      isSelected: selectedCategory != null,
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    onSelected: (String category) {
                      setState(() {
                        selectedCategory = category;
                      });
                      _filterProducts();
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(value: 'Fruits', child: Text('Fruits')),
                      const PopupMenuItem(value: 'Légumes', child: Text('Légumes')),
                      const PopupMenuItem(value: 'Viandes', child: Text('Viandes')),
                      const PopupMenuItem(value: 'Produits laitiers', child: Text('Produits laitiers')),
                      const PopupMenuItem(value: 'Céréales', child: Text('Céréales')),
                      const PopupMenuItem(value: 'Boissons', child: Text('Boissons')),
                      const PopupMenuItem(value: 'Boulangerie', child: Text('Boulangerie')),
                    ],
                  ),
                  SizedBox(width: 8),

                  // Filtre par prix
                  PopupMenuButton<String>(
                    onSelected: (String priceRange) {
                      setState(() {
                        selectedPriceRange = priceRange;
                      });
                      _filterProducts();
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'Moins de 500 fcfa',
                        child: Text('Moins de 500 fcfa'),
                      ),
                      const PopupMenuItem<String>(
                        value: '500 fcfa - 1000 fcfa',
                        child: Text('500 fcfa - 1000 fcfa'),
                      ),
                      const PopupMenuItem<String>(
                        value: '1000 fcfa - 5000 fcfa',
                        child: Text('1000 fcfa - 5000 fcfa'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Plus de 5000 fcfa',
                        child: Text('Plus de 5000 fcfa'),
                      ),
                    ],
                    child: FilterButton(
                      text: selectedPriceRange ?? 'Prix',
                      icon: Icons.price_change,
                      isSelected: selectedPriceRange != null,
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Filtre par origine
                  PopupMenuButton<String>(
                    onSelected: (String origin) {
                      setState(() {
                        selectedOrigin = origin;
                      });
                      _filterProducts();
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(value: 'Yaoundé', child: Text('Yaoundé')),
                      const PopupMenuItem<String>(value: 'Douala', child: Text('Douala')),
                      const PopupMenuItem<String>(value: 'Bafoussam', child: Text('Bafoussam')),
                      const PopupMenuItem<String>(value: 'Garoua', child: Text('Garoua')),
                      const PopupMenuItem<String>(value: 'Maroua', child: Text('Maroua')),
                      const PopupMenuItem<String>(value: 'Bertoua', child: Text('Bertoua')),
                      const PopupMenuItem<String>(value: 'Limbe', child: Text('Limbe')),
                    ],
                    child: FilterButton(
                      text: selectedOrigin ?? 'Origine',
                      icon: Icons.location_on,
                      isSelected: selectedOrigin != null,
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Indicateur du nombre de résultats
            Text(
              '${filteredProducts.length} produit(s) trouvé(s)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),

            // Grille de produits filtrés
            filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun produit trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Essayez de modifier vos critères de recherche',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _resetFilters,
                          child: Text('Réinitialiser les filtres'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
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
  final bool isSelected;

  const FilterButton({
    Key? key, 
    required this.text, 
    this.icon, 
    this.trailing,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue[300]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon, 
              size: 18, 
              color: isSelected ? Colors.blue[700] : Colors.grey[700],
            ),
            SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.blue[700] : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 4), trailing!],
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

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
                    child: Stack(
                      children: [
                        Image.asset(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                        // Badge de catégorie
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            // Origine
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 2),
                                Text(
                                  product.origin,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
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