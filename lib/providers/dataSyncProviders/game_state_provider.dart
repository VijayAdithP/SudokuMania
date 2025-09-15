// import 'dart:developer';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/user_stats.dart';
// import '../service/hive_service.dart';
// import '../service/firebase_service.dart';

// class StatsNotifier extends StateNotifier<UserStats> {
//   StatsNotifier() : super(UserStats()) {
//     _loadStats();
//   }

//   /// Update stats when a game starts
//   void incrementGamesStarted(String difficulty) {
//     state = state.copyWith(
//       gamesStarted: state.gamesStarted + 1,
//     );
//     _saveStats();
//   }

//   /// 🔹 Update stats when a game is completed
//   void updateGameStats(bool won, String difficulty, int time, String userId,
//       String username, bool isOnline) async {
//     int newPoints = _calculatePoints(difficulty, won);
//     // log("🛠 updateGameStats() called - isOnline: $isOnline"); // ✅ Debug log
//     if (won && state.gamesWon == state.gamesWon + 1) return;

//     state = state.copyWith(
//       gamesStarted: state.gamesStarted + 1,
//       gamesWon: won ? state.gamesWon + 1 : state.gamesWon,
//       totalPoints: state.totalPoints + newPoints,
//       easyPoints: difficulty == "easy"
//           ? state.easyPoints + newPoints
//           : state.easyPoints,
//       mediumPoints: difficulty == "medium"
//           ? state.mediumPoints + newPoints
//           : state.mediumPoints,
//       hardPoints: difficulty == "hard"
//           ? state.hardPoints + newPoints
//           : state.hardPoints,
//       expertPoints: difficulty == "expert"
//           ? state.expertPoints + newPoints
//           : state.expertPoints,
//       nightmarePoints: difficulty == "nightmare"
//           ? state.nightmarePoints + newPoints
//           : state.nightmarePoints,
//     );

//     _saveStats();

//     if (isOnline) {
//       // log("📡 Syncing stats online"); // ✅ Debug log

//       await FirebaseService.updatePlayerStats(userId, username, state);
//     } else {
//       // log("📂 Saving stats offline for later sync"); // ✅ Debug log

//       await HiveService.queueOfflineSync(state);
//     }
//   }

//   /// Calculate points based on difficulty
//   int _calculatePoints(String difficulty, bool won) {
//     if (!won) return 0;
//     switch (difficulty) {
//       case "easy":
//         return 50;
//       case "medium":
//         return 100;
//       case "hard":
//         return 200;
//       case "expert":
//         return 400;
//       case "nightmare":
//         return 800;
//       default:
//         return 0;
//     }
//   }

//   /// Load stats from Hive
//   void _loadStats() async {
//     UserStats? savedStats = await HiveService.loadUserStats();
//     if (savedStats != null) {
//       state = savedStats;
//     }
//   }

//   /// Save stats to Hive
//   void _saveStats() {
//     // log("✅ User stats saved to Hive"); // ✅ Debug log

//     HiveService.saveUserStats(state);
//   }

//   /// 🔹 Sync offline data when back online
//   Future<void> syncOfflineData(String userId, String username) async {
//     UserStats? offlineStats = await HiveService.getOfflineSyncData();
//     if (offlineStats != null) {
//       await FirebaseService.updatePlayerStats(userId, username, offlineStats);
//       await HiveService.clearOfflineSyncQueue();
//     }
//   }
// }

// final statsProvider = StateNotifierProvider<StatsNotifier, UserStats>((ref) {
//   return StatsNotifier();
// });
