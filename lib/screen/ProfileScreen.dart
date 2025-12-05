import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Photo de profil
              CircleAvatar(
                radius: 50,
                backgroundColor: TColors.primary,
                child: Icon(Iconsax.user, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Nom Utilisateur',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'email@example.com',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              
              // Options du profil
              _ProfileOption(
                icon: Iconsax.user_edit,
                title: 'Modifier le profil',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Iconsax.notification,
                title: 'Notifications',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Iconsax.security,
                title: 'Sécurité',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Iconsax.setting_2,
                title: 'Paramètres',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Iconsax.info_circle,
                title: 'À propos',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _ProfileOption(
                icon: Iconsax.logout,
                title: 'Déconnexion',
                onTap: () {
                  // TODO: Implémenter la déconnexion
                  THelperFunctions.showAlert(
                    'Déconnexion',
                    'Êtes-vous sûr de vouloir vous déconnecter?',
                  );
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : TColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }
}