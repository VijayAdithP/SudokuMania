import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/userStats Models/user_stats.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sync player stats and update leaderboard
  static Future<void> updatePlayerStats(
      String userId, String username, UserStats stats) async {
    DocumentReference userRef = _db.collection('users').doc(userId);

    final List<int?> bestTimes = [
      stats.bestTime,
      stats.easyBestTime,
      stats.mediumBestTime,
      stats.hardBestTime,
      stats.nightmareBestTime,
    ];
    final validTimes =
        bestTimes.where((time) => time != null && time > 0).toList();
    int? minTime = 0;
    if (validTimes.isNotEmpty) {
      minTime = validTimes.reduce((a, b) => a! < b! ? a : b);
    }

    await userRef.set({
      'username': username,
      'gamesStarted': stats.gamesStarted,
      'gamesWon': stats.gamesWon,
      'winRate': stats.winRate,
      'bestTime': minTime,
      'avgTime': stats.avgTime,
      'currentWinStreak': stats.currentWinStreak,
      'longestWinStreak': stats.longestWinStreak,
      'totalPoints': stats.totalPoints,
      //easy game data sync
      'easygamesStarted': stats.easyGamesStarted,
      'easygamesWon': stats.easyGamesWon,
      'easyWinRate': stats.easyWinRate,
      'easyBestTime': stats.easyBestTime,
      'easyAvgTime': stats.easyAvgTime,
      //medium game data sync
      'mediumgamesStarted': stats.mediumGamesStarted,
      'mediumgamesWon': stats.mediumGamesWon,
      'mediumWinRate': stats.mediumWinRate,
      'mediumBestTime': stats.mediumBestTime,
      'mediumAvgTime': stats.mediumAvgTime,
      //hard game data sync
      'hardgamesStarted': stats.hardGamesStarted,
      'hardgamesWon': stats.hardGamesWon,
      'hardWinRate': stats.hardWinRate,
      'hardBestTime': stats.hardBestTime,
      'hardAvgTime': stats.hardAvgTime,
      //nightmare game data sync
      'nightmaregamesStarted': stats.nightmareGamesStarted,
      'nightmaregamesWon': stats.nightmareGamesWon,
      'nightmareWinRate': stats.nightmareWinRate,
      'nightmareBestTime': stats.nightmareBestTime,
      'nightmareAvgTime': stats.nightmareAvgTime,
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

  static Future<void> _updateLeaderboard(
      String difficulty, String userId, String username, int points) async {
    final DocumentReference leaderboardRef =
        _db.collection('leaderboards').doc(difficulty);

    // Fetch the current leaderboard data
    final DocumentSnapshot leaderboardSnapshot = await leaderboardRef.get();
    final Map<String, dynamic>? leaderboardData =
        leaderboardSnapshot.data() as Map<String, dynamic>?;

    if (leaderboardData != null && leaderboardData.containsKey('players')) {
      // Get the current players array
      final List<dynamic> players = leaderboardData['players'];

      // Check if the user already exists in the players array
      final int userIndex = players.indexWhere(
        (player) => player['userId'] == userId,
      );

      if (userIndex != -1) {
        // If the user exists, replace their points with the new value
        final Map<String, dynamic> userData =
            Map<String, dynamic>.from(players[userIndex]);
        userData['points'] = points; // Replace points with the new value
        players[userIndex] = userData;
      } else {
        // If the user does not exist, add them to the array with the new points
        players.add({
          'userId': userId,
          'username': username,
          'points': points,
        });
      }

      // Save the updated players array back to Firestore
      await leaderboardRef.update({'players': players});
    } else {
      // If the leaderboard document or players array does not exist, create it
      await leaderboardRef.set({
        'players': [
          {'userId': userId, 'username': username, 'points': points}
        ]
      });
    }
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
          easyGamesStarted: data['easygamesStarted'] ?? 0,
          easyGamesWon: data['easygamesWon'] ?? 0,
          easyWinRate: (data['easyWinRate'] ?? 0).toDouble(),
          easyBestTime: data['easyBestTime'] ?? 0,
          easyAvgTime: data['easyAvgTime'] ?? 0,
          mediumGamesStarted: data['mediumgamesStarted'] ?? 0,
          mediumGamesWon: data['mediumgamesWon'] ?? 0,
          mediumWinRate: (data['mediumWinRate'] ?? 0).toDouble(),
          mediumBestTime: data['mediumBestTime'] ?? 0,
          mediumAvgTime: data['mediumAvgTime'] ?? 0,
          hardGamesStarted: data['hardgamesStarted'] ?? 0,
          hardGamesWon: data['hardgamesWon'] ?? 0,
          hardWinRate: (data['hardWinRate'] ?? 0).toDouble(),
          hardBestTime: data['hardBestTime'] ?? 0,
          hardAvgTime: data['hardAvgTime'] ?? 0,
          nightmareGamesStarted: data['nightmaregamesStarted'] ?? 0,
          nightmareGamesWon: data['nightmaregamesWon'] ?? 0,
          nightmareWinRate: (data['nightmareWinRate'] ?? 0).toDouble(),
          nightmareBestTime: data['nightmareBestTime'] ?? 0,
          nightmareAvgTime: data['nightmareAvgTime'] ?? 0,
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

  static Future<void> clearUserStatData(String userId, String username) async {
    DocumentReference userRef = _db.collection('users').doc(userId);
    await userRef.set({
      'username': username,
      'gamesStarted': 0,
      'gamesWon': 0,
      'winRate': 0,
      'bestTime': 0,
      'avgTime': 0,
      'currentWinStreak': 0,
      'longestWinStreak': 0,
      'totalPoints': 0,
      //easy,
      'easygamesStarted': 0,
      'easygamesWon': 0,
      'easyWinRate': 0,
      'easyBestTime': 0,
      'easyAvgTime': 0,
      //medium,
      'mediumgamesStarted': 0,
      'mediumgamesWon': 0,
      'mediumWinRate': 0,
      'mediumBestTime': 0,
      'mediumAvgTime': 0,
      //hard ,
      'hardgamesStarted': 0,
      'hardgamesWon': 0,
      'hardWinRate': 0,
      'hardBestTime': 0,
      'hardAvgTime': 0,
      //nightmare ,
      'nightmaregamesStarted': 0,
      'nightmaregamesWon': 0,
      'nightmareWinRate': 0,
      'nightmareBestTime': 0,
      'nightmareAvgTime': 0,
      'leaderboard': {
        'easy': {'points': 0},
        'medium': {'points': 0},
        'hard': {'points': 0},
        'expert': {'points': 0},
        'nightmare': {'points': 0},
      },
    }, SetOptions(merge: true));

    // Update overall and difficulty-based leaderboards with 0 points
    await _updateLeaderboards(
        userId,
        username,
        UserStats(
          totalPoints: 0,
          easyPoints: 0,
          mediumPoints: 0,
          hardPoints: 0,
          expertPoints: 0,
          nightmarePoints: 0,
        ));
  }
}
