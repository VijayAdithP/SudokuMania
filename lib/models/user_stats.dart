import 'package:hive_ce/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 6)
class UserStats {
  @HiveField(0)
  final int gamesStarted;

  @HiveField(1)
  final int gamesWon;

  @HiveField(2)
  final double winRate;

  @HiveField(3)
  final int bestTime;

  @HiveField(4)
  final int avgTime;

  @HiveField(5)
  final int currentWinStreak;

  @HiveField(6)
  final int longestWinStreak;

  @HiveField(7)
  final int totalPoints;
  @HiveField(8)
  final int easyPoints;
  @HiveField(9)
  final int mediumPoints;
  @HiveField(10)
  final int hardPoints;
  @HiveField(11)
  final int expertPoints;
  @HiveField(12)
  final int nightmarePoints;

  UserStats({
    this.gamesStarted = 0,
    this.gamesWon = 0,
    this.winRate = 0.0,
    this.bestTime = 0,
    this.avgTime = 0,
    this.currentWinStreak = 0,
    this.longestWinStreak = 0,
    this.totalPoints = 0,
    this.easyPoints = 0,
    this.mediumPoints = 0,
    this.hardPoints = 0,
    this.expertPoints = 0,
    this.nightmarePoints = 0,
  });

  /// Creates a copy with updated values
  UserStats copyWith({
    int? gamesStarted,
    int? gamesWon,
    double? winRate,
    int? bestTime,
    int? avgTime,
    int? currentWinStreak,
    int? longestWinStreak,
    int? totalPoints,
    int? easyPoints,
    int? mediumPoints,
    int? hardPoints,
    int? expertPoints,
    int? nightmarePoints,
  }) {
    return UserStats(
      gamesStarted: gamesStarted ?? this.gamesStarted,
      gamesWon: gamesWon ?? this.gamesWon,
      winRate: winRate ?? this.winRate,
      bestTime: bestTime ?? this.bestTime,
      avgTime: avgTime ?? this.avgTime,
      currentWinStreak: currentWinStreak ?? this.currentWinStreak,
      longestWinStreak: longestWinStreak ?? this.longestWinStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      easyPoints: easyPoints ?? this.easyPoints,
      mediumPoints: mediumPoints ?? this.mediumPoints,
      hardPoints: hardPoints ?? this.hardPoints,
      expertPoints: expertPoints ?? this.expertPoints,
      nightmarePoints: nightmarePoints ?? this.nightmarePoints,
    );
  }
}
