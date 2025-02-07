import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/providers/game_state_provider.dart';
import 'package:sudokumania/providers/network_provider.dart';
import '../service/hive_service.dart';
import '../service/firebase_service.dart';

// /// 🔹 Monitors network status and triggers sync when online
// final onlineSyncProvider = Provider.autoDispose<void>((ref) async {
//   ref.listen(networkStatusProvider, (previous, next) async {
//     if (next == ConnectivityResult.mobile || next == ConnectivityResult.wifi) {
//       String? userId = await HiveService.getUserId();
//       String? username = await HiveService.getUsername();

//       // 🔹 If username is not found in Hive, fetch from Firebase
//       if (username == null && userId != null) {
//         username = await FirebaseService.getUsername(userId);
//         if (username != null) {
//           await HiveService.saveUsername(username);
//         }
//       }

//       if (userId != null && username != null) {
//         ref.read(statsProvider.notifier).syncOfflineData(userId, username);
//       }
//     }
//   });
// });

/// 🔹 Monitors network status and triggers sync when online
final onlineSyncProvider = Provider.autoDispose<void>((ref) async {
  ref.listen(networkStatusProvider, (previous, next) async {
    if (next == ConnectivityResult.mobile || next == ConnectivityResult.wifi) {
      String? userId = await HiveService.getUserId();
      String? username = await HiveService.getUsername();

      if (userId != null && username != null) {
        // ✅ Avoid duplicate syncs by checking pending data
        UserStats? pendingStats = await HiveService.getOfflineSyncData();
        if (pendingStats != null) {
          await ref
              .read(statsProvider.notifier)
              .syncOfflineData(userId, username);
          await HiveService.clearOfflineSyncQueue(); // Clear after syncing
        }
      }
    }
  });
});
