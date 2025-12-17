import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _currentUser!.isLoggedIn;

  // Initialiser le provider (vérifier si l'utilisateur est déjà connecté)
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'initialisation: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Se connecter
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // S'inscrire
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signUp(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Se déconnecter
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erreur lors de la déconnexion: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour le profil
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.updateProfile(
        userId: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        username: username,
        phoneNumber: phoneNumber,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Changer le mot de passe
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.changePassword(
        userId: _currentUser!.id,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (result['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Effacer le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}