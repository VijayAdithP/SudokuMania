
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'sudoku_board.g.dart';

@HiveType(typeId: 4)
class SudokuBoard {
  @HiveField(0)
  final List<List<int?>> grid; // 9x9 board, null means empty

  @HiveField(1)
  final List<List<bool>> givenNumbers; // True if pre-filled

  @HiveField(2)
  final int mistakes;

  @HiveField(3)
  final int maxMistakes;

  @HiveField(4)
  final bool gameOver;

  SudokuBoard({
    required this.grid,
    required this.givenNumbers,
    this.mistakes = 0,
    required this.maxMistakes,
    this.gameOver = false,
  });

  /// Generates a new Sudoku board (Dummy implementation for now)
  static SudokuBoard generateNewBoard() {
    List<List<int?>> emptyGrid = List.generate(9, (_) => List.filled(9, null));
    List<List<bool>> givenNumbers = List.generate(9, (_) => List.filled(9, false));

    // TODO: Implement a Sudoku generator
    emptyGrid[0][0] = 5; // Example given number
    givenNumbers[0][0] = true;

    return SudokuBoard(
      grid: emptyGrid,
      givenNumbers: givenNumbers,
      maxMistakes: 3,
    );
  }

  /// Checks if placing `number` at (row, col) is valid
  bool isMoveValid(int row, int col, int number) {
    if (grid[row].contains(number)) return false; // Check row
    if (grid.any((r) => r[col] == number)) return false; // Check column

    int startRow = (row ~/ 3) * 3, startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == number) return false; // Check 3x3 block
      }
    }

    return true;
  }

  /// Places a number on the board (does not mutate state)
  List<List<int?>> updateGrid(int row, int col, int number) {
    List<List<int?>> newGrid = grid.map((row) => List<int?>.from(row)).toList();
    newGrid[row][col] = number;
    return newGrid;
  }

  /// Checks if the Sudoku is completely filled
  bool isSolved() {
    return grid.every((row) => row.every((cell) => cell != null));
  }

  /// Creates a copy with updated values (for Riverpod state updates)
  SudokuBoard copyWith({
    List<List<int?>>? grid,
    List<List<bool>>? givenNumbers,
    int? mistakes,
    int? maxMistakes,
    bool? gameOver,
  }) {
    return SudokuBoard(
      grid: grid ?? this.grid,
      givenNumbers: givenNumbers ?? this.givenNumbers,
      mistakes: mistakes ?? this.mistakes,
      maxMistakes: maxMistakes ?? this.maxMistakes,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}
