// lib/screens/profile/profil_connected.dart
// ============================================
// Profil connecté — remplace Profil.dart + profile_screen.dart (Supabase)
// ============================================
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/api_models.dart';
import '../auth/login_screen.dart';
import 'order_history_screen.dart';

class ProfilConnected extends StatefulWidget {
  const ProfilConnected({super.key});

  @override
  State<ProfilConnected> createState() => _ProfilConnectedState();
}

class _ProfilConnectedState extends State<ProfilConnected> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await AuthService.getProfile();
    if (mounted) setState(() { _user = user; _isLoading = false; });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vous déconnecter ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Se déconnecter',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F4),
        elevation: 0,
        title: const Text('Mon Compte',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Entête ────────────────────
                  const Text('Bienvenue !',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent)),
                  if (_user != null) ...[
                    const SizedBox(height: 4),
                    Text(_user!.name,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87)),
                    Text(_user!.email,
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 14)),
                  ],
                  const SizedBox(height: 32),

                  // ── Paramètres ────────────────
                  const Text('Paramètres',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  _SettingsButton(
                    icon: Icons.person_outline,
                    label: 'Voir mes informations',
                    onTap: () => _showProfileInfo(),
                  ),
                  _SettingsButton(
                    icon: Icons.access_time,
                    label: 'Historique des commandes',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen()),
                    ),
                  ),
                  _SettingsButton(
                    icon: Icons.lock_outline,
                    label: 'Changer le mot de passe',
                    onTap: () => _showChangePassword(),
                  ),
                  if (_user?.isAdmin == true)
                    _SettingsButton(
                      icon: Icons.admin_panel_settings,
                      label: 'Admin — Gestion produits',
                      color: Colors.blue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Accès admin : http://localhost:8000/admin')),
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  _SettingsButton(
                    icon: Icons.logout,
                    label: 'Se déconnecter',
                    color: Colors.red,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
    );
  }

  void _showProfileInfo() {
    if (_user == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mes informations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InfoRow(Icons.person, 'Nom', _user!.name),
            _InfoRow(Icons.email, 'Email', _user!.email),
            _InfoRow(Icons.phone, 'Téléphone',
                _user!.phone.isEmpty ? 'Non renseigné' : _user!.phone),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditProfile();
            },
            child: const Text('Modifier'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer')),
        ],
      ),
    );
  }

  void _showEditProfile() {
    if (_user == null) return;
    final nameCtrl = TextEditingController(text: _user!.name);
    final phoneCtrl = TextEditingController(text: _user!.phone);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await AuthService.updateProfile(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );
              if (res.success) _loadProfile();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangePassword() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final new2Ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Ancien mot de passe'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: new2Ctrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirmer'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await AuthService.changePassword(
                oldPassword: oldCtrl.text,
                newPassword: newCtrl.text,
                newPassword2: new2Ctrl.text,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(res.success
                      ? 'Mot de passe modifié ✓'
                      : res.error ?? 'Erreur'),
                  backgroundColor:
                      res.success ? Colors.green : Colors.red,
                ));
              }
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SettingsButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF2196F3),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label,
            style: TextStyle(
                fontSize: 15,
                color: color == Colors.red ? Colors.red : Colors.black87,
                fontWeight: color == Colors.red
                    ? FontWeight.w500
                    : FontWeight.normal)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
                Text(value,
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
