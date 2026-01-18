import 'package:first_app/models/task_model.dart';
import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/providers/task_provider.dart';
import 'package:first_app/screen/add_edit_task_screen.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
            icon: const Icon(Iconsax.notification),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<TaskProvider>(context, listen: false).initialize();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer2<AuthProvider, TaskProvider>(
              builder: (context, authProvider, taskProvider, child) {
                final user = authProvider.currentUser;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête
                    Text(
                      'Bonjour ${user?.firstName ?? 'Utilisateur'}! 👋',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getGreetingMessage(taskProvider),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // Statistiques
                    _buildStatsSection(taskProvider, context),
                    const SizedBox(height: 24),

                    // Bouton créer une tâche
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditTaskScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Iconsax.add_circle),
                        label: const Text(
                          'Créer une nouvelle tâche',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tâches en retard
                    if (taskProvider.getOverdueTasks().isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Tâches en retard',
                        '${taskProvider.getOverdueTasks().length}',
                        Colors.red,
                      ),
                      const SizedBox(height: 12),
                      ...taskProvider
                          .getOverdueTasks()
                          .take(3)
                          .map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TaskCard(
                                  task: task,
                                  onTap: () => _navigateToTaskDetail(context, task),
                                  onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 24),
                    ],

                    // Tâches du jour
                    _buildSectionHeader(
                      context,
                      'Tâches du jour',
                      '${taskProvider.getTodayTasks().length}',
                      TColors.primary,
                    ),
                    const SizedBox(height: 12),

                    if (taskProvider.getTodayTasks().isEmpty)
                      _buildEmptyState(
                        context,
                        'Aucune tâche pour aujourd\'hui',
                        'Profitez de votre journée! 🎉',
                      )
                    else
                      ...taskProvider
                          .getTodayTasks()
                          .take(3)
                          .map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TaskCard(
                                  task: task,
                                  onTap: () => _navigateToTaskDetail(context, task),
                                  onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                                ),
                              ))
                          .toList(),

                    if (taskProvider.getTodayTasks().length > 3)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Naviguer vers l'onglet des tâches
                          },
                          child: Text(
                            'Voir toutes les tâches (${taskProvider.getTodayTasks().length})',
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Tâches de la semaine
                    _buildSectionHeader(
                      context,
                      'Cette semaine',
                      '${taskProvider.getWeekTasks().length}',
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),

                    if (taskProvider.getWeekTasks().isEmpty)
                      _buildEmptyState(
                        context,
                        'Aucune tâche cette semaine',
                        'Planifiez vos prochaines tâches',
                      )
                    else
                      ...taskProvider
                          .getWeekTasks()
                          .take(3)
                          .map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TaskCard(
                                  task: task,
                                  onTap: () => _navigateToTaskDetail(context, task),
                                  onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                                ),
                              ))
                          .toList(),

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getGreetingMessage(TaskProvider taskProvider) {
    final hour = DateTime.now().hour;
    String timeGreeting;

    if (hour < 12) {
      timeGreeting = 'Bon matin';
    } else if (hour < 18) {
      timeGreeting = 'Bon après-midi';
    } else {
      timeGreeting = 'Bonsoir';
    }

    final pendingTasks = taskProvider.pendingTasks;
    if (pendingTasks == 0) {
      return '$timeGreeting! Vous avez terminé toutes vos tâches 🎉';
    } else {
      return '$timeGreeting! Vous avez $pendingTasks tâche${pendingTasks > 1 ? 's' : ''} en cours';
    }
  }

  Widget _buildStatsSection(TaskProvider taskProvider, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Iconsax.task_square,
                title: 'Total',
                value: '${taskProvider.totalTasks}',
                color: TColors.primary,
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
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String count,
    Color color,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Iconsax.task_square,
              size: 64,
              color: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
  }
}

// Widget Cartes de stats
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
        color: THelperFunctions.isDarkMode(context)
            ? TColors.darkContainer
            : TColors.lightContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: THelperFunctions.isDarkMode(context)
              ? TColors.darkGrey
              : TColors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Widget Carte de tâche
class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = task.priority == 'Haute'
        ? Colors.red
        : task.priority == 'Moyenne'
            ? Colors.orange
            : Colors.green;

    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: THelperFunctions.isDarkMode(context)
              ? TColors.darkContainer
              : TColors.lightContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? Colors.red
                : THelperFunctions.isDarkMode(context)
                    ? TColors.darkGrey
                    : TColors.grey,
            width: isOverdue ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
              shape: const CircleBorder(),
              activeColor: Colors.green,
            ),
            const SizedBox(width: 12),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar,
                        size: 14,
                        color: isOverdue ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey,
                        ),
                      ),
                      if (task.category != null) ...[
                        const SizedBox(width: 12),
                        Icon(Iconsax.tag, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          task.category!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
