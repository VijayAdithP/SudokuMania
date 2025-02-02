import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_stats.dart';
import '../service/hive_service.dart';
import '../service/firebase_service.dart';

class StatsNotifier extends StateNotifier<UserStats> {
  StatsNotifier() : super(UserStats()) {
    _loadStats();
  }



  /// Update stats when a game starts
  void incrementGamesStarted(String difficulty) {
    state = state.copyWith(
      gamesStarted: state.gamesStarted + 1,
    );
    _saveStats();
  }

  /// Update stats when a game is completed
  void updateGameStats(bool won, String difficulty, int time) {
    int newGamesWon = won ? state.gamesWon + 1 : state.gamesWon;
    int newStreak = won ? state.currentWinStreak + 1 : 0;
    int newLongestStreak =
        newStreak > state.longestWinStreak ? newStreak : state.longestWinStreak;

    state = state.copyWith(
      gamesWon: newGamesWon,
      winRate: (newGamesWon / state.gamesStarted) * 100,
      bestTime: (state.bestTime == 0 || time < state.bestTime)
          ? time
          : state.bestTime,
      avgTime:
          ((state.avgTime * (state.gamesWon - 1)) + time) ~/ state.gamesWon,
      currentWinStreak: newStreak,
      longestWinStreak: newLongestStreak,
    );

    _saveStats();
  }

  /// Load stats from Hive
  void _loadStats() async {
    UserStats? savedStats = await HiveService.loadUserStats();
    if (savedStats != null) {
      state = savedStats;
    }
  }

  

  /// Save stats to Hive
  void _saveStats() {
    HiveService.saveUserStats(state);
  }

  /// Sync stats to Firebase
  Future<void> syncToFirebase(String userId) async {
    await FirebaseService.syncStats(userId, state);
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, UserStats>((ref) {
  return StatsNotifier();
});
