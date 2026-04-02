# 🛒 Marketplace Backend — Django + DRF

Backend complet pour l'application mobile Flutter **FoodExpress / Marketplace**.  
Authentification JWT, gestion des produits, panier, commandes, panel admin.

---

## 📁 Structure du projet

```
marketplace_backend/
├── manage.py
├── requirements.txt
├── marketplace/                  # Config principale Django
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── apps/
    ├── accounts/                 # Authentification & profils
    │   ├── models.py             # User (custom), DeliveryAddress
    │   ├── serializers.py
    │   ├── views.py
    │   ├── urls.py
    │   └── admin.py
    ├── products/                 # Produits, catégories, promos
    │   ├── models.py             # Category, Product, FeaturedProduct, Promotion
    │   ├── serializers.py
    │   ├── views.py
    │   ├── urls.py
    │   ├── permissions.py
    │   └── admin.py
    ├── cart/                     # Panier
    │   ├── models.py             # Cart, CartItem
    │   ├── serializers.py
    │   ├── views.py
    │   ├── urls.py
    │   └── admin.py
    └── orders/                   # Commandes
        ├── models.py             # Order, OrderItem
        ├── serializers.py
        ├── views.py
        ├── urls.py
        └── admin.py
```

---

## 🚀 Installation

### 1. Créer et activer l'environnement virtuel

```bash
python -m venv venv

# Linux / macOS
source venv/bin/activate

# Windows
venv\Scripts\activate
```

### 2. Installer les dépendances

```bash
pip install -r requirements.txt
```

### 3. Appliquer les migrations

```bash
python manage.py makemigrations accounts products cart orders
python manage.py migrate
```

### 4. Créer un superutilisateur (admin)

```bash
python manage.py createsuperuser
```
> Lors de la création, cochez `is_admin=True` via le panel admin après création,  
> ou passez par le shell :
```bash
python manage.py shell
>>> from apps.accounts.models import User
>>> u = User.objects.get(email='votre@email.com')
>>> u.is_admin = True; u.is_staff = True; u.save()
```

### 5. Lancer le serveur

```bash
python manage.py runserver
```

Le serveur sera disponible sur : `http://localhost:8000`  
Panel admin Django : `http://localhost:8000/admin/`

---

## 📡 API Reference — Routes complètes

### Base URL : `http://localhost:8000/api`

---

### 🔐 Authentification — `/api/auth/`

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| POST | `/auth/register/` | Inscription client | ❌ |
| POST | `/auth/login/` | Connexion → retourne access + refresh tokens | ❌ |
| POST | `/auth/logout/` | Déconnexion (blacklist refresh token) | ✅ |
| POST | `/auth/token/refresh/` | Rafraîchir le token access | ❌ |
| GET | `/auth/profile/` | Voir son profil | ✅ |
| PUT | `/auth/profile/` | Modifier son profil | ✅ |
| POST | `/auth/change-password/` | Changer son mot de passe | ✅ |
| GET | `/auth/addresses/` | Liste adresses de livraison | ✅ |
| POST | `/auth/addresses/` | Ajouter une adresse | ✅ |
| PUT | `/auth/addresses/<id>/` | Modifier une adresse | ✅ |
| DELETE | `/auth/addresses/<id>/` | Supprimer une adresse | ✅ |

#### Exemple — Inscription
```json
POST /api/auth/register/
{
  "email": "client@example.com",
  "name": "Jean Dupont",
  "phone": "655000000",
  "password": "monmotdepasse123",
  "password2": "monmotdepasse123"
}
```

#### Exemple — Connexion
```json
POST /api/auth/login/
{
  "email": "client@example.com",
  "password": "monmotdepasse123"
}
// Réponse :
{
  "access": "eyJ0eXAi...",
  "refresh": "eyJ0eXAi...",
  "user": { "id": 1, "email": "...", "name": "...", "is_admin": false }
}
```

> **Dans Flutter**, stocker le token `access` et l'envoyer dans chaque requête :  
> `Authorization: Bearer <access_token>`

---

### 🏠 Page d'accueil — `/api/products/`

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| GET | `/products/home/` | Produits phares + Promos + Catégories (1 seule requête) | ❌ |
| GET | `/products/` | Liste des produits avec filtres | ❌ |
| GET | `/products/<id>/` | Détail d'un produit | ❌ |
| GET | `/products/categories/` | Liste des catégories actives | ❌ |

#### Filtres disponibles sur `/api/products/`
```
?search=tomate          # Recherche par nom, description, catégorie, origine
?category=2             # Filtrer par catégorie (id)
?min_price=500          # Prix minimum
?max_price=5000         # Prix maximum
?origin=Local           # Filtrer par origine
?featured=true          # Seulement les produits phares
?ordering=price         # Tri par prix croissant
?ordering=-price        # Tri par prix décroissant
```

---

### 🛍️ Panier — `/api/cart/`

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| GET | `/cart/` | Voir le panier | ✅ |
| POST | `/cart/add/` | Ajouter / incrémenter un produit | ✅ |
| PUT | `/cart/items/<id>/` | Modifier la quantité d'un article | ✅ |
| DELETE | `/cart/items/<id>/` | Supprimer un article du panier | ✅ |
| DELETE | `/cart/clear/` | Vider tout le panier | ✅ |

#### Exemple — Ajouter au panier
```json
POST /api/cart/add/
{
  "product_id": 3,
  "quantity": 2
}
```

---

### 📦 Commandes — `/api/orders/`

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| GET | `/orders/` | Historique des commandes | ✅ |
| POST | `/orders/create/` | Passer une commande depuis le panier | ✅ |
| GET | `/orders/<id>/` | Détail d'une commande | ✅ |
| POST | `/orders/<id>/cancel/` | Annuler une commande (si en attente) | ✅ |

#### Exemple — Passer une commande
```json
POST /api/orders/create/
{
  "delivery_name": "Jean Dupont",
  "delivery_phone": "655000000",
  "delivery_address": "Quartier Bastos, Rue 1234",
  "delivery_city": "Yaoundé",
  "payment_method": "mobile_money",
  "note": "Laisser au gardien si absent"
}
// payment_method: "mobile_money" | "cash_on_delivery"
```

---

### 🔧 Routes ADMIN (is_admin requis)

#### Catégories
```
GET/POST   /api/products/admin/categories/
GET/PUT/DELETE  /api/products/admin/categories/<id>/
```

#### Produits
```
GET/POST   /api/products/admin/products/
GET/PUT/DELETE  /api/products/admin/products/<id>/
```

#### Produits phares
```
GET/POST   /api/products/admin/featured/
GET/PUT/DELETE  /api/products/admin/featured/<id>/
```

#### Promotions
```
GET/POST   /api/products/admin/promotions/
GET/PUT/DELETE  /api/products/admin/promotions/<id>/
```

#### Commandes (admin)
```
GET   /api/orders/admin/           # Toutes les commandes (?status=pending)
GET/PUT  /api/orders/admin/<id>/   # Voir/modifier statut
```
**Statuts possibles :** `pending` → `confirmed` → `preparing` → `delivering` → `delivered` | `cancelled`

---

## 🔑 Intégration Flutter — Remplacer Supabase par Django JWT

### Avant (Supabase)
```dart
await supabase.auth.signInWithPassword(email: ..., password: ...);
```

### Après (Django DRF JWT)
```dart
// 1. Connexion
final response = await http.post(
  Uri.parse('http://localhost:8000/api/auth/login/'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'email': email, 'password': password}),
);
final data = jsonDecode(response.body);
final accessToken = data['access'];
final refreshToken = data['refresh'];
// Stocker avec flutter_secure_storage

// 2. Appels authentifiés
final productsResponse = await http.get(
  Uri.parse('http://localhost:8000/api/products/'),
  headers: {'Authorization': 'Bearer $accessToken'},
);

// 3. Déconnexion
await http.post(
  Uri.parse('http://localhost:8000/api/auth/logout/'),
  headers: {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({'refresh': refreshToken}),
);
```

---

## 👤 Rôles utilisateurs

| Rôle | `is_admin` | Accès |
|------|-----------|-------|
| Client | `false` | Produits, Panier, Commandes perso |
| Admin | `true` | Tout + gestion produits/catégories/promos/commandes |

Pour promouvoir un utilisateur admin via le panel Django :  
`http://localhost:8000/admin/` → Utilisateurs → Cocher `is_admin` et `is_staff`

---

## 🗄️ Modèles de données principaux

| Modèle | Champs clés |
|--------|-------------|
| `User` | email, name, phone, is_admin |
| `Category` | name, slug, image, background_color |
| `Product` | title, price, image, category, is_featured, stock, origin |
| `FeaturedProduct` | product, label, order |
| `Promotion` | title, subtitle, discount_percent, product, validity_text |
| `Cart` | user (OneToOne), items |
| `CartItem` | cart, product, quantity |
| `Order` | user, status, payment_method, delivery_*, total |
| `OrderItem` | order, product_title (snapshot), unit_price, quantity |

---

## 🌐 Pour la production

1. Changer `SECRET_KEY` dans settings.py (utiliser variable d'environnement)
2. Mettre `DEBUG = False`
3. Configurer PostgreSQL à la place de SQLite
4. Ajouter `gunicorn` + `nginx`
5. Configurer `ALLOWED_HOSTS` et `CORS_ALLOWED_ORIGINS`
6. Utiliser `whitenoise` pour les fichiers statiques
