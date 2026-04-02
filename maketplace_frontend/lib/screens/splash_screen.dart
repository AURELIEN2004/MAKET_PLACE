// lib/screens/splash_screen.dart
// ============================================
// Remplace l'ancien splash qui utilisait supabase.auth.currentSession
// ============================================
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

// ajout
import 'home/acceuil_connected.dart';
import 'products/products_screen.dart'; // Vérifie si c'est le bon nom de classe
import 'cart/panier_connected.dart';
import 'profile/profil_connected.dart';
// import '../Acceuil.dart'; // ou votre widget racine avec BottomNav

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Remplace : supabase.auth.currentSession
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => loggedIn ? const MainNavigation() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 80, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              'Marketplace',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}

// ─── Navigation principale avec BottomNav ────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Importez vos pages existantes
  final List<Widget> _pages = const [
    AcceuilPage(),     // Page d'accueil (connectée à l'API)
    ProduitsPage(),    // Liste produits
    PanierPage(),      // Panier
    ProfilPage(),      // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Produit'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// Placeholders — remplacez par vos imports réels
class AcceuilPage extends StatelessWidget {
  const AcceuilPage({super.key});
  @override
  Widget build(BuildContext context) =>  AcceuilConnected();
}
class ProduitsPage extends StatelessWidget {
  const ProduitsPage({super.key});
  @override
  Widget build(BuildContext context) =>  ProduitsConnected();
}
class PanierPage extends StatelessWidget {
  const PanierPage({super.key});
  @override
  Widget build(BuildContext context) =>  PanierConnected();
}
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  @override
  Widget build(BuildContext context) =>  ProfilConnected();
}
