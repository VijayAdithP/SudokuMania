import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_stats.dart';

class FirebaseService {
  static Future<void> syncStats(String userId, UserStats stats) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'gamesStarted': stats.gamesStarted,
      'gamesWon': stats.gamesWon,
      'winRate': stats.winRate,
      'bestTime': stats.bestTime,
      'avgTime': stats.avgTime,
      'currentWinStreak': stats.currentWinStreak,
      'longestWinStreak': stats.longestWinStreak,
      'totalPoints': stats.totalPoints,
    }, SetOptions(merge: true));
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
