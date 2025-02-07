import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/firebase_service.dart';
import '../service/hive_service.dart';
import '../models/user_stats.dart';

/// 🔹 Provider to handle background sync at app launch
final appStartupProvider = FutureProvider<void>((ref) async {
  String? userId = await HiveService.getUserId(); // Fetch stored user ID
  if (userId == null) return;

  UserStats? cloudStats = await FirebaseService.fetchUserStats(userId);
  if (cloudStats != null) {
    await HiveService.saveUserStats(cloudStats); // Sync with local storage
  }
});
