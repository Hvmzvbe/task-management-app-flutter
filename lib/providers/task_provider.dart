import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';
 

class TaskProvider extends ChangeNotifier {
  static const String _boxName = 'tasks';
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'Toutes';
  String _selectedCategory = 'Toutes';

  // Getters
  List<Task> get tasks {
    List<Task> filteredTasks = _tasks;

    // Filtrer par statut
    switch (_selectedFilter) {
      case 'En cours':
        filteredTasks = filteredTasks.where((task) => !task.isCompleted).toList();
        break;
      case 'Terminées':
        filteredTasks = filteredTasks.where((task) => task.isCompleted).toList();
        break;
    }

    // Filtrer par catégorie
    if (_selectedCategory != 'Toutes') {
      filteredTasks = filteredTasks
          .where((task) => task.category == _selectedCategory)
          .toList();
    }

    return filteredTasks;
  }

  List<Task> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get selectedCategory => _selectedCategory;

  // Statistiques
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  int get highPriorityTasks =>
      _tasks.where((task) => task.priority == 'Haute' && !task.isCompleted).length;

  // Initialiser et charger les tâches depuis Hive
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = await Hive.openBox<Task>(_boxName);
      _tasks = box.values.toList();

      // Si aucune tâche, initialiser avec des données de démo
      if (_tasks.isEmpty) {
        await initializeWithDemoData();
      }
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des tâches: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtenir la box Hive
  Future<Box<Task>> _getTaskBox() async {
    return await Hive.openBox<Task>(_boxName);
  }

  // Initialiser avec des données de démonstration
  Future<void> initializeWithDemoData() async {
    final demoTasks = [
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Développer la page d\'accueil',
        description: 'Créer l\'interface utilisateur avec Flutter',
        priority: 'Haute',
        status: 'En cours',
        dueDate: DateTime.now(),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Travail',
      ),
      Task(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: 'Réunion d\'équipe',
        description: 'Discussion sur le projet et planification',
        priority: 'Moyenne',
        status: 'En attente',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Travail',
      ),
      Task(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        title: 'Faire les courses',
        description: 'Acheter les provisions pour la semaine',
        priority: 'Basse',
        status: 'En attente',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
        category: 'Personnel',
      ),
      Task(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        title: 'Tests unitaires',
        description: 'Écrire les tests pour les nouvelles fonctionnalités',
        priority: 'Haute',
        status: 'En cours',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isCompleted: false,
        category: 'Travail',
      ),
      Task(
        id: (DateTime.now().millisecondsSinceEpoch + 4).toString(),
        title: 'Documentation',
        description: 'Mettre à jour la documentation du projet',
        priority: 'Moyenne',
        status: 'Terminée',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isCompleted: true,
        category: 'Travail',
      ),
    ];

    for (var task in demoTasks) {
      await addTask(task);
    }
  }

  // CREATE - Ajouter une tâche
  Future<bool> addTask(Task task) async {
    try {
      final box = await _getTaskBox();
      await box.put(task.id, task);
      _tasks.add(task);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'ajout de la tâche: $e';
      notifyListeners();
      return false;
    }
  }

  // READ - Obtenir une tâche par ID
  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  // UPDATE - Mettre à jour une tâche
  Future<bool> updateTask(String taskId, Task updatedTask) async {
    try {
      final box = await _getTaskBox();
      final index = _tasks.indexWhere((task) => task.id == taskId);
      
      if (index != -1) {
        await box.put(taskId, updatedTask);
        _tasks[index] = updatedTask;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Erreur lors de la mise à jour: $e';
      notifyListeners();
      return false;
    }
  }

  // DELETE - Supprimer une tâche
  Future<bool> deleteTask(String taskId) async {
    try {
      final box = await _getTaskBox();
      await box.delete(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erreur lors de la suppression: $e';
      notifyListeners();
      return false;
    }
  }

  // Marquer comme complétée/non complétée
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final box = await _getTaskBox();
      final index = _tasks.indexWhere((task) => task.id == taskId);
      
      if (index != -1) {
        final task = _tasks[index];
        task.isCompleted = !task.isCompleted;
        task.status = task.isCompleted ? 'Terminée' : 'En cours';
        
        await box.put(taskId, task);
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de la mise à jour: $e';
      notifyListeners();
    }
  }

  // Changer le filtre
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Changer la catégorie
  void setCategory(String category) {
    _selectedCategory = category;
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

  // Obtenir les tâches de la semaine
  List<Task> getWeekTasks() {
    final now = DateTime.now();
    final weekEnd = now.add(const Duration(days: 7));
    return _tasks.where((task) {
      return task.dueDate.isAfter(now) &&
          task.dueDate.isBefore(weekEnd) &&
          !task.isCompleted;
    }).toList();
  }

  // Effacer toutes les tâches
  Future<void> clearAllTasks() async {
    try {
      final box = await _getTaskBox();
      await box.clear();
      _tasks.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors de la suppression: $e';
      notifyListeners();
    }
  }

  // Effacer le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
