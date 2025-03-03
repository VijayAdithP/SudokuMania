import 'package:hive_ce_flutter/hive_flutter.dart';

part 'daily_challenge_progress.g.dart';

@HiveType(typeId: 2)
class DailyChallengeProgress {
  @HiveField(0)
  final Map<DateTime, bool> completedDays; // Maps date to completion status

  @HiveField(1)
  final double multiplier; // Current multiplier

  @HiveField(2)
  final int completedCount; // Number of challenges completed this month

  DailyChallengeProgress({
    required this.completedDays,
    this.multiplier = 1.0,
    this.completedCount = 0,
  });

  DailyChallengeProgress copyWith({
    Map<DateTime, bool>? completedDays,
    double? multiplier,
    int? completedCount,
  }) {
    return DailyChallengeProgress(
      completedDays: completedDays ?? this.completedDays,
      multiplier: multiplier ?? this.multiplier,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}
