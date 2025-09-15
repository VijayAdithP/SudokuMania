import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/service/hive_service.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemePreference>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemePreference> {
  ThemeNotifier() : super(ThemePreference.dark) {
    HiveService.loadTheme();
    _loadTheme();
  }

  // Load the saved theme from Hive
  void _loadTheme() {
    final themeBox = Hive.box<ThemePreference>('themeBox');
    state = themeBox.get('theme', defaultValue: ThemePreference.dark)!;
  }

  int? a;

  // Toggle between light and dark themes
  void toggleTheme(ThemePreference themePreference) {
    state = themePreference; // Set the theme to the provided preference
    _saveTheme();
  }

  // Save the selected theme to Hive
  void _saveTheme() {
    final themeBox = Hive.box<ThemePreference>('themeBox');
    themeBox.put('theme', state);
  }
}
