import 'dart:developer';

import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

import '../models/game_progress.dart';

class HiveService {
  static const String _gameBox = 'sudokuGame';
  static const String _historyBox = 'gameHistory';

  /// Save the current game state (for "Continue" button)
  static Future<void> saveGame(GameProgress game) async {
    var box = await Hive.openBox<GameProgress>(_gameBox);
    await box.put('currentGame', game);
    log("✅ Game saved");
  }

  /// Load the last saved game
  static Future<GameProgress?> loadGame() async {
    var box = await Hive.openBox<GameProgress>(_gameBox);
    return box.get('currentGame');
  }

  /// Save completed games to history
  static Future<void> saveToHistory(GameProgress game) async {
    var box = await Hive.openBox<GameProgress>(_historyBox);
    await box.add(game); // Adds a new entry
    log("📂 Game added to history");
  }

  /// Load all completed games from history
  static Future<List<GameProgress>> loadHistory() async {
    var box = await Hive.openBox<GameProgress>(_historyBox);
    return box.values.toList();
  }

  static Future<Map<String, List<GameProgress>>> loadGroupedHistory() async {
    var box = await Hive.openBox<GameProgress>(_historyBox);
    List<GameProgress> allGames = box.values.toList();

    // Sort games by date (most recent first)
    allGames.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));

    // Group by formatted date
    Map<String, List<GameProgress>> groupedHistory = {};
    for (var game in allGames) {
      String formattedDate = _formatDate(game.lastPlayed);
      groupedHistory.putIfAbsent(formattedDate, () => []).add(game);
    }

    return groupedHistory;
  }

  /// Clear current saved game (when a new one starts)
  static Future<void> clearSavedGame() async {
    var box = await Hive.openBox<GameProgress>(_gameBox);
    await box.delete('currentGame');
    log("🗑️ Saved game cleared");
  }

  /// Format date as "Today", "Yesterday", or "MMM dd, yyyy"
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat('MMM dd, yyyy').format(date);
  }

  
}
