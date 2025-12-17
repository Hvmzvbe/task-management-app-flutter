import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/providers/theme_provider.dart';
import 'package:first_app/screen/Auth/login_page.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
          child: Consumer2<AuthProvider, ThemeProvider>(
            builder: (context, authProvider, themeProvider, child) {
              final user = authProvider.currentUser;
              
              return Column(
                children: [
                  // Photo de profil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: TColors.primary,
                    child: Text(
                      user?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Utilisateur',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@${user?.username ?? 'username'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Options du profil
                  _ProfileOption(
                    icon: Iconsax.user_edit,
                    title: 'Modifier le profil',
                    onTap: () {
                      // TODO: Naviguer vers la page d'édition du profil
                      THelperFunctions.showSnackBar('Fonctionnalité à venir');
                    },
                  ),
                  
                  // Toggle Dark Mode
                  _ProfileOptionWithSwitch(
                    icon: themeProvider.isDarkMode ? Iconsax.moon : Iconsax.sun_1,
                    title: 'Mode sombre',
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                  
                  _ProfileOption(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    onTap: () {
                      THelperFunctions.showSnackBar('Fonctionnalité à venir');
                    },
                  ),
                  _ProfileOption(
                    icon: Iconsax.security,
                    title: 'Sécurité',
                    onTap: () {
                      THelperFunctions.showSnackBar('Fonctionnalité à venir');
                    },
                  ),
                  _ProfileOption(
                    icon: Iconsax.setting_2,
                    title: 'Paramètres',
                    onTap: () {
                      THelperFunctions.showSnackBar('Fonctionnalité à venir');
                    },
                  ),
                  _ProfileOption(
                    icon: Iconsax.info_circle,
                    title: 'À propos',
                    onTap: () {
                      THelperFunctions.showAlert(
                        'À propos',
                        'Application de gestion de tâches\nVersion 1.0.0',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _ProfileOption(
                    icon: Iconsax.logout,
                    title: 'Déconnexion',
                    onTap: () {
                      _showLogoutDialog(context, authProvider);
                    },
                    isDestructive: true,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Informations supplémentaires
                  if (user != null) ...[
                    Divider(),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: 'Numéro de téléphone',
                      value: user.phoneNumber,
                    ),
                    const SizedBox(height: 8),
                    _InfoTile(
                      label: 'Membre depuis',
                      value: _formatDate(user.createdAt),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
                Get.offAll(() => Loginpage());
              },
              child: Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

class _ProfileOptionWithSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileOptionWithSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: TColors.primary,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: TColors.primary,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}