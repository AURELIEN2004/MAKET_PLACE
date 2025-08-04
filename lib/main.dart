
import 'package:foodexpress/authentification/authentification.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Authentification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('currentUser');
    setState(() {
      isLoggedIn = currentUser != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return isLoggedIn ? ProfileScreen() : LoginScreen();
  }
}

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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showRegister = false;

  // Contrôleurs pour l'inscription
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User newUser = User(
        email: _registerEmailController.text,
        password: _registerPasswordController.text,
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
      );

      bool success = await AuthService.register(newUser);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte créé avec succès!')),
        );
        setState(() {
          _showRegister = false;
        });
        _clearRegistrationFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email déjà utilisé')),
        );
      }
    }
  }

  void _clearRegistrationFields() {
    _nomController.clear();
    _prenomController.clear();
    _telephoneController.clear();
    _registerEmailController.clear();
    _registerPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showRegister ? 'Créer un compte' : 'Connexion'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 30),
              
              if (!_showRegister) ...[
                // Formulaire de connexion
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Se connecter'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showRegister = true;
                    });
                  },
                  child: Text('Créer un compte'),
                ),
              ] else ...[
                // Formulaire d'inscription
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _telephoneController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre téléphone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _registerEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _registerPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _registerPasswordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Créer le compte'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showRegister = false;
                    });
                    _clearRegistrationFields();
                  },
                  child: Text('Déjà un compte ? Se connecter'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    User? user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
        _nomController.text = user.nom;
        _prenomController.text = user.prenom;
        _telephoneController.text = user.telephone;
        _emailController.text = user.email;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate() && currentUser != null) {
      User updatedUser = User(
        email: currentUser!.email, // L'email ne change pas
        password: currentUser!.password,
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
        photoPath: _imageFile?.path ?? currentUser!.photoPath,
      );

      bool success = await AuthService.updateUser(updatedUser);
      if (success) {
        setState(() {
          currentUser = updatedUser;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              // Photo de profil
              GestureDetector(
                onTap: isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (currentUser!.photoPath != null
                          ? FileImage(File(currentUser!.photoPath!))
                          : null),
                  child: (_imageFile == null && currentUser!.photoPath == null)
                      ? Icon(Icons.person, size: 60)
                      : null,
                ),
              ),
              if (isEditing) ...[
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo_camera),
                  label: Text('Changer la photo'),
                ),
              ],
              SizedBox(height: 30),
              
              // Nom
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Prénom
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Téléphone
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Email (non modifiable)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                enabled: false, // L'email n'est jamais modifiable
              ),
              SizedBox(height: 30),
              
              if (isEditing) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: Text('Sauvegarder'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            // Restaurer les valeurs originales
                            _nomController.text = currentUser!.nom;
                            _prenomController.text = currentUser!.prenom;
                            _telephoneController.text = currentUser!.telephone;
                            _imageFile = null;
                          });
                        },
                        child: Text('Annuler'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: Icon(Icons.logout),
                  label: Text('Se déconnecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
