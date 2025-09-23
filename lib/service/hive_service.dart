import 'dart:developer';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/models/dailyChallenges%20Models/daily_challenge_progress.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import '../models/gameProgress Models/game_progress.dart';

class HiveService {
  static const String _gameBox = 'sudokuGame';
  static const String _historyBox = 'gameHistory';
  static const String _statsBox = 'userStats';
  static const String _userBox = 'userData';
  static const String _userCredBox = 'userCred';
  static const String _offlineSyncBox = 'offlineSync';
  static const String _dailyChallengeBox = 'dailyChallengeBox';
  static const String _notificationBox = 'notificationBox';

  static Future<void> saveNotificationPreference(bool isEnabled) async {
    var box = await Hive.openBox<bool>(_notificationBox);
    await box.put('isEnabled', isEnabled);
  }

  static Future<bool> getNotificationPreference() async {
    var box = await Hive.openBox<bool>(_notificationBox);
    return box.get('isEnabled', defaultValue: false) ?? false;
  }

  /// Save the current game state (for "Continue" button)
  static Future<void> saveGame(GameProgress game) async {
    var box = await Hive.openBox<GameProgress>(_gameBox);
    await box.put('currentGame', game);
  }

  /// Load the last saved game
  // static Future<GameProgress?> loadGame() async {
  //   var box = await Hive.openBox<GameProgress>(_gameBox);
  //   return box.get('currentGame');
  // }

  static Future<GameProgress?> loadGame() async {
    try {
      var box = await Hive.openBox<GameProgress>(_gameBox);
      var game = box.get('currentGame');

      if (game != null) {
        return game;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Save user statistics to Hive
  static Future<void> saveUserStats(UserStats stats) async {
    var box = await Hive.openBox<UserStats>(_statsBox);
    await box.put('stats', stats);
  }

  ///Save user ID to Hive (for Firebase syncing)
  static Future<void> saveUserId(String userId) async {
    var box = await Hive.openBox<String>(_userBox);
    await box.put('userId', userId);
  }

  static Future<void> saveUserCredentials(UserCred user) async {
    var box = await Hive.openBox<UserCred>(_userCredBox);
    await box.put('userCredentials', user);
  }

  //Retrieve user ID from Hive
  static Future<String?> getUserId() async {
    var box = await Hive.openBox<String>(_userBox);
    return box.get('userId');
  }

  // static Future<UserCred?> getUserCred() async {
  //   var box = await Hive.openBox<UserCred>(_userCredBox);
  //   return box.get('userCredentials');
  // }

  static Future<UserCred?> getUserCred() async {
    if (!Hive.isBoxOpen(_gameBox)) {
      await Hive.initFlutter();
    }
    var box = await Hive.openBox<UserCred>(_userCredBox);
    return box.get('userCredentials');
  }

  ///Clear offline sync queue
  static Future<void> clearOfflineSyncQueue() async {
    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    await box.delete('pendingSync');
  }

  /// Retrieve queued stats for sync
  static Future<UserStats?> getOfflineSyncData() async {
    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    return box.get('pendingSync');
  }

  /// Save stats for offline sync
  static Future<void> queueOfflineSync(UserStats stats) async {

    var box = await Hive.openBox<UserStats>(_offlineSyncBox);
    await box.put('pendingSync', stats);
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
      var box = await Hive.openBox<GameProgress>(_gameBox);

      // Check if the key exists before trying to delete
      if (box.containsKey('currentGame')) {
        await box.delete('currentGame');
        await box.delete('currentGame');
      }
      return true;
    } catch (e) {
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
  }

  /// 🔹 Retrieve username from Hive
  static Future<String?> getUsername() async {
    var box = await Hive.openBox<String>(_userBox);
    return box.get('username');
  }

  static Future<void> saveDailyChallengeProgress(
      DailyChallengeProgress progress) async {
    var box = await Hive.openBox<DailyChallengeProgress>(_dailyChallengeBox);
    await box.put('progress', progress);
    log("Saved progress to Hive: ${progress.completedDays}"); // Log the saved progress
  }

  static Future<DailyChallengeProgress?> loadDailyChallengeProgress() async {
    var box = await Hive.openBox<DailyChallengeProgress>(_dailyChallengeBox);
    final progress = box.get('progress');
    log("Loaded progress from Hive: ${progress?.completedDays}"); // Log the loaded progress
    return progress;
  }

  static Future<ThemePreference?> loadTheme() async {
    await Hive.openBox<ThemePreference>('themeBox');
    return null;
  }
}
