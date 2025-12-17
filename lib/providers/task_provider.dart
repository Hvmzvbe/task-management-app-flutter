import 'package:flutter/material.dart';

// Modèle de tâche
class Task {
  final String id;
  final String title;
  final String description;
  final String priority; // 'Haute', 'Moyenne', 'Basse'
  final String status; // 'En cours', 'Terminée', 'En attente'
  final DateTime dueDate;
  final DateTime createdAt;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    this.isCompleted = false,
  });

  Task copyWith({
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'Toutes'; // 'Toutes', 'En cours', 'Terminées'

  // Getters
  List<Task> get tasks {
    switch (_selectedFilter) {
      case 'En cours':
        return _tasks.where((task) => !task.isCompleted).toList();
      case 'Terminées':
        return _tasks.where((task) => task.isCompleted).toList();
      default:
        return _tasks;
    }
  }

  List<Task> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;

  // Statistiques
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  int get highPriorityTasks => 
      _tasks.where((task) => task.priority == 'Haute' && !task.isCompleted).length;

  // Initialiser avec des données de démonstration
  void initializeWithDemoData() {
    _tasks = [
      Task(
        id: '1',
        title: 'Développer la page d\'accueil',
        description: 'Créer l\'interface utilisateur avec Flutter',
        priority: 'Haute',
        status: 'En cours',
        dueDate: DateTime.now(),
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Task(
        id: '2',
        title: 'Réunion d\'équipe',
        description: 'Discussion sur le projet et planification',
        priority: 'Moyenne',
        status: 'En attente',
        dueDate: DateTime.now().add(Duration(days: 1)),
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Task(
        id: '3',
        title: 'Révision du code',
        description: 'Code review hebdomadaire avec l\'équipe',
        priority: 'Basse',
        status: 'En attente',
        dueDate: DateTime.now().add(Duration(days: 5)),
        createdAt: DateTime.now(),
      ),
      Task(
        id: '4',
        title: 'Tests unitaires',
        description: 'Écrire les tests pour les nouvelles fonctionnalités',
        priority: 'Haute',
        status: 'En cours',
        dueDate: DateTime.now().add(Duration(days: 2)),
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        isCompleted: false,
      ),
      Task(
        id: '5',
        title: 'Documentation',
        description: 'Mettre à jour la documentation du projet',
        priority: 'Moyenne',
        status: 'Terminée',
        dueDate: DateTime.now().subtract(Duration(days: 1)),
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        isCompleted: true,
      ),
    ];
    notifyListeners();
  }

  // Ajouter une tâche
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Mettre à jour une tâche
  void updateTask(String taskId, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  // Supprimer une tâche
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Marquer comme complétée/non complétée
  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _tasks[index] = _tasks[index].copyWith(
        status: _tasks[index].isCompleted ? 'Terminée' : 'En cours',
      );
      notifyListeners();
    }
  }

  // Changer le filtre
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Obtenir les tâches par priorité
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // Obtenir les tâches du jour
  List<Task> getTodayTasks() {
    final today = DateTime.now();
    return _tasks.where((task) {
      return task.dueDate.year == today.year &&
          task.dueDate.month == today.month &&
          task.dueDate.day == today.day &&
          !task.isCompleted;
    }).toList();
  }

  // Obtenir les tâches en retard
  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      return task.dueDate.isBefore(now) && !task.isCompleted;
    }).toList();
  }

  // Effacer le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}