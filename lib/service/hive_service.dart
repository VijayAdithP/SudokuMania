import 'dart:developer';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/models/user_stats.dart';
import '../models/game_progress.dart';

class HiveService {
  static const String _gameBox = 'sudokuGame';
  static const String _historyBox = 'gameHistory';
  static const String _statsBox = 'userStats';
  static const String _userBox = 'userData';
  static const String _offlineSyncBox = 'offlineSync';

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

  /// Save user statistics to Hive
  static Future<void> saveUserStats(UserStats stats) async {
    log("✅ User stats saved to Hive");
    var box = await Hive.openBox<UserStats>(_statsBox);
    await box.put('stats', stats);
  }

  /// 🔹 Save user ID to Hive (for Firebase syncing)
  static Future<void> saveUserId(String userId) async {
    var box = await Hive.openBox<String>(_userBox);
    await box.put('userId', userId);
    log("✅ User ID saved: $userId");
  }

  /// 🔹 Retrieve user ID from Hive
  static Future<String?> getUserId() async {
    log("🗑️ Getting Offline UserId");
    var box = await Hive.openBox<String>(_userBox);
    return box.get('userId');
  }

  /// 🔹 Clear offline sync queue
  static Future<void> clearOfflineSyncQueue() async {
    log("🗑️ Offline sync queue cleared");
    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    await box.delete('pendingSync');
  }

  /// 🔹 Retrieve queued stats for sync
  static Future<UserStats?> getOfflineSyncData() async {
    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    return box.get('pendingSync');
  }

  /// 🔹 Save stats for offline sync
  static Future<void> queueOfflineSync(UserStats stats) async {
    log("📂 queueOfflineSync() called"); // ✅ Debug log

    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    await box.put('pendingSync', stats);
    log("📂 User stats queued for sync when online");
  }

  /// Load user statistics from Hive
  static Future<UserStats?> loadUserStats() async {
    var box = await Hive.openBox<UserStats>(_statsBox);
    return box.get('stats');
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

  static Future<void> saveUsername(String username) async {
    var box = await Hive.openBox<String>(_userBox);
    await box.put('username', username);
    log("✅ Username saved: $username");
  }

  /// 🔹 Retrieve username from Hive
  static Future<String?> getUsername() async {
    var box = await Hive.openBox<String>(_userBox);
    return box.get('username');
  }
}
