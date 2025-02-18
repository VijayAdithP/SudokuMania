import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SudokuDifficulty {
  easy,
  medium,
  hard,
  nightmare
}

// StateNotifier to manage difficulty state
class DifficultyStateNotifier extends StateNotifier<SudokuDifficulty> {
  DifficultyStateNotifier() : super(SudokuDifficulty.easy);

  void setDifficulty(SudokuDifficulty difficulty) {
    state = difficulty;
  }

  // Helper method to convert enum to string
  String getDifficultyString() {
    switch (state) {
      case SudokuDifficulty.easy:
        return 'Easy';
      case SudokuDifficulty.medium:
        return 'Medium';
      case SudokuDifficulty.hard:
        return 'Hard';
      case SudokuDifficulty.nightmare:
        return 'Nightmare';
    }
  }

  // Helper method to convert int to difficulty
  static SudokuDifficulty difficultyFromInt(int value) {
    switch (value) {
      case 0:
        return SudokuDifficulty.easy;
      case 1:
        return SudokuDifficulty.medium;
      case 2:
        return SudokuDifficulty.hard;
      case 3:
        return SudokuDifficulty.nightmare;
      default:
        return SudokuDifficulty.easy;
    }
  }

  // Helper method to convert difficulty to int
  static int difficultyToInt(SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return 0;
      case SudokuDifficulty.medium:
        return 1;
      case SudokuDifficulty.hard:
        return 2;
      case SudokuDifficulty.nightmare:
        return 3;
    }
  }
}

// Provider for difficulty state
final difficultyProvider = StateNotifierProvider<DifficultyStateNotifier, SudokuDifficulty>((ref) {
  return DifficultyStateNotifier();
});