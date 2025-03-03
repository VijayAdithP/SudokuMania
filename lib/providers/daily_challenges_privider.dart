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
  }

  Future<void> completeChallenge(DateTime date, double score) async {
    final updatedDays = Map<DateTime, bool>.from(state.completedDays);
    updatedDays[date] = true;

    final newMultiplier = state.multiplier + 0.5;
    final newCompletedCount = state.completedCount + 1;

    state = state.copyWith(
      completedDays: updatedDays,
      multiplier: newMultiplier,
      completedCount: newCompletedCount,
    );

    await HiveService.saveDailyChallengeProgress(state);
  }
}
