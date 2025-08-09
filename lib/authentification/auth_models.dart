// lib/auth_models.dart

import 'package:foodexpress/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Assurez-vous d'avoir cette importation

class User {
  String email;
  String nom;
  String prenom;
  String telephone;
  String? photoPath;

  User({
    required this.email,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'photo_path': photoPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? 'N/A',
      nom: map['nom'] ?? 'N/A',
      prenom: map['prenom'] ?? 'N/A',
      telephone: map['telephone'] ?? 'N/A',
      photoPath: map['photo_path'],
    );
  }
}

class AuthService {
  static Future<void> register(
      String email, String password, Map<String, dynamic> userMetadata) async {
    final AuthResponse response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Vérifie si l'utilisateur a été créé avec succès
    if (response.user != null) {
      // Insère les données supplémentaires dans la table 'profiles'
      await supabase.from('profiles').insert({
        'id': response.user!.id, // L'ID de l'utilisateur est la clé primaire
        'email': email,
        'nom': userMetadata['nom'],
        'prenom': userMetadata['prenom'],
        'telephone': userMetadata['telephone'],
      });
    }
  }

  static Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await supabase.auth.signOut();
  }

  static Future<void> updateUser(Map<String, dynamic> data) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase
        .from('profiles')
        .update(data)
        .eq('id', userId);
  }

  static Future<User?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      return User.fromMap(response);
    }
    return null;
  }
}