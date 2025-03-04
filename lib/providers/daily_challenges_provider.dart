import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/daily_challenge_progress.dart';
import 'package:sudokumania/service/hive_service.dart';

final dailyChallengeProvider =
    StateNotifierProvider<DailyChallengeNotifier, DailyChallengeProgress>(
        (ref) {
  return DailyChallengeNotifier();
});

class DailyChallengeNotifier extends StateNotifier<DailyChallengeProgress> {
  DailyChallengeNotifier() : super(DailyChallengeProgress(completedDays: {}));

  Future<void> loadProgress() async {
    final progress = await HiveService.loadDailyChallengeProgress();
    if (progress != null) {
      state = progress;
    }
    log("Loaded daily challenge progress: ${state.completedDays}");
  }

  Future<void> completeChallenge(DateTime date, double score) async {
    final updatedDays = Map<DateTime, bool>.from(state.completedDays);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    updatedDays[normalizedDate] = true;

    final newMultiplier = state.multiplier + 0.5;
    final newCompletedCount = state.completedCount + 1;

    state = state.copyWith(
      completedDays: updatedDays,
      multiplier: newMultiplier,
      completedCount: newCompletedCount,
    );
    // log("Marking date as completed: $date");
    // log("Updated completedDays: ${state.completedDays}");
    await HiveService.saveDailyChallengeProgress(state);
  }
}
