import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';

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
          child: Consumer2<AuthProvider, TaskProvider>(
            builder: (context, authProvider, taskProvider, child) {
              final user = authProvider.currentUser;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour ${user?.firstName ?? 'Utilisateur'}! 👋',
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
                          value: '${taskProvider.totalTasks}',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.tick_circle,
                          title: 'Terminées',
                          value: '${taskProvider.completedTasks}',
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
                          value: '${taskProvider.pendingTasks}',
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.danger,
                          title: 'Priorité haute',
                          value: '${taskProvider.highPriorityTasks}',
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tâches du jour',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Naviguer vers l'écran des tâches
                        },
                        child: const Text('Voir tout'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Liste des tâches du jour
                  ...taskProvider.getTodayTasks().take(3).map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(
                        task: task,
                        onToggle: () {
                          taskProvider.toggleTaskCompletion(task.id);
                        },
                      ),
                    );
                  }).toList(),
                  
                  // Si aucune tâche du jour
                  if (taskProvider.getTodayTasks().isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Iconsax.task_square,
                              size: 64,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune tâche pour aujourd\'hui',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
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
  final Task task;
  final VoidCallback onToggle;

  const _TaskCard({
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = task.priority == 'Haute' 
        ? Colors.red 
        : task.priority == 'Moyenne' 
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
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: 12),
          
          // Contenu de la tâche
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: task.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.calendar, size: 16, color: TColors.darkGrey),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    if (taskDate == today) {
      return 'Aujourd\'hui';
    } else if (taskDate == today.add(Duration(days: 1))) {
      return 'Demain';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}