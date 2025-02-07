import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_stats.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sync player stats and update leaderboard
  static Future<void> updatePlayerStats(
      String userId, String username, UserStats stats) async {
    DocumentReference userRef = _db.collection('users').doc(userId);

    await userRef.set({
      'username': username,
      'gamesStarted': stats.gamesStarted,
      'gamesWon': stats.gamesWon,
      'winRate': stats.winRate,
      'bestTime': stats.bestTime,
      'avgTime': stats.avgTime,
      'currentWinStreak': stats.currentWinStreak,
      'longestWinStreak': stats.longestWinStreak,
      'totalPoints': stats.totalPoints,
      'leaderboard': {
        'easy': {'points': stats.easyPoints},
        'medium': {'points': stats.mediumPoints},
        'hard': {'points': stats.hardPoints},
        'expert': {'points': stats.expertPoints},
        'nightmare': {'points': stats.nightmarePoints},
      },
    }, SetOptions(merge: true));

    // Update overall and difficulty-based leaderboards
    await _updateLeaderboards(userId, username, stats);
  }

  /// ✅ Fetch username with better error handling
  static Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return (snapshot.data() as Map<String, dynamic>)['username'];
      }
    } catch (e) {
      log("❌ Error fetching username: $e");
    }
    return null;
  }

  /// Update global and difficulty-based leaderboards
  static Future<void> _updateLeaderboards(
      String userId, String username, UserStats stats) async {
    await _updateLeaderboard('overall', userId, username, stats.totalPoints);
    await _updateLeaderboard('easy', userId, username, stats.easyPoints);
    await _updateLeaderboard('medium', userId, username, stats.mediumPoints);
    await _updateLeaderboard('hard', userId, username, stats.hardPoints);
    await _updateLeaderboard('expert', userId, username, stats.expertPoints);
    await _updateLeaderboard(
        'nightmare', userId, username, stats.nightmarePoints);
  }

  /// Helper method to update a specific leaderboard
  static Future<void> _updateLeaderboard(
      String difficulty, String userId, String username, int points) async {
    DocumentReference leaderboardRef =
        _db.collection('leaderboards').doc(difficulty);

    await leaderboardRef.set({
      'players': FieldValue.arrayUnion([
        {'userId': userId, 'username': username, 'points': points}
      ])
    }, SetOptions(merge: true));
  }

  /// Fetch leaderboard data (sorted by points)
  static Future<List<Map<String, dynamic>>> getLeaderboard(
      String difficulty) async {
    DocumentSnapshot snapshot =
        await _db.collection('leaderboards').doc(difficulty).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      List<dynamic> players =
          (snapshot.data() as Map<String, dynamic>)['players'] ?? [];
      players
          .sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
      return players.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// ✅ Fetch user stats from Firebase efficiently
  static Future<UserStats?> fetchUserStats(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return UserStats(
          gamesStarted: data['gamesStarted'] ?? 0,
          gamesWon: data['gamesWon'] ?? 0,
          winRate: (data['winRate'] ?? 0).toDouble(),
          bestTime: data['bestTime'] ?? 0,
          avgTime: data['avgTime'] ?? 0,
          currentWinStreak: data['currentWinStreak'] ?? 0,
          longestWinStreak: data['longestWinStreak'] ?? 0,
          totalPoints: data['totalPoints'] ?? 0,
          easyPoints: data['leaderboard']?['easy']?['points'] ?? 0,
          mediumPoints: data['leaderboard']?['medium']?['points'] ?? 0,
          hardPoints: data['leaderboard']?['hard']?['points'] ?? 0,
          expertPoints: data['leaderboard']?['expert']?['points'] ?? 0,
          nightmarePoints: data['leaderboard']?['nightmare']?['points'] ?? 0,
        );
      }
    } catch (e) {
      log("❌ Error fetching user stats: $e");
    }
    return null;
  }

  /// Real-time leaderboard listener
  static Stream<List<Map<String, dynamic>>> leaderboardStream(
      String difficulty) {
    return _db
        .collection('leaderboards')
        .doc(difficulty)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        List<dynamic> players =
            (snapshot.data() as Map<String, dynamic>)['players'] ?? [];
        players
            .sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
        return players.cast<Map<String, dynamic>>();
      }
      return [];
    });
  }
}
