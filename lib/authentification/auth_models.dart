import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User {
  String email;
  String password;
  String nom;
  String prenom;
  String telephone;
  String? photoPath;

  User({
    required this.email,
    required this.password,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'photoPath': photoPath,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      photoPath: json['photoPath'],
    );
  }
}

class AuthService {
  static Future<bool> register(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];
    
    // Vérifier si l'email existe déjà
    for (String userJson in users) {
      User existingUser = User.fromJson(json.decode(userJson));
      if (existingUser.email == user.email) {
        return false; // Email déjà utilisé
      }
    }
    
    users.add(json.encode(user.toJson()));
    await prefs.setStringList('users', users);
    return true;
  }

  static Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];
    
    for (String userJson in users) {
      User user = User.fromJson(json.decode(userJson));
      if (user.email == email && user.password == password) {
        await prefs.setString('currentUser', userJson);
        return true;
      }
    }
    return false;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  static Future<User?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserJson = prefs.getString('currentUser');
    if (currentUserJson != null) {
      return User.fromJson(json.decode(currentUserJson));
    }
    return null;
  }

  static Future<bool> updateUser(User updatedUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];
    
    for (int i = 0; i < users.length; i++) {
      User user = User.fromJson(json.decode(users[i]));
      if (user.email == updatedUser.email) {
        users[i] = json.encode(updatedUser.toJson());
        await prefs.setStringList('users', users);
        await prefs.setString('currentUser', json.encode(updatedUser.toJson()));
        return true;
      }
    }
    return false;
  }
}