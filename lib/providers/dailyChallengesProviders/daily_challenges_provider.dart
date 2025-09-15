import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/dailyChallenges%20Models/daily_challenge_progress.dart';
import 'package:sudokumania/service/hive_service.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

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

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Future<void> completeChallenge(DateTime date, double score) async {
  //   final updatedDays = Map<DateTime, bool>.from(state.completedDays);
  //   final normalizedDate = normalizeDate(date);
  //   updatedDays[normalizedDate] = true;

  //   final newMultiplier = state.multiplier + 0.5;
  //   final newCompletedCount = state.completedCount + 1;

  //   state = state.copyWith(
  //     completedDays: updatedDays,
  //     multiplier: newMultiplier,
  //     completedCount: newCompletedCount,
  //   );
  //   await HiveService.saveDailyChallengeProgress(state);
  // }
  Future<void> completeChallenge(DateTime date, double score) async {
    final updatedDays = Map<DateTime, bool>.from(state.completedDays);
    final normalizedDate = normalizeDate(date); // Normalize the date

    log("Completing challenge for date: $normalizedDate"); // Log the date being added

    // Mark the day as completed
    updatedDays[normalizedDate] = true;

    log("Updated completedDays: $updatedDays"); // Log the updated map

    // Update the state
    state = state.copyWith(
      completedDays: updatedDays,
      multiplier: state.multiplier + 0.5,
      completedCount: state.completedCount + 1,
    );

    // Save the updated progress to Hive
    await HiveService.saveDailyChallengeProgress(state);
    log("Saved progress to Hive: ${state.completedDays}"); // Log the saved progress
  }
}
