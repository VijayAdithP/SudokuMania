import 'package:hive_ce_flutter/hive_flutter.dart';

part 'game_progress.g.dart';

@HiveType(typeId: 5)
class GameProgress {
  @HiveField(0)
  final List<List<int?>> boardState;

  @HiveField(1)
  final List<List<bool>> givenNumbers;

  @HiveField(2)
  final int mistakes;

  @HiveField(3)
  final int elapsedTime; // Time when game was last played

  @HiveField(4)
  final String difficulty;

  @HiveField(5)
  final bool isCompleted; // To track finished games

  @HiveField(6)
  final DateTime lastPlayed; // Timestamp for "Continue" button
  @HiveField(7)
  final List<List<bool>> invalidCells;

  GameProgress({
    required this.boardState,
    required this.givenNumbers,
    required this.mistakes,
    required this.elapsedTime,
    required this.difficulty,
    this.isCompleted = false,
    required this.lastPlayed,
    List<List<bool>>? invalidCells,
  }) : this.invalidCells =
            invalidCells ?? List.generate(9, (_) => List.filled(9, false));

  /// Creates a copy with updated values
  GameProgress copyWith({
    List<List<int?>>? boardState,
    List<List<bool>>? givenNumbers,
    int? mistakes,
    int? elapsedTime,
    String? difficulty,
    bool? isCompleted,
    DateTime? lastPlayed,
    List<List<bool>>? invalidCells,
  }) {
    return GameProgress(
      boardState: boardState ?? this.boardState,
      givenNumbers: givenNumbers ?? this.givenNumbers,
      mistakes: mistakes ?? this.mistakes,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      invalidCells: invalidCells ?? this.invalidCells,
    );
  }

  String get formattedTime {
    final int totalSeconds = elapsedTime ~/ 1000;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
