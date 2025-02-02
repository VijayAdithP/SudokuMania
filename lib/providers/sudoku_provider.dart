import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_progress.dart';
import '../service/hive_service.dart';

class SudokuNotifier extends StateNotifier<GameProgress?> {
  SudokuNotifier() : super(null) {
    _loadSavedGame(); // Auto-load for "Continue" button
  }

  void startNewGame(String difficulty) {
    HiveService.clearSavedGame();
    state = GameProgress(
      boardState: List.generate(9, (_) => List.filled(9, null)), // Empty board
      givenNumbers: List.generate(9, (_) => List.filled(9, false)),
      mistakes: 0,
      elapsedTime: 0,
      difficulty: difficulty,
      isCompleted: false,
      lastPlayed: DateTime.now(),
    );
  }

  void placeNumber(int row, int col, int number) {
    if (state == null || state!.givenNumbers[row][col]) return;

    bool isCorrect = _isMoveValid(row, col, number);
    state = state!.copyWith(
      boardState: _updateGrid(state!.boardState, row, col, number),
      mistakes: isCorrect ? state!.mistakes : state!.mistakes + 1,
      lastPlayed: DateTime.now(),
    );

    saveGame();

    if (_isGameSolved()) {
      _markGameAsCompleted();
    }
  }

  bool _isMoveValid(int row, int col, int number) {
    return state!.boardState[row][col] == null && state!.givenNumbers[row][col];
  }

  List<List<int?>> _updateGrid(
      List<List<int?>> grid, int row, int col, int number) {
    List<List<int?>> newGrid = grid.map((row) => List<int?>.from(row)).toList();
    newGrid[row][col] = number;
    return newGrid;
  }

  bool _isGameSolved() {
    return state!.boardState.every((row) => row.every((cell) => cell != null));
  }

  void _markGameAsCompleted() {
    if (state != null) {
      state = state!.copyWith(isCompleted: true);
      HiveService.saveToHistory(state!); // Store in history
      HiveService.clearSavedGame(); // Remove from "Continue" option
    }
  }

  void _loadSavedGame() async {
    GameProgress? savedGame = await HiveService.loadGame();
    if (savedGame != null) {
      state = savedGame;
      log("📂 Loaded saved game");
    }
  }

  void replayGame(GameProgress game) {
    state = game.copyWith(isCompleted: false, mistakes: 0, elapsedTime: 0);
  }

  void saveGame() {
    if (state != null) {
      HiveService.saveGame(state!);
    }
  }
}

final sudokuProvider =
    StateNotifierProvider<SudokuNotifier, GameProgress?>((ref) {
  return SudokuNotifier();
});

// Replay Saved games
class HistoryNotifier extends StateNotifier<Map<String, List<GameProgress>>> {
  HistoryNotifier() : super({}) {
    loadHistory();
  }

  /// Loads game history grouped by date
  void loadHistory() async {
    Map<String, List<GameProgress>> history =
        await HiveService.loadGroupedHistory();
    state = history;
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, Map<String, List<GameProgress>>>(
        (ref) {
  return HistoryNotifier();
});
