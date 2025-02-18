// import 'dart:developer';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sudokumania/providers/game_state_provider.dart';
// import '../models/game_progress.dart';
// import '../service/hive_service.dart';

// class SudokuNotifier extends StateNotifier<GameProgress?> {
//   SudokuNotifier() : super(null) {
//     _loadSavedGame(); // Auto-load for "Continue" button
//   }

//   /// 🔹 Start a new Sudoku game
//   void startNewGame(String difficulty) {
//     HiveService.clearSavedGame();
//     state = GameProgress(
//       boardState: List.generate(9, (_) => List.filled(9, null)), // Empty board
//       givenNumbers: List.generate(9, (_) => List.filled(9, false)),
//       mistakes: 0,
//       elapsedTime: 0,
//       difficulty: difficulty,
//       isCompleted: false,
//       lastPlayed: DateTime.now(),
//     );
//   }

//   /// 🔹 Handles placing a number on the Sudoku board
//   void placeNumber(int row, int col, int number, WidgetRef ref) {
//     if (state == null || state!.givenNumbers[row][col]) return;

//     bool isCorrect = _isMoveValid(row, col, number);
//     state = state!.copyWith(
//       boardState: _updateGrid(state!.boardState, row, col, number),
//       mistakes: isCorrect ? state!.mistakes : state!.mistakes + 1,
//       lastPlayed: DateTime.now(),
//     );

//     saveGame();

//     if (_isGameSolved()) {
//       _markGameAsCompleted(ref);
//     }
//   }

//   /// 🔹 Checks if the move is valid
//   bool _isMoveValid(int row, int col, int number) {
//     return state!.boardState[row][col] == null && state!.givenNumbers[row][col];
//   }

//   /// 🔹 Updates the grid state with a new number
//   List<List<int?>> _updateGrid(
//       List<List<int?>> grid, int row, int col, int number) {
//     List<List<int?>> newGrid = grid.map((row) => List<int?>.from(row)).toList();
//     newGrid[row][col] = number;
//     return newGrid;
//   }

//   /// 🔹 Checks if the game is fully solved
//   bool _isGameSolved() {
//     return state!.boardState.every((row) => row.every((cell) => cell != null));
//   }

//   /// 🔹 Marks game as completed and updates Firestore + Hive
//   void _markGameAsCompleted(WidgetRef ref) async {
//     if (state == null) return;

//     state = state!.copyWith(isCompleted: true);
//     HiveService.saveToHistory(state!); // Store in history
//     HiveService.clearSavedGame(); // Remove from "Continue" option

//     log("🏆 Game Completed!");

//     // 🔹 Get user details
//     String? userId = await HiveService.getUserId();
//     String? username = await HiveService.getUsername();

//     if (userId == null || username == null) {
//       log("❌ Error: User ID or username is missing.");
//       return;
//     }

//     // 🔹 Check if online (TODO: Implement network check)
//     bool isOnline = true; // Replace this with actual network status

//     // 🔹 Update leaderboard & stats
//     ref.read(statsProvider.notifier).updateGameStats(
//           true,
//           state!.difficulty,
//           state!.elapsedTime,
//           userId,
//           username,
//           isOnline,
//         );

//     log("✅ Player stats updated in Firestore and Hive!");
//   }

//   /// 🔹 Load saved game from Hive
//   void _loadSavedGame() async {
//     GameProgress? savedGame = await HiveService.loadGame();
//     if (savedGame != null) {
//       state = savedGame;
//       log("📂 Loaded saved game");
//     }
//   }

//   /// 🔹 Replay a completed game
//   void replayGame(GameProgress game) {
//     state = game.copyWith(isCompleted: false, mistakes: 0, elapsedTime: 0);
//   }

//   /// 🔹 Save the current game state to Hive
//   void saveGame() {
//     if (state != null) {
//       HiveService.saveGame(state!);
//     }
//   }
// }

// /// 🔹 Provide access to Sudoku logic across the app
// final sudokuProvider =
//     StateNotifierProvider<SudokuNotifier, GameProgress?>((ref) {
//   return SudokuNotifier();
// });

// // 🔹 Manage game history
// class HistoryNotifier extends StateNotifier<Map<String, List<GameProgress>>> {
//   HistoryNotifier() : super({}) {
//     loadHistory();
//   }

//   /// 🔹 Loads game history grouped by date
//   void loadHistory() async {
//     Map<String, List<GameProgress>> history =
//         await HiveService.loadGroupedHistory();
//     state = history;
//   }
// }

// final historyProvider =
//     StateNotifierProvider<HistoryNotifier, Map<String, List<GameProgress>>>(
//         (ref) {
//   return HistoryNotifier();
// });

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/models/sudoku_board.dart';
import 'package:sudokumania/models/user_stats.dart';
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
      log("✅ Game progress saved");
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
      log("✅ Game completed and saved to history");
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
