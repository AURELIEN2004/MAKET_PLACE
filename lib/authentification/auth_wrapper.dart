// lib/authentification/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodexpress/authentification/login_screen.dart';
import 'package:foodexpress/favorites.dart'; // Importez votre page principale
import 'package:foodexpress/main.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // 1. Vérifier immédiatement l'état initial de la session
    _checkInitialAuth();

    // 2. Écouter les changements d'état d'authentification
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // Redirige vers la page principale Favorites
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Favorites()),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        // Redirige vers la page de connexion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }
  
  // Fonction pour vérifier l'état initial de la session
  Future<void> _checkInitialAuth() async {
    // S'assurer que le widget est monté avant de faire une redirection
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;
    if (session == null) {
      // Pas de session, on va sur la page de connexion
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Session active, on va sur la page principale
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Favorites()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retourne un indicateur de chargement pour les très courts instants
    // avant que l'état initial ne soit vérifié.
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}