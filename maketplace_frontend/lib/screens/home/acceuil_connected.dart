// lib/Acceuil.dart  (ou AcceuilConnected — renommez selon votre structure)
// ============================================
// Page d'accueil connectée à l'API Django
// Remplace les données statiques par des appels HTTP
// ============================================
import 'package:flutter/material.dart';
// import '../services/product_service.dart';
// import '../models/api_models.dart';
// import 'products/product_detail_screen.dart';
// import 'products/products_screen.dart';
import 'package:flutter/material.dart';
// Remonter de deux niveaux pour sortir de 'home' et 'screens' afin d'atteindre 'services' et 'models'
import '../../services/product_service.dart';
import '../../models/api_models.dart';

// Pour les écrans qui sont dans d'autres dossiers
import '../products/product_detail_screen.dart';
import '../products/products_screen.dart';

class AcceuilConnected extends StatefulWidget {
  const AcceuilConnected({super.key});

  @override
  State<AcceuilConnected> createState() => _AcceuilConnectedState();
}

class _AcceuilConnectedState extends State<AcceuilConnected> {
  HomeData? _homeData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() { _isLoading = true; _error = null; });
    final data = await ProductService.getHomeData();
    if (mounted) {
      setState(() {
        _homeData = data;
        _isLoading = false;
        if (data == null) _error = 'Impossible de charger les données.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.red, size: 20),
            SizedBox(width: 4),
            Text('Yaoundé',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadHomeData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        child: const Text('Réessayer',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHomeData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── PRODUITS PHARES ───────────────────────
                        const _SectionTitle('Produits phares'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: _homeData!.featuredProducts.isEmpty
                              ? const Center(
                                  child: Text('Aucun produit phare',
                                      style: TextStyle(color: Colors.grey)))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _homeData!.featuredProducts.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (_, i) {
                                    final f = _homeData!.featuredProducts[i];
                                    return _FeaturedCard(featured: f);
                                  },
                                ),
                        ),
                        const SizedBox(height: 24),

                        // ── PROMOTIONS ────────────────────────────
                        const _SectionTitle('Promotions en cours'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 150,
                          child: _homeData!.promotions.isEmpty
                              ? const Center(
                                  child: Text('Aucune promotion',
                                      style: TextStyle(color: Colors.grey)))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _homeData!.promotions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (_, i) {
                                    return _PromotionCard(
                                        promo: _homeData!.promotions[i]);
                                  },
                                ),
                        ),
                        const SizedBox(height: 24),

                        // ── CATÉGORIES ────────────────────────────
                        const _SectionTitle('Catégories'),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: _homeData!.categories.length,
                          itemBuilder: (_, i) {
                            return _CategoryCard(
                                category: _homeData!.categories[i]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

// ── Widgets internes ─────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      );
}

class _FeaturedCard extends StatelessWidget {
  final FeaturedProductModel featured;
  const _FeaturedCard({required this.featured});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailScreen(productId: featured.product.id),
        ),
      ),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: featured.product.fullImageUrl.isNotEmpty
                    ? Image.network(
                        featured.product.fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.green[100]),
                      )
                    : Container(color: Colors.green[100]),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  featured.label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final PromotionModel promo;
  const _PromotionCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(promo.title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(promo.subtitle,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black87),
                    maxLines: 2),
                const SizedBox(height: 4),
                Text(promo.validityText,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700])),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (promo.product != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 70,
                height: 70,
                child: promo.product!.fullImageUrl.isNotEmpty
                    ? Image.network(promo.product!.fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.green[100]))
                    : Container(color: Colors.green[100]),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProduitsConnected(categoryId: category.id, categoryName: category.name),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (category.imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    category.imageUrl!.startsWith('http')
                        ? category.imageUrl!
                        : 'http://10.0.2.2:8000${category.imageUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.green[100]),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.45)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
