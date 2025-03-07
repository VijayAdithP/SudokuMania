import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/models/daily_challenge_progress.dart';
import 'package:sudokumania/models/user_cred.dart';
import 'package:sudokumania/models/user_stats.dart';
import '../models/game_progress.dart';

class HiveService {
  static const String _gameBox = 'sudokuGame';
  static const String _historyBox = 'gameHistory';
  static const String _statsBox = 'userStats';
  static const String _userBox = 'userData';
  static const String _userCredBox = 'userCred';
  static const String _offlineSyncBox = 'offlineSync';
  static const String _dailyChallengeBox = 'dailyChallengeBox';

  /// Save the current game state (for "Continue" button)
  static Future<void> saveGame(GameProgress game) async {
    var box = await Hive.openBox<GameProgress>(_gameBox);
    await box.put('currentGame', game);
    // log("✅ Game saved");
  }

  /// Load the last saved game
  // static Future<GameProgress?> loadGame() async {
  //   var box = await Hive.openBox<GameProgress>(_gameBox);
  //   log("✅ Game loaded");
  //   return box.get('currentGame');
  // }

  static Future<GameProgress?> loadGame() async {
    try {
      var box = await Hive.openBox<GameProgress>(_gameBox);
      var game = box.get('currentGame');

      if (game != null) {
        // log("✅ Game loaded with elapsed time: ${game.elapsedTime}");
        return game;
      } else {
        // log("⚠️ No saved game found");
        return null;
      }
    } catch (e) {
      // log("❌ Error loading game: $e");
      // Return null on error or consider returning a default game
      return null;
    }
  }

  /// Save user statistics to Hive
  static Future<void> saveUserStats(UserStats stats) async {
    // log("✅ User stats saved to Hive");
    var box = await Hive.openBox<UserStats>(_statsBox);
    await box.put('stats', stats);
  }

  /// 🔹 Save user ID to Hive (for Firebase syncing)
  static Future<void> saveUserId(String userId) async {
    var box = await Hive.openBox<String>(_userBox);
    await box.put('userId', userId);
    // log("✅ User ID saved: $userId");
  }

  static Future<void> saveUserCredentials(UserCred user) async {
    var box = await Hive.openBox<UserCred>(_userCredBox);
    await box.put('userCred', user);
    // log("✅ User ID saved: $userId");
  }

  /// 🔹 Retrieve user ID from Hive
  static Future<String?> getUserId() async {
    // log("🗑️ Getting Offline UserId");
    var box = await Hive.openBox<String>(_userBox);
    return box.get('userId');
  }

  static Future<UserCred?> getUserCred() async {
    // log("🗑️ Getting Offline UserId");
    var box = await Hive.openBox<UserCred>(_userCredBox);
    return box.get('userCred');
  }

  /// 🔹 Clear offline sync queue
  static Future<void> clearOfflineSyncQueue() async {
    // log("🗑️ Offline sync queue cleared");
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
    // log("📂 queueOfflineSync() called"); // ✅ Debug log

    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    await box.put('pendingSync', stats);
    // log("📂 User stats queued for sync when online");
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
    // log("📂 Game added to history");
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

  static Future<bool> clearSavedGame() async {
    try {
      // log("🔍 Attempting to clear saved game...");
      var box = await Hive.openBox<GameProgress>(_gameBox);

      // Check if the key exists before trying to delete
      if (box.containsKey('currentGame')) {
        await box.delete('currentGame');
        await box.delete('currentGame');
        // log("🗑️ Saved game cleared successfully");
      } else {
        // log("⚠️ No saved game found to clear");
      }

      // Close the box to ensure changes are saved
      // await box.close();
      return true;
    } catch (e) {
      // log("❌ Error clearing saved game: $e");
      return false;
    }
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
    // log("✅ Username saved: $username");
  }

  /// 🔹 Retrieve username from Hive
  static Future<String?> getUsername() async {
    var box = await Hive.openBox<String>(_userBox);
    return box.get('username');
  }

  static Future<void> init() async {
    await Hive.openBox<DailyChallengeProgress>(_dailyChallengeBox);
  }

  static Future<void> saveDailyChallengeProgress(
      DailyChallengeProgress progress) async {
    var box = await Hive.openBox<DailyChallengeProgress>(_dailyChallengeBox);
    final test = await box.put('progress', progress);
  }

  static Future<DailyChallengeProgress?> loadDailyChallengeProgress() async {
    var box = await Hive.openBox<DailyChallengeProgress>(_dailyChallengeBox);
    return box.get('progress');
  }
}
