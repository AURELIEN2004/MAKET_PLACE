// lib/screens/products/products_screen.dart
// ============================================
// Liste des produits connectée à l'API
// Supporte filtres : catégorie, recherche, prix, origine
// ============================================
import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../models/api_models.dart';
import 'product_detail_screen.dart';

class ProduitsConnected extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const ProduitsConnected({super.key, this.categoryId, this.categoryName});

  @override
  State<ProduitsConnected> createState() => _ProduitsConnectedState();
}

class _ProduitsConnectedState extends State<ProduitsConnected> {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  final _searchCtrl = TextEditingController();
  int? _selectedCategoryId;
  String? _selectedPriceRange;
  String? _selectedOrdering;

  final _priceRanges = {
    'Moins de 500 FCFA': {'min': 0, 'max': 499},
    '500 - 1000 FCFA': {'min': 500, 'max': 1000},
    '1000 - 5000 FCFA': {'min': 1000, 'max': 5000},
    'Plus de 5000 FCFA': {'min': 5001, 'max': 999999},
  };

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final range = _selectedPriceRange != null
        ? _priceRanges[_selectedPriceRange]
        : null;

    final results = await Future.wait([
      ProductService.getProducts(
        search: _searchCtrl.text.trim(),
        categoryId: _selectedCategoryId,
        minPrice: range?['min'],
        maxPrice: range?['max'],
        ordering: _selectedOrdering,
      ),
      if (_categories.isEmpty) ProductService.getCategories(),
    ]);

    if (mounted) {
      setState(() {
        _products = results[0] as List<ProductModel>;
        if (_categories.isEmpty && results.length > 1) {
          _categories = results[1] as List<CategoryModel>;
        }
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.categoryName ?? 'Produits',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterSheet,
          )
        ],
      ),
      body: Column(
        children: [
          // ── Barre de recherche ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: (_) => _loadData(),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, description...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _loadData();
                        })
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ),

          // ── Chips filtres rapides ─────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Catégorie',
                  icon: Icons.category_outlined,
                  isActive: _selectedCategoryId != null,
                  onTap: _showCategorySheet,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Prix',
                  icon: Icons.attach_money,
                  isActive: _selectedPriceRange != null,
                  onTap: _showPriceSheet,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: _selectedOrdering == 'price'
                      ? 'Prix ↑'
                      : _selectedOrdering == '-price'
                          ? 'Prix ↓'
                          : 'Tri',
                  icon: Icons.sort,
                  isActive: _selectedOrdering != null,
                  onTap: _showSortSheet,
                ),
                if (_selectedCategoryId != null ||
                    _selectedPriceRange != null ||
                    _selectedOrdering != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = null;
                        _selectedPriceRange = null;
                        _selectedOrdering = null;
                      });
                      _loadData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: const Text('Effacer',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Compteur ─────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_products.length} produit(s) trouvé(s)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Liste des produits ────────────────
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent))
                : _products.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Aucun produit trouvé',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (_, i) =>
                              _ProductCard(product: _products[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() => _showCategorySheet();

  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Catégorie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Toutes les catégories'),
            leading: Radio<int?>(
              value: null,
              groupValue: _selectedCategoryId,
              onChanged: (v) {
                setState(() => _selectedCategoryId = v);
                Navigator.pop(context);
                _loadData();
              },
            ),
          ),
          ..._categories.map((c) => ListTile(
                title: Text(c.name),
                subtitle: Text('${c.productsCount} produits'),
                leading: Radio<int?>(
                  value: c.id,
                  groupValue: _selectedCategoryId,
                  onChanged: (v) {
                    setState(() => _selectedCategoryId = v);
                    Navigator.pop(context);
                    _loadData();
                  },
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showPriceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Tranche de prix',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Tous les prix'),
            leading: Radio<String?>(
              value: null,
              groupValue: _selectedPriceRange,
              onChanged: (v) {
                setState(() => _selectedPriceRange = v);
                Navigator.pop(context);
                _loadData();
              },
            ),
          ),
          ..._priceRanges.keys.map((range) => ListTile(
                title: Text(range),
                leading: Radio<String?>(
                  value: range,
                  groupValue: _selectedPriceRange,
                  onChanged: (v) {
                    setState(() => _selectedPriceRange = v);
                    Navigator.pop(context);
                    _loadData();
                  },
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Trier par',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          for (final entry in {
            null: 'Par défaut',
            'price': 'Prix croissant',
            '-price': 'Prix décroissant',
            'title': 'Nom A→Z',
          }.entries)
            ListTile(
              title: Text(entry.value),
              leading: Radio<String?>(
                value: entry.key,
                groupValue: _selectedOrdering,
                onChanged: (v) {
                  setState(() => _selectedOrdering = v);
                  Navigator.pop(context);
                  _loadData();
                },
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isActive ? Colors.redAccent : Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isActive ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.white : Colors.grey[700])),
            const SizedBox(width: 2),
            Icon(Icons.keyboard_arrow_down,
                size: 14,
                color: isActive ? Colors.white : Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: product.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      child: product.fullImageUrl.isNotEmpty
                          ? Image.network(
                              product.fullImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey[200]),
                            )
                          : Container(color: Colors.grey[200]),
                    ),
                  ),
                  if (product.categoryName.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(product.categoryName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 9)),
                      ),
                    ),
                  if (!product.isInStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Text('Épuisé',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (product.subtitle.isNotEmpty)
                    Text(product.subtitle,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  if (product.origin.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 11, color: Colors.grey[500]),
                        Text(product.origin,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 10)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(product.priceDisplay,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
