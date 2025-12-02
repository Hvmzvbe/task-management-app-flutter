import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthService {
  static const String _boxName = 'users';
  static const String _currentUserKey = 'currentUser';
  
  // Obtenir la box des utilisateurs
  Future<Box<UserModel>> _getUserBox() async {
    return await Hive.openBox<UserModel>(_boxName);
  }

  // Hasher le mot de passe
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // S'inscrire
  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final box = await _getUserBox();

      // Vérifier si l'email existe déjà
      final existingUser = box.values.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          phoneNumber: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.id.isNotEmpty) {
        return {
          'success': false,
          'message': 'Cet email est déjà utilisé',
        };
      }

      // Vérifier si le username existe déjà
      final existingUsername = box.values.firstWhere(
        (user) => user.username.toLowerCase() == username.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          phoneNumber: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUsername.id.isNotEmpty) {
        return {
          'success': false,
          'message': 'Ce nom d\'utilisateur est déjà pris',
        };
      }

      // Créer le nouvel utilisateur
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: _hashPassword(password),
        createdAt: DateTime.now(),
        isLoggedIn: true,
      );

      // Sauvegarder dans Hive
      await box.put(newUser.id, newUser);
      
      // Sauvegarder comme utilisateur actuel
      final prefs = await Hive.openBox('preferences');
      await prefs.put(_currentUserKey, newUser.id);

      return {
        'success': true,
        'message': 'Compte créé avec succès',
        'user': newUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la création du compte: $e',
      };
    }
  }

  // Se connecter
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final box = await _getUserBox();
      final hashedPassword = _hashPassword(password);

      // Trouver l'utilisateur
      final user = box.values.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.password == hashedPassword,
        orElse: () => UserModel(
          id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          phoneNumber: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        return {
          'success': false,
          'message': 'Email ou mot de passe incorrect',
        };
      }

      // Mettre à jour le statut de connexion
      user.isLoggedIn = true;
      await user.save();

      // Sauvegarder comme utilisateur actuel
      final prefs = await Hive.openBox('preferences');
      await prefs.put(_currentUserKey, user.id);

      return {
        'success': true,
        'message': 'Connexion réussie',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la connexion: $e',
      };
    }
  }

  // Se déconnecter
  Future<void> logout() async {
    try {
      final prefs = await Hive.openBox('preferences');
      final userId = prefs.get(_currentUserKey);

      if (userId != null) {
        final box = await _getUserBox();
        final user = box.get(userId);
        
        if (user != null) {
          user.isLoggedIn = false;
          await user.save();
        }
      }

      await prefs.delete(_currentUserKey);
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  // Obtenir l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await Hive.openBox('preferences');
      final userId = prefs.get(_currentUserKey);

      if (userId == null) return null;

      final box = await _getUserBox();
      return box.get(userId);
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null && user.isLoggedIn;
  }

  // Obtenir tous les utilisateurs (pour debug)
  Future<List<UserModel>> getAllUsers() async {
    final box = await _getUserBox();
    return box.values.toList();
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    final box = await _getUserBox();
    await box.delete(userId);
  }

  // Mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
  }) async {
    try {
      final box = await _getUserBox();
      final user = box.get(userId);

      if (user == null) {
        return {
          'success': false,
          'message': 'Utilisateur non trouvé',
        };
      }

      // Créer un nouvel utilisateur avec les modifications
      final updatedUser = UserModel(
        id: user.id,
        firstName: firstName ?? user.firstName,
        lastName: lastName ?? user.lastName,
        username: username ?? user.username,
        email: user.email,
        phoneNumber: phoneNumber ?? user.phoneNumber,
        password: user.password,
        createdAt: user.createdAt,
        isLoggedIn: user.isLoggedIn,
      );

      await box.put(userId, updatedUser);

      return {
        'success': true,
        'message': 'Profil mis à jour avec succès',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la mise à jour: $e',
      };
    }
  }

  // Changer le mot de passe
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final box = await _getUserBox();
      final user = box.get(userId);

      if (user == null) {
        return {
          'success': false,
          'message': 'Utilisateur non trouvé',
        };
      }

      // Vérifier l'ancien mot de passe
      if (user.password != _hashPassword(oldPassword)) {
        return {
          'success': false,
          'message': 'Ancien mot de passe incorrect',
        };
      }

      // Mettre à jour le mot de passe
      final updatedUser = UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username,
        email: user.email,
        phoneNumber: user.phoneNumber,
        password: _hashPassword(newPassword),
        createdAt: user.createdAt,
        isLoggedIn: user.isLoggedIn,
      );

      await box.put(userId, updatedUser);

      return {
        'success': true,
        'message': 'Mot de passe changé avec succès',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du changement de mot de passe: $e',
      };
    }
  }
}