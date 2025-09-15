import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import '../../service/firebase_service.dart';
import '../../service/hive_service.dart';
import '../../models/userStats Models/user_stats.dart';

/// 🔹 Provider to handle background sync at app launch
final appStartupProvider = FutureProvider<void>((ref) async {
  UserCred? userCred = await HiveService.getUserCred();
  String? userId = userCred!.displayName;

  if (userId == null) return;

  UserStats? cloudStats = await FirebaseService.fetchUserStats(userId);
  if (cloudStats != null) {
    await HiveService.saveUserStats(cloudStats); // Sync with local storage
  }
});
