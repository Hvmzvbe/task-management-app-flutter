import 'package:first_app/models/task_model.dart';
import 'package:first_app/providers/task_provider.dart';
import 'package:first_app/screen/add_edit_task_screen.dart';
import 'package:first_app/utils/constants/colors.dart';
import 'package:first_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Iconsax.filter),
            onSelected: (value) {
              Provider.of<TaskProvider>(context, listen: false).setFilter(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Toutes', child: Text('Toutes les tâches')),
              const PopupMenuItem(value: 'En cours', child: Text('En cours')),
              const PopupMenuItem(value: 'Terminées', child: Text('Terminées')),
            ],
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = taskProvider.tasks;

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.task_square,
                    size: 100,
                    color: TColors.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune tâche',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour créer une tâche',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Statistiques
              Container(
                padding: const EdgeInsets.all(16),
                color: THelperFunctions.isDarkMode(context)
                    ? TColors.darkContainer
                    : TColors.lightContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: 'Total',
                        value: taskProvider.totalTasks,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatChip(
                        label: 'En cours',
                        value: taskProvider.pendingTasks,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatChip(
                        label: 'Terminées',
                        value: taskProvider.completedTasks,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Filtres de catégorie
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _CategoryChip(
                      label: 'Toutes',
                      isSelected: taskProvider.selectedCategory == 'Toutes',
                      onTap: () => taskProvider.setCategory('Toutes'),
                    ),
                    const SizedBox(width: 8),
                    _CategoryChip(
                      label: 'Travail',
                      isSelected: taskProvider.selectedCategory == 'Travail',
                      onTap: () => taskProvider.setCategory('Travail'),
                    ),
                    const SizedBox(width: 8),
                    _CategoryChip(
                      label: 'Personnel',
                      isSelected: taskProvider.selectedCategory == 'Personnel',
                      onTap: () => taskProvider.setCategory('Personnel'),
                    ),
                    const SizedBox(width: 8),
                    _CategoryChip(
                      label: 'Urgent',
                      isSelected: taskProvider.selectedCategory == 'Urgent',
                      onTap: () => taskProvider.setCategory('Urgent'),
                    ),
                  ],
                ),
              ),

              // Liste des tâches
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditTaskScreen(task: task),
                            ),
                          );
                        },
                        onToggle: () {
                          taskProvider.toggleTaskCompletion(task.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // IMPORTANT: Navigation vers le formulaire
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTaskScreen(),
            ),
          );
        },
        icon: const Icon(Iconsax.add),
        label: const Text('Nouvelle tâche'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// Widget pour les statistiques
class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}

// Widget pour les chips de catégorie
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? TColors.primary : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Widget pour la carte de tâche
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
                                fontWeight: FontWeight.bold,
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
                            fontSize: 11,
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
