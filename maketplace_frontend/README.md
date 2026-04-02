# foodexpress

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# 📱 Guide de migration Flutter — Supabase → Django JWT

## Vue d'ensemble

| Avant (Supabase) | Après (Django JWT) |
|---|---|
| `supabase_flutter` | `http` + `flutter_secure_storage` |
| `supabase.auth.signInWithPassword()` | `AuthService.login()` |
| `supabase.auth.signUp()` | `AuthService.register()` |
| `supabase.auth.signOut()` | `AuthService.logout()` |
| `supabase.auth.currentUser` | `AuthService.getProfile()` |
| `supabase.auth.currentSession` | `TokenService.isLoggedIn()` |
| CartManager (local) | `CartService` (API) |
| Données statiques | `ProductService.getHomeData()` |

---

## 📁 Structure des nouveaux fichiers

```
lib/
├── main.dart                          ← REMPLACER (supprime Supabase init)
├── utils/
│   └── api_constants.dart             ← NOUVEAU (URLs de l'API)
├── models/
│   └── api_models.dart                ← NOUVEAU (modèles JSON)
├── services/
│   ├── token_service.dart             ← NOUVEAU (stockage JWT)
│   ├── api_client.dart                ← NOUVEAU (client HTTP centralisé)
│   ├── auth_service.dart              ← NOUVEAU (remplace Supabase auth)
│   ├── product_service.dart           ← NOUVEAU (catalogue API)
│   ├── cart_service.dart              ← NOUVEAU (panier API)
│   └── order_service.dart             ← NOUVEAU (commandes API)
├── screens/
│   ├── splash_screen.dart             ← REMPLACER
│   ├── auth/
│   │   ├── login_screen.dart          ← REMPLACER
│   │   └── register_screen.dart       ← REMPLACER
│   ├── home/
│   │   └── acceuil_connected.dart     ← REMPLACER Acceuil.dart
│   ├── products/
│   │   ├── products_screen.dart       ← REMPLACER Produit.dart
│   │   └── product_detail_screen.dart ← REMPLACER details.dart
│   ├── cart/
│   │   └── panier_connected.dart      ← REMPLACER panier.dart
│   ├── orders/
│   │   └── commande_connected.dart    ← REMPLACER commande.dart
│   └── profile/
│       ├── profil_connected.dart      ← REMPLACER Profil.dart
│       └── order_history_screen.dart  ← NOUVEAU
└── pubspec.yaml                       ← REMPLACER
```

---

## 🚀 Étapes de migration pas à pas

### Étape 1 — Installer les dépendances

Remplacez votre `pubspec.yaml` et exécutez :

```bash
flutter pub get
```

### Étape 2 — Configurer l'URL de l'API

Dans `lib/utils/api_constants.dart`, changez `baseUrl` selon votre environnement :

```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:8000/api';

// iOS Simulator
static const String baseUrl = 'http://localhost:8000/api';

// Appareil physique sur le même réseau WiFi
static const String baseUrl = 'http://192.168.1.XXX:8000/api';
// Remplacez XXX par l'IP de votre ordinateur (ifconfig ou ipconfig)
```

### Étape 3 — Supprimer les références Supabase

Dans votre ancien `main.dart`, supprimez :

```dart
// ❌ SUPPRIMER ces lignes
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
await Supabase.initialize(url: '...', anonKey: '...');
```

Remplacez par le nouveau `main.dart` fourni (sans aucune référence Supabase).

### Étape 4 — Remplacer les écrans

Copiez les nouveaux fichiers dans votre projet :

```bash
# Copiez chaque fichier depuis ce dossier vers lib/ de votre projet
cp utils/api_constants.dart         → lib/utils/api_constants.dart
cp models/api_models.dart           → lib/models/api_models.dart
cp services/token_service.dart      → lib/services/token_service.dart
cp services/api_client.dart         → lib/services/api_client.dart
cp services/auth_service.dart       → lib/services/auth_service.dart
cp services/product_service.dart    → lib/services/product_service.dart
cp services/cart_service.dart       → lib/services/cart_service.dart
cp services/order_service.dart      → lib/services/order_service.dart
cp screens/splash_screen.dart       → lib/screens/splash_screen.dart
cp screens/auth/login_screen.dart   → lib/screens/auth/login_screen.dart
cp screens/auth/register_screen.dart→ lib/screens/auth/register_screen.dart
cp screens/home/acceuil_connected.dart    → lib/Acceuil.dart (ou adaptez)
cp screens/products/products_screen.dart  → lib/Produit.dart
cp screens/products/product_detail_screen.dart → lib/details.dart
cp screens/cart/panier_connected.dart     → lib/panier.dart
cp screens/orders/commande_connected.dart → lib/commande.dart
cp screens/profile/profil_connected.dart  → lib/Profil.dart
cp screens/profile/order_history_screen.dart → lib/screens/profile/order_history_screen.dart
```

### Étape 5 — Configurer Android (réseau HTTP local)

Modifiez `android/app/src/main/AndroidManifest.xml` — ajoutez dans `<application>` :

```xml
<application
    android:usesCleartextTraffic="true"   ← AJOUTER cette ligne
    ...>
```

> ⚠️ Ceci est pour le développement local uniquement.
> En production, utilisez HTTPS et supprimez cette ligne.

### Étape 6 — Lancer le backend Django

```bash
cd marketplace_backend
python manage.py runserver 0.0.0.0:8000
```

L'option `0.0.0.0` permet l'accès depuis un appareil physique.

### Étape 7 — Lancer Flutter

```bash
flutter run
```

---

## 🔄 Correspondance des appels API

### Authentification

```dart
// ✅ INSCRIPTION
final result = await AuthService.register(
  email: 'user@example.com',
  name: 'Jean Dupont',
  phone: '655000000',
  password: 'motdepasse123',
  password2: 'motdepasse123',
);
if (result.success) print(result.user?.name);

// ✅ CONNEXION
final result = await AuthService.login(
  email: 'user@example.com',
  password: 'motdepasse123',
);

// ✅ DÉCONNEXION
await AuthService.logout();

// ✅ PROFIL
final user = await AuthService.getProfile();
print(user?.name); // Sophie Martin
```

### Produits & Accueil

```dart
// ✅ PAGE D'ACCUEIL (1 seul appel = phares + promos + catégories)
final homeData = await ProductService.getHomeData();
homeData?.featuredProducts;  // List<FeaturedProductModel>
homeData?.promotions;        // List<PromotionModel>
homeData?.categories;        // List<CategoryModel>

// ✅ LISTE PRODUITS AVEC FILTRES
final products = await ProductService.getProducts(
  search: 'tomate',
  categoryId: 2,
  minPrice: 500,
  maxPrice: 5000,
  ordering: '-price',  // prix décroissant
);

// ✅ DÉTAIL PRODUIT
final product = await ProductService.getProductDetail(3);
print(product?.priceDisplay);  // "1500 FCFA"
print(product?.fullImageUrl);  // "http://10.0.2.2:8000/media/..."
```

### Panier

```dart
// ✅ VOIR LE PANIER
final cart = await CartService.getCart();
print(cart?.total);       // 6000
print(cart?.totalItems);  // 3

// ✅ AJOUTER AU PANIER
final result = await CartService.addToCart(productId: 5, quantity: 2);

// ✅ MODIFIER QUANTITÉ
await CartService.updateQuantity(cartItemId: 1, quantity: 3);

// ✅ SUPPRIMER UN ARTICLE
await CartService.removeItem(cartItemId: 1);

// ✅ VIDER LE PANIER
await CartService.clearCart();
```

### Commandes

```dart
// ✅ PASSER UNE COMMANDE
final result = await OrderService.createOrder(
  deliveryName: 'Jean Dupont',
  deliveryPhone: '655000000',
  deliveryAddress: 'Bastos, Rue 1234',
  deliveryCity: 'Yaoundé',
  paymentMethod: 'mobile_money',  // ou 'cash_on_delivery'
);

// ✅ HISTORIQUE
final orders = await OrderService.getOrders();

// ✅ ANNULER
await OrderService.cancelOrder(orderId);
```

---

## 🖼️ Afficher les images du serveur

Dans votre ancien code, vous utilisiez `Image.asset(product.image)`.
Maintenant les images viennent du serveur Django.

```dart
// ❌ Ancien code (assets locaux)
Image.asset('assets/images/tomates.png')

// ✅ Nouveau code (images du serveur)
Image.network(product.fullImageUrl)

// ✅ Avec gestion d'erreur
Image.network(
  product.fullImageUrl,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) =>
      Container(color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported)),
)

// ✅ Avec cache (recommandé, nécessite cached_network_image)
CachedNetworkImage(
  imageUrl: product.fullImageUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

## 🔐 Gestion du token JWT

Le token est stocké de façon sécurisée dans `flutter_secure_storage`.
Il est envoyé automatiquement dans chaque requête par `ApiClient`.

```dart
// Vérifier si connecté (dans SplashScreen)
final isLoggedIn = await TokenService.isLoggedIn();

// Obtenir le token manuellement si besoin
final token = await TokenService.getAccessToken();

// Le token se rafraîchit automatiquement si expiré (géré par ApiClient)
```

---

## ⚙️ Configuration Android réseau (important)

**Fichier** : `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- AJOUTER cette permission si absente -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="foodexpress"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">   ← AJOUTER pour HTTP local
        ...
    </application>
</manifest>
```

---

## ✅ Checklist finale

- [ ] `pubspec.yaml` mis à jour (`flutter pub get` exécuté)
- [ ] `main.dart` remplacé (Supabase supprimé)
- [ ] `api_constants.dart` créé avec la bonne IP
- [ ] Tous les services copiés dans `lib/services/`
- [ ] Tous les modèles copiés dans `lib/models/`
- [ ] Tous les écrans mis à jour
- [ ] `AndroidManifest.xml` modifié (`usesCleartextTraffic="true"`)
- [ ] Serveur Django lancé (`python manage.py runserver 0.0.0.0:8000`)
- [ ] `flutter run` → inscription → connexion → test produits → test panier → test commande
