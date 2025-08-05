import 'package:flutter/material.dart';
import 'package:foodexpress/authentification/authentification.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Section de l'avatar et des informations de l'utilisateur
            _buildProfileHeader(context),
            const SizedBox(height: 30),

            // Section "Paramètres"
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 60,
          backgroundImage: const AssetImage('assets/images/avatar_sophie.png'), // Assurez-vous que l'image est dans votre dossier assets
          backgroundColor: const Color(0xFFEADDD8),
        ),
        const SizedBox(height: 15),

        // Nom de l'utilisateur
        const Text(
          'Sophie Martin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 5),

        // Email de l'utilisateur
        const Text(
          'sophie.martin@email.com',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFB17E7B),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section
        const Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 20),

        // Liste des options
        
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFFB17E7B)),
              title: const Text(
          'Informations personnelles',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildSettingsOption(context, Icons.access_time, 'Historique des commandes'),
        const SizedBox(height: 10),
        _buildSettingsOption(context, Icons.location_on_outlined, 'Adresses de livraison'),
        const SizedBox(height: 10),
        _buildSettingsOption(context, Icons.credit_card, 'Préférences de paiement'),
      ],
    );
  }

  Widget _buildSettingsOption(BuildContext context, IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB17E7B)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Gérer le clic sur l'option ici
          // Par exemple, naviguer vers une autre page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliquer sur $title')),
          );
        },
      ),
    );
  }
}