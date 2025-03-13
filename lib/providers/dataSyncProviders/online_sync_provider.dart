// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sudokumania/models/user_stats.dart';
// import 'package:sudokumania/providers/auth_provider.dart';
// import 'package:sudokumania/providers/game_state_provider.dart';
// import 'package:sudokumania/providers/network_provider.dart';
// import 'package:sudokumania/service/firebase_service.dart';
// import '../service/hive_service.dart';

// /// 🔹 Monitors network status and triggers sync when online
// final onlineSyncProvider = Provider.autoDispose<void>((ref) async {
//   final authState = ref.watch(authProvider);
//   ref.listen(networkStatusProvider, (previous, next) async {
//     if (next == ConnectivityResult.mobile || next == ConnectivityResult.wifi) {
//       String? userId = await HiveService.getUserId();
//       String? username = await HiveService.getUsername();

//       if (userId != null && username != null) {
//         // push data to the firebase cloud
//         await HiveService.saveUsername(authState.user!.displayName!);
//         UserStats? userdata = await HiveService.loadUserStats();
//         await FirebaseService.updatePlayerStats(
//             authState.user!.email!, authState.user!.displayName!, userdata!);
//         // ✅ Avoid duplicate syncs by checking pending data
//         UserStats? pendingStats = await HiveService.getOfflineSyncData();
//         if (pendingStats != null) {
//           await ref
//               .read(statsProvider.notifier)
//               .syncOfflineData(userId, username);
//           await HiveService.clearOfflineSyncQueue();
//         }
//       }
//     }
//   });
// });
