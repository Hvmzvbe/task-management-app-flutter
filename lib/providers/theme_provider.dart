import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;
  
  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  // Charger la préférence de thème depuis le stockage local
  Future<void> _loadThemePreference() async {
    try {
      final box = await Hive.openBox('preferences');
      _isDarkMode = box.get(_themeKey, defaultValue: false);
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement du thème: $e');
    }
  }

  // Basculer entre mode clair et sombre
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final box = await Hive.openBox('preferences');
      await box.put(_themeKey, _isDarkMode);
    } catch (e) {
      print('Erreur lors de la sauvegarde du thème: $e');
    }
  }

  // Définir le thème manuellement
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;
    
    _isDarkMode = isDark;
    notifyListeners();
    
    try {
      final box = await Hive.openBox('preferences');
      await box.put(_themeKey, _isDarkMode);
    } catch (e) {
      print('Erreur lors de la sauvegarde du thème: $e');
    }
  }
}