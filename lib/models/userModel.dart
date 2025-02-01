import 'package:hive_ce_flutter/hive_flutter.dart';

part 'userModel.g.dart';  // Ensure correct casing (case-sensitive)

@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  int totalPoints;

  @HiveField(4)
  final Map<String, DifficultyStats> statistics;

  @HiveField(5)
  final List<GameHistory> gameHistory;

  @HiveField(6)
  GameProgress? currentGame;

  UserData({
    required this.userId,
    required this.username,
    this.email,
    this.totalPoints = 0,
    Map<String, DifficultyStats>? statistics,
    List<GameHistory>? gameHistory,
    this.currentGame,
  })  : statistics = statistics ??
            {
              'easy': DifficultyStats(),
              'medium': DifficultyStats(),
              'hard': DifficultyStats(),
              'expert': DifficultyStats(),
              'nightmare': DifficultyStats(),
            },
        gameHistory = gameHistory ?? [];
}

@HiveType(typeId: 1)
class DifficultyStats {
  @HiveField(0)
  int gamesStarted;

  @HiveField(1)
  int gamesWon;

  @HiveField(2)
  double winRate;

  @HiveField(3)
  int bestTime;

  @HiveField(4)
  int avgTime;

  @HiveField(5)
  int currentStreak;

  @HiveField(6)
  int longestStreak;

  @HiveField(7)
  int points;

  DifficultyStats({
    this.gamesStarted = 0,
    this.gamesWon = 0,
    this.winRate = 0.0,
    this.bestTime = 0,
    this.avgTime = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.points = 0,
  });
}

@HiveType(typeId: 2)
class GameHistory {
  @HiveField(0)
  final String gameId;

  @HiveField(1)
  final String difficulty;

  @HiveField(2)
  final int timeTaken;

  @HiveField(3)
  final int mistakes;

  @HiveField(4)
  final DateTime completionDate;

  GameHistory({
    required this.gameId,
    required this.difficulty,
    required this.timeTaken,
    required this.mistakes,
    required this.completionDate,
  });
}

@HiveType(typeId: 3)
class GameProgress {
  @HiveField(0)
  final List<List<int?>> boardState;

  @HiveField(1)
  final List<List<bool>> givenNumbers;

  @HiveField(2)
  int mistakes;

  @HiveField(3)
  int elapsedTime;

  @HiveField(4)
  final String difficulty;

  @HiveField(5)
  final DateTime lastSaved;

  GameProgress({
    required this.boardState,
    required this.givenNumbers,
    required this.mistakes,
    required this.elapsedTime,
    required this.difficulty,
    required this.lastSaved,
  });
}
