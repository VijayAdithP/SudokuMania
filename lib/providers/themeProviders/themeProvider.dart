import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemePreference>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemePreference> {
  ThemeNotifier() : super(ThemePreference.dark) {
    _loadTheme();
  }

  // Load the saved theme from Hive
  void _loadTheme() {
    final themeBox = Hive.box<ThemePreference>('themeBox');
    state = themeBox.get('theme', defaultValue: ThemePreference.dark)!;
  }

  int? a; 

  // Toggle between light and dark themes
  void toggleTheme() {
    state = state == ThemePreference.light
        ? ThemePreference.dark
        : ThemePreference.light;
    _saveTheme();
  }

  // Save the selected theme to Hive
  void _saveTheme() {
    final themeBox = Hive.box<ThemePreference>('themeBox');
    themeBox.put('theme', state);
  }
}
