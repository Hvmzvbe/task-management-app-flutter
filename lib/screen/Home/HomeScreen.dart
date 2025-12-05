import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';

// ignore_for_file: unused_element, deprecated_member_use

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour! 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Voici vos tâches du jour',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              // Statistiques rapides
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Iconsax.task_square,
                      title: 'Tâches',
                      value: '12',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Iconsax.tick_circle,
                      title: 'Terminées',
                      value: '8',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Iconsax.clock,
                      title: 'En cours',
                      value: '4',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Iconsax.people,
                      title: 'Équipes',
                      value: '3',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              Text(
                'Tâches récentes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Liste des tâches (exemple)
              _TaskCard(
                title: 'Développer la page d\'accueil',
                description: 'Créer l\'interface utilisateur',
                priority: 'Haute',
                dueDate: 'Aujourd\'hui',
              ),
              const SizedBox(height: 12),
              _TaskCard(
                title: 'Réunion d\'équipe',
                description: 'Discussion sur le projet',
                priority: 'Moyenne',
                dueDate: 'Demain',
              ),
              const SizedBox(height: 12),
              _TaskCard(
                title: 'Révision du code',
                description: 'Code review hebdomadaire',
                priority: 'Basse',
                dueDate: 'Cette semaine',
              ),
            ],
          ),
        ),
      ),
    );
  }
}








class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}





class _TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String dueDate;

  const _TaskCard({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = priority == 'Haute' 
        ? Colors.red 
        : priority == 'Moyenne' 
            ? Colors.orange 
            : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: THelperFunctions.isDarkMode(context) 
            ? TColors.darkContainer 
            : TColors.lightContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: THelperFunctions.isDarkMode(context)
              ? TColors.darkGrey
              : TColors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Iconsax.calendar, size: 16, color: TColors.darkGrey),
              const SizedBox(width: 4),
              Text(
                dueDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}