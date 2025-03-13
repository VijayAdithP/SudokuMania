

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/sudokuBoardModels/sudoku_board.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/service/hive_service.dart';

class SudokuNotifier extends ChangeNotifier {
  GameProgress? _gameProgress;
  bool _isLoading = true;
  final List<SudokuBoard> _history = [];
  int _currentStep = -1;

  GameProgress? get gameProgress => _gameProgress;
  bool get isLoading => _isLoading;

  SudokuNotifier() {
    _loadGame();
  }

  void updateBoard(SudokuBoard newBoard) {
    _history.add(newBoard.copyWith());
    _currentStep = _history.length - 1;
    notifyListeners();
  }

  void undo() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void redo() {
    if (_currentStep < _history.length - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Load game progress from Hive
  Future<void> _loadGame() async {
    _gameProgress = await HiveService.loadGame();
    _isLoading = false;
    notifyListeners();
  }

  /// Start a new game
  void startNewGame(GameProgress game) {
    _gameProgress = game;
    HiveService.clearSavedGame();
    notifyListeners();
  }

  /// Save current game state
  Future<void> saveGame() async {
    if (_gameProgress != null) {
      await HiveService.saveGame(_gameProgress!);
      // log("✅ Game progress saved");
    }
  }

  /// Complete game and save to history
  Future<void> completeGame() async {
    if (_gameProgress != null) {
      _gameProgress = _gameProgress!.copyWith(
        isCompleted: true,
        lastPlayed: DateTime.now(),
      );
      await HiveService.saveToHistory(_gameProgress!);
      await HiveService.clearSavedGame();
      _gameProgress = null;
      notifyListeners();
      // log("✅ Game completed and saved to history");
    }
  }

  /// Load user stats from Hive
  Future<UserStats?> loadUserStats() async {
    return await HiveService.loadUserStats();
  }

  /// Update and save user stats
  Future<void> updateUserStats(UserStats stats) async {
    await HiveService.saveUserStats(stats);
    notifyListeners();
  }

  /// Queue offline sync
  Future<void> queueOfflineSync(UserStats stats) async {
    await HiveService.queueOfflineSync(stats);
    notifyListeners();
  }

  /// Retrieve offline sync data
  Future<UserStats?> getOfflineSyncData() async {
    return await HiveService.getOfflineSyncData();
  }

  /// Clear offline sync queue
  Future<void> clearOfflineSyncQueue() async {
    await HiveService.clearOfflineSyncQueue();
    notifyListeners();
  }
}

final sudokuProvider = ChangeNotifierProvider<SudokuNotifier>((ref) {
  return SudokuNotifier();
});
