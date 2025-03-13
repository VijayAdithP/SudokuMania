import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/firebase_service.dart';

/// 🔹 Provider to fetch leaderboard data based on difficulty
final leaderboardProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, difficulty) {
  return FirebaseService.leaderboardStream(difficulty);
});
