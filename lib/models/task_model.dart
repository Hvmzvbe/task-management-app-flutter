import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String priority; // 'Haute', 'Moyenne', 'Basse'

  @HiveField(4)
  String status; // 'En cours', 'Terminée', 'En attente'

  @HiveField(5)
  DateTime dueDate;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  bool isCompleted;

  @HiveField(8)
  String? category; // 'Travail', 'Personnel', 'Urgent', 'Autre'

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    this.isCompleted = false,
    this.category,
  });

  Task copyWith({
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
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
      category: category ?? this.category,
    );
  }
}
