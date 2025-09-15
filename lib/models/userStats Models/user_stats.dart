// import 'package:hive_ce/hive.dart';

// part 'user_stats.g.dart';

// @HiveType(typeId: 6)
// class UserStats {
//   @HiveField(0)
//   final int gamesStarted;

//   @HiveField(1)
//   final int gamesWon;

//   @HiveField(2)
//   final double winRate;

//   @HiveField(3)
//   final int bestTime;

//   @HiveField(4)
//   final int avgTime;

//   @HiveField(5)
//   final int currentWinStreak;

//   @HiveField(6)
//   final int longestWinStreak;

//   @HiveField(7)
//   final int totalPoints;
//   @HiveField(8)
//   final int easyPoints;
//   @HiveField(9)
//   final int mediumPoints;
//   @HiveField(10)
//   final int hardPoints;
//   @HiveField(11)
//   final int expertPoints;
//   @HiveField(12)
//   final int nightmarePoints;

//   UserStats({
//     this.gamesStarted = 0,
//     this.gamesWon = 0,
//     this.winRate = 0.0,
//     this.bestTime = 0,
//     this.avgTime = 0,
//     this.currentWinStreak = 0,
//     this.longestWinStreak = 0,
//     this.totalPoints = 0,
//     this.easyPoints = 0,
//     this.mediumPoints = 0,
//     this.hardPoints = 0,
//     this.expertPoints = 0,
//     this.nightmarePoints = 0,
//   });

//   /// Creates a copy with updated values
//   UserStats copyWith({
//     int? gamesStarted,
//     int? gamesWon,
//     double? winRate,
//     int? bestTime,
//     int? avgTime,
//     int? currentWinStreak,
//     int? longestWinStreak,
//     int? totalPoints,
//     int? easyPoints,
//     int? mediumPoints,
//     int? hardPoints,
//     int? expertPoints,
//     int? nightmarePoints,
//   }) {
//     return UserStats(
//       gamesStarted: gamesStarted ?? this.gamesStarted,
//       gamesWon: gamesWon ?? this.gamesWon,
//       winRate: winRate ?? this.winRate,
//       bestTime: bestTime ?? this.bestTime,
//       avgTime: avgTime ?? this.avgTime,
//       currentWinStreak: currentWinStreak ?? this.currentWinStreak,
//       longestWinStreak: longestWinStreak ?? this.longestWinStreak,
//       totalPoints: totalPoints ?? this.totalPoints,
//       easyPoints: easyPoints ?? this.easyPoints,
//       mediumPoints: mediumPoints ?? this.mediumPoints,
//       hardPoints: hardPoints ?? this.hardPoints,
//       expertPoints: expertPoints ?? this.expertPoints,
//       nightmarePoints: nightmarePoints ?? this.nightmarePoints,
//     );
//   }
// }

import 'package:hive_ce/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 6)
class UserStats {
  // Overall stats
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
  final int totalTime;

  // Easy difficulty stats
  @HiveField(9)
  final int easyPoints;

  @HiveField(10)
  final int easyGamesStarted;

  @HiveField(11)
  final int easyGamesWon;

  @HiveField(12)
  
  final double easyWinRate;

  @HiveField(13)
  final int easyBestTime;

  @HiveField(14)
  final int easyAvgTime;

  @HiveField(15)
  final int easyTotalTime;

  // Medium difficulty stats
  @HiveField(16)
  final int mediumPoints;

  @HiveField(17)
  final int mediumGamesStarted;

  @HiveField(18)
  final int mediumGamesWon;

  @HiveField(19)
  final double mediumWinRate;

  @HiveField(20)
  final int mediumBestTime;

  @HiveField(21)
  final int mediumAvgTime;

  @HiveField(22)
  final int mediumTotalTime;

  // Hard difficulty stats
  @HiveField(23)
  final int hardPoints;

  @HiveField(24)
  final int hardGamesStarted;

  @HiveField(25)
  final int hardGamesWon;

  @HiveField(26)
  final double hardWinRate;

  @HiveField(27)
  final int hardBestTime;

  @HiveField(28)
  final int hardAvgTime;

  @HiveField(29)
  final int hardTotalTime;

  // Expert difficulty stats
  @HiveField(30)
  final int expertPoints;

  @HiveField(31)
  final int expertGamesStarted;

  @HiveField(32)
  final int expertGamesWon;

  @HiveField(33)
  final double expertWinRate;

  @HiveField(34)
  final int expertBestTime;

  @HiveField(35)
  final int expertAvgTime;

  @HiveField(36)
  final int expertTotalTime;

  // Nightmare difficulty stats
  @HiveField(37)
  final int nightmarePoints;

  @HiveField(38)
  final int nightmareGamesStarted;

  @HiveField(39)
  final int nightmareGamesWon;

  @HiveField(40)
  final double nightmareWinRate;

  @HiveField(41)
  final int nightmareBestTime;

  @HiveField(42)
  final int nightmareAvgTime;

  @HiveField(43)
  final int nightmareTotalTime;

  UserStats({
    // Overall stats
    this.gamesStarted = 0,
    this.gamesWon = 0,
    this.winRate = 0.0,
    this.bestTime = 0,
    this.avgTime = 0,
    this.currentWinStreak = 0,
    this.longestWinStreak = 0,
    this.totalPoints = 0,
    this.totalTime = 0,

    // Easy difficulty stats
    this.easyPoints = 0,
    this.easyGamesStarted = 0,
    this.easyGamesWon = 0,
    this.easyWinRate = 0.0,
    this.easyBestTime = 0,
    this.easyAvgTime = 0,
    this.easyTotalTime = 0,

    // Medium difficulty stats
    this.mediumPoints = 0,
    this.mediumGamesStarted = 0,
    this.mediumGamesWon = 0,
    this.mediumWinRate = 0.0,
    this.mediumBestTime = 0,
    this.mediumAvgTime = 0,
    this.mediumTotalTime = 0,

    // Hard difficulty stats
    this.hardPoints = 0,
    this.hardGamesStarted = 0,
    this.hardGamesWon = 0,
    this.hardWinRate = 0.0,
    this.hardBestTime = 0,
    this.hardAvgTime = 0,
    this.hardTotalTime = 0,

    // Expert difficulty stats
    this.expertPoints = 0,
    this.expertGamesStarted = 0,
    this.expertGamesWon = 0,
    this.expertWinRate = 0.0,
    this.expertBestTime = 0,
    this.expertAvgTime = 0,
    this.expertTotalTime = 0,

    // Nightmare difficulty stats
    this.nightmarePoints = 0,
    this.nightmareGamesStarted = 0,
    this.nightmareGamesWon = 0,
    this.nightmareWinRate = 0.0,
    this.nightmareBestTime = 0,
    this.nightmareAvgTime = 0,
    this.nightmareTotalTime = 0,
  });

  /// Creates a copy with updated values
  UserStats copyWith({
    // Overall stats
    int? gamesStarted,
    int? gamesWon,
    double? winRate,
    int? bestTime,
    int? avgTime,
    int? currentWinStreak,
    int? longestWinStreak,
    int? totalPoints,
    int? totalTime,

    // Easy difficulty stats
    int? easyPoints,
    int? easyGamesStarted,
    int? easyGamesWon,
    double? easyWinRate,
    int? easyBestTime,
    int? easyAvgTime,
    int? easyTotalTime,

    // Medium difficulty stats
    int? mediumPoints,
    int? mediumGamesStarted,
    int? mediumGamesWon,
    double? mediumWinRate,
    int? mediumBestTime,
    int? mediumAvgTime,
    int? mediumTotalTime,

    // Hard difficulty stats
    int? hardPoints,
    int? hardGamesStarted,
    int? hardGamesWon,
    double? hardWinRate,
    int? hardBestTime,
    int? hardAvgTime,
    int? hardTotalTime,

    // Expert difficulty stats
    int? expertPoints,
    int? expertGamesStarted,
    int? expertGamesWon,
    double? expertWinRate,
    int? expertBestTime,
    int? expertAvgTime,
    int? expertTotalTime,

    // Nightmare difficulty stats
    int? nightmarePoints,
    int? nightmareGamesStarted,
    int? nightmareGamesWon,
    double? nightmareWinRate,
    int? nightmareBestTime,
    int? nightmareAvgTime,
    int? nightmareTotalTime,
  }) {
    return UserStats(
      // Overall stats
      gamesStarted: gamesStarted ?? this.gamesStarted,
      gamesWon: gamesWon ?? this.gamesWon,
      winRate: winRate ?? this.winRate,
      bestTime: bestTime ?? this.bestTime,
      avgTime: avgTime ?? this.avgTime,
      currentWinStreak: currentWinStreak ?? this.currentWinStreak,
      longestWinStreak: longestWinStreak ?? this.longestWinStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      totalTime: totalTime ?? this.totalTime,

      // Easy difficulty stats
      easyPoints: easyPoints ?? this.easyPoints,
      easyGamesStarted: easyGamesStarted ?? this.easyGamesStarted,
      easyGamesWon: easyGamesWon ?? this.easyGamesWon,
      easyWinRate: easyWinRate ?? this.easyWinRate,
      easyBestTime: easyBestTime ?? this.easyBestTime,
      easyAvgTime: easyAvgTime ?? this.easyAvgTime,
      easyTotalTime: easyTotalTime ?? this.easyTotalTime,

      // Medium difficulty stats
      mediumPoints: mediumPoints ?? this.mediumPoints,
      mediumGamesStarted: mediumGamesStarted ?? this.mediumGamesStarted,
      mediumGamesWon: mediumGamesWon ?? this.mediumGamesWon,
      mediumWinRate: mediumWinRate ?? this.mediumWinRate,
      mediumBestTime: mediumBestTime ?? this.mediumBestTime,
      mediumAvgTime: mediumAvgTime ?? this.mediumAvgTime,
      mediumTotalTime: mediumTotalTime ?? this.mediumTotalTime,

      // Hard difficulty stats
      hardPoints: hardPoints ?? this.hardPoints,
      hardGamesStarted: hardGamesStarted ?? this.hardGamesStarted,
      hardGamesWon: hardGamesWon ?? this.hardGamesWon,
      hardWinRate: hardWinRate ?? this.hardWinRate,
      hardBestTime: hardBestTime ?? this.hardBestTime,
      hardAvgTime: hardAvgTime ?? this.hardAvgTime,
      hardTotalTime: hardTotalTime ?? this.hardTotalTime,

      // Expert difficulty stats
      expertPoints: expertPoints ?? this.expertPoints,
      expertGamesStarted: expertGamesStarted ?? this.expertGamesStarted,
      expertGamesWon: expertGamesWon ?? this.expertGamesWon,
      expertWinRate: expertWinRate ?? this.expertWinRate,
      expertBestTime: expertBestTime ?? this.expertBestTime,
      expertAvgTime: expertAvgTime ?? this.expertAvgTime,
      expertTotalTime: expertTotalTime ?? this.expertTotalTime,

      // Nightmare difficulty stats
      nightmarePoints: nightmarePoints ?? this.nightmarePoints,
      nightmareGamesStarted: nightmareGamesStarted ?? this.nightmareGamesStarted,
      nightmareGamesWon: nightmareGamesWon ?? this.nightmareGamesWon,
      nightmareWinRate: nightmareWinRate ?? this.nightmareWinRate,
      nightmareBestTime: nightmareBestTime ?? this.nightmareBestTime,
      nightmareAvgTime: nightmareAvgTime ?? this.nightmareAvgTime,
      nightmareTotalTime: nightmareTotalTime ?? this.nightmareTotalTime,
    );
  }

  // Helper method to calculate win rate
  static double calculateWinRate(int gamesWon, int gamesStarted) {
    if (gamesStarted == 0) return 0.0;
    return (gamesWon / gamesStarted) * 100;
  }

  // Helper method to calculate average time
  static int calculateAvgTime(int totalTime, int gamesCompleted) {
    if (gamesCompleted == 0) return 0;
    return totalTime ~/ gamesCompleted;
  }

  // Helper method to update best time
  static int updateBestTime(int currentBestTime, int newTime) {
    if (currentBestTime == 0) return newTime;
    return newTime < currentBestTime ? newTime : currentBestTime;
  }
}