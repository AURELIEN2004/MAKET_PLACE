import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.orange[50],
              child: Center(
                child: Image.asset(
                  'assets/images/confiture_fraise.jpg',
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_grocery_store,
                        size: 60,
                        color: Colors.orange[600],
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et prix
                  Text(
                    'Confiture fraise',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Une confiture artisanale fait avec amour pour vous donner le meilleur du goût fraise. Le produit est 100% naturel.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Prix
                  Text(
                    '2500 F',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Quantité
                  Text(
                    'Quantité',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.grey[600]),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.grey[600]),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Ingrédients
                  Text(
                    'Ingrédients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Fraises (60%)\n• Sucre\n• Pectine\n• Acide citrique',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Avis clients
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avis clients',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Voir tout',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Note globale
                  Row(
                    children: [
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < 4 ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                          ),
                          Text(
                            '(128 avis)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Barres de notation
                  ...List.generate(5, (index) {
                    List<double> percentages = [0.7, 0.2, 0.05, 0.03, 0.02];
                    int stars = 5 - index;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$stars'),
                          SizedBox(width: 4),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: percentages[index],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 20),

                  // Commentaires
                  ReviewCard(
                    name: 'Andrée Fotso',
                    rating: 5,
                    time: '23h',
                    comment: 'Excellent produit! La confiture est délicieuse et on sent vraiment le goût des fraises.',
                  ),
                  SizedBox(height: 12),
                  ReviewCard(
                    name: 'Jean Mballa',
                    rating: 4,
                    time: '2j',
                    comment: 'Très bonne qualité, je recommande.',
                  ),
                  SizedBox(height: 12),
                  ReviewCard(
                    name: 'Marie Ngo',
                    rating: 5,
                    time: '1 semaine',
                    comment: 'Parfait pour mes tartines du matin !',
                  ),
                  SizedBox(height: 80), // Espace pour le bouton flottant
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () {
            // Ajouter au panier
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Produit ajouté au panier'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Text(
            'Ajouter au panier',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String time;
  final String comment;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.time,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 12,
                            );
                          }),
                        ),
                        SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}