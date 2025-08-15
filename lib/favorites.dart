import 'package:flutter/material.dart';
import 'package:foodexpress/Acceuil.dart';
import 'package:foodexpress/screens/home_screen.dart';
import 'package:foodexpress/Produit.dart';
import 'package:foodexpress/panier.dart';

 class Favorites extends StatefulWidget {

  @override
  _FavoritesState createState() => _FavoritesState();
  
 
  }

  class _FavoritesState extends State<Favorites> {

    int _currentIndex = 0;

     final List<Widget> _pages = [
    Acceuil(),
    Produit(),
    Panier(),
    HomeScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      body: _pages[_currentIndex], // Affiche la page selon l'index sélectionné
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change l'index lors du tap
          });
        },
         selectedItemColor: Color(0xFF4ECDC4),
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Produit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

