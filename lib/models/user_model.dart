import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String phoneNumber;

  @HiveField(6)
  final String password; // Password hashé

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  bool isLoggedIn;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.createdAt,
    this.isLoggedIn = false,
  });

  // Méthode pour obtenir le nom complet
  String get fullName => '$firstName $lastName';

  // Convertir en Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'isLoggedIn': isLoggedIn,
    };
  }

  // Créer depuis Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }
}