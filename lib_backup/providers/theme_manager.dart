import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  String _selectedTheme = 'purple';
  static const String _themeKey = 'app_theme';
  
  String get selectedTheme => _selectedTheme;
  
  ThemeManager() {
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedTheme = prefs.getString(_themeKey) ?? 'purple';
    notifyListeners();
  }
  
  Future<void> setTheme(String theme) async {
    _selectedTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
    notifyListeners();
  }
  
  // Theme colors for each scheme
  Color get primaryColor {
    switch (_selectedTheme) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'emerald':
        return const Color(0xFF00B4D8);
      case 'purple':
        return const Color(0xFF6C63FF);
      case 'ocean':
        return const Color(0xFF3498DB);
      case 'crimson':
        return const Color(0xFFE74C3C);
      case 'amber':
        return const Color(0xFFFFB74D);
      default:
        return const Color(0xFF6C63FF);
    }
  }
  
  String get themeName {
    switch (_selectedTheme) {
      case 'gold':
        return 'Royal Gold';
      case 'emerald':
        return 'Emerald Green';
      case 'purple':
        return 'Royal Purple';
      case 'ocean':
        return 'Ocean Blue';
      case 'crimson':
        return 'Crimson Red';
      case 'amber':
        return 'Sunset Amber';
      default:
        return 'Royal Purple';
    }
  }
  
  List<Map<String, dynamic>> getAvailableThemes() {
    return [
      {
        'id': 'purple',
        'name': 'Royal Purple',
        'color': const Color(0xFF6C63FF),
        'icon': Icons.color_lens,
        'description': 'Elegant and modern',
      },
      {
        'id': 'gold',
        'name': 'Royal Gold',
        'color': const Color(0xFFFFD700),
        'icon': Icons.workspace_premium,
        'description': 'Luxury and premium',
      },
      {
        'id': 'emerald',
        'name': 'Emerald Green',
        'color': const Color(0xFF00B4D8),
        'icon': Icons.eco,
        'description': 'Wealth and growth',
      },
      {
        'id': 'ocean',
        'name': 'Ocean Blue',
        'color': const Color(0xFF3498DB),
        'icon': Icons.water_drop,
        'description': 'Trust and peace',
      },
      {
        'id': 'crimson',
        'name': 'Crimson Red',
        'color': const Color(0xFFE74C3C),
        'icon': Icons.favorite,
        'description': 'Bold and passionate',
      },
      {
        'id': 'amber',
        'name': 'Sunset Amber',
        'color': const Color(0xFFFFB74D),
        'icon': Icons.wb_sunny,
        'description': 'Warm and cozy',
      },
    ];
  }
}
