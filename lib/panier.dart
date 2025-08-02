import 'package:flutter/material.dart';

class Panier extends StatelessWidget {
  const Panier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemCard(
              image: 'assets/images/tomates.png',
              title: 'Tomates 1kg',
            ),
            ItemCard(
              image: 'assets/images/carottes.png',
              title: 'Carottes 500g',
            ),
            ItemCard(
              image: 'assets/images/pommes_de_terre.png',
              title: 'Pommes de terre 1kg',
            ),
            const SizedBox(height: 20),
            const Text(
              "Résumé",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SummaryRow(label: "Sous-total", value: "15,00 €"),
            SummaryRow(label: "Livraison", value: "5,00 €"),
            const Divider(),
            SummaryRow(label: "Total", value: "20,00 €"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action à définir
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text("Passer la commande"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String image;
  final String title;

  const ItemCard({required this.image, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(image, width: 50, height: 50),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.remove_circle_outline),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("1"), // Quantité fixe pour l'exemple
            ),
            Icon(Icons.add_circle_outline),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const SummaryRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
