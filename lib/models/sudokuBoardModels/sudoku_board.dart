// import 'package:hive_ce_flutter/hive_flutter.dart';

// part 'sudoku_board.g.dart';

// @HiveType(typeId: 4)
// class SudokuBoard {
//   @HiveField(0)
//   final List<List<int?>> grid; // 9x9 board, null means empty

//   @HiveField(1)
//   final List<List<bool>> givenNumbers; // True if pre-filled

//   @HiveField(2)
//   final int mistakes;

//   @HiveField(3)
//   final int maxMistakes;

//   @HiveField(4)
//   final bool gameOver;

//   SudokuBoard({
//     required this.grid,
//     required this.givenNumbers,
//     this.mistakes = 0,
//     required this.maxMistakes,
//     this.gameOver = false,
//   });

//   /// Generates a new Sudoku board (Dummy implementation for now)
//   static SudokuBoard generateNewBoard(String difficulty) {
//     List<List<int?>> emptyGrid = List.generate(9, (_) => List.filled(9, null));
//     List<List<bool>> givenNumbers =
//         List.generate(9, (_) => List.filled(9, false));

//     // TODO: Implement a Sudoku generator

//     emptyGrid[0][0] = 5;
//     givenNumbers[0][0] = true;

//     return SudokuBoard(
//       grid: emptyGrid,
//       givenNumbers: givenNumbers,
//       maxMistakes: 3,
//     );
//   }

//   /// Checks if placing `number` at (row, col) is valid
//   bool isMoveValid(int row, int col, int number) {
//     if (grid[row].contains(number)) return false; // Check row
//     if (grid.any((r) => r[col] == number)) return false; // Check column

//     int startRow = (row ~/ 3) * 3, startCol = (col ~/ 3) * 3;
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (grid[startRow + i][startCol + j] == number)
//           return false; // Check 3x3 block
//       }
//     }

//     return true;
//   }

//   /// Places a number on the board (does not mutate state)
//   List<List<int?>> updateGrid(int row, int col, int number) {
//     List<List<int?>> newGrid = grid.map((row) => List<int?>.from(row)).toList();
//     newGrid[row][col] = number;
//     return newGrid;
//   }

//   /// Checks if the Sudoku is completely filled
//   bool isSolved() {
//     return grid.every((row) => row.every((cell) => cell != null));
//   }

//   /// Creates a copy with updated values (for Riverpod state updates)
//   SudokuBoard copyWith({
//     List<List<int?>>? grid,
//     List<List<bool>>? givenNumbers,
//     int? mistakes,
//     int? maxMistakes,
//     bool? gameOver,
//   }) {
//     return SudokuBoard(
//       grid: grid ?? this.grid,
//       givenNumbers: givenNumbers ?? this.givenNumbers,
//       mistakes: mistakes ?? this.mistakes,
//       maxMistakes: maxMistakes ?? this.maxMistakes,
//       gameOver: gameOver ?? this.gameOver,
//     );
//   }
// }

import 'dart:math';

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

  @HiveField(5)
  final List<List<bool>> invalidCells;

  SudokuBoard({
    required this.grid,
    required this.givenNumbers,
    this.mistakes = 0,
    required this.maxMistakes,
    this.gameOver = false,
    List<List<bool>>? invalidCells,
  }) : invalidCells =
            invalidCells ?? List.generate(9, (_) => List.filled(9, false));

  /// Generates a new Sudoku board based on difficulty

  static SudokuBoard generateNewBoard(String difficulty, int maxMistakes) {
    List<List<int?>> emptyGrid = List.generate(9, (_) => List.filled(9, null));
    List<List<bool>> givenNumbers =
        List.generate(9, (_) => List.filled(9, false));

    final random = Random();
    final Map<String, int> difficultyRemovals = {
      'Easy': 1,
      'Medium': 2,
      'Hard': 1,
      'Nightmare': 60
    };

    // Fill the grid with a valid solution
    _fillGrid(emptyGrid, 0, 0, random);

    // Create a copy for the puzzle
    List<List<int?>> puzzleGrid =
        List.generate(9, (i) => List.generate(9, (j) => emptyGrid[i][j]));

    // Remove numbers based on difficulty while ensuring unique solution
    _removeNumbers(
        puzzleGrid, givenNumbers, difficultyRemovals[difficulty] ?? 30, random);

    return SudokuBoard(
      grid: puzzleGrid,
      givenNumbers: givenNumbers,
      maxMistakes: maxMistakes,
    );
  }

  /// Fills the grid with a valid Sudoku solution
  static bool _fillGrid(
      List<List<int?>> grid, int row, int col, Random random) {
    if (row == 9) return true;
    if (col == 9) return _fillGrid(grid, row + 1, 0, random);
    if (grid[row][col] != null) return _fillGrid(grid, row, col + 1, random);

    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    numbers.shuffle(random);

    for (int num in numbers) {
      if (_isValidPlacement(grid, row, col, num)) {
        grid[row][col] = num;
        if (_fillGrid(grid, row, col + 1, random)) return true;
        grid[row][col] = null;
      }
    }

    return false;
  }

  /// Checks if a number placement is valid
  static bool _isValidPlacement(
      List<List<int?>> grid, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }

    // Check column
    for (int x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }

    // Check 3x3 box
    int boxRow = row - row % 3;
    int boxCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[boxRow + i][boxCol + j] == num) return false;
      }
    }

    return true;
  }

  /// Checks if the current grid has a unique solution
  static bool _hasUniqueSolution(List<List<int?>> grid) {
    int solutions = 0;
    List<List<int?>> tempGrid =
        List.generate(9, (i) => List.generate(9, (j) => grid[i][j]));

    void solve(int position) {
      if (solutions > 1) return;
      if (position == 81) {
        solutions++;
        return;
      }

      int row = position ~/ 9;
      int col = position % 9;

      if (tempGrid[row][col] != null) {
        solve(position + 1);
        return;
      }

      for (int num = 1; num <= 9 && solutions <= 1; num++) {
        if (_isValidPlacement(tempGrid, row, col, num)) {
          tempGrid[row][col] = num;
          solve(position + 1);
          tempGrid[row][col] = null;
        }
      }
    }

    solve(0);
    return solutions == 1;
  }

  /// Removes numbers while ensuring a unique solution remains
  static void _removeNumbers(List<List<int?>> grid,
      List<List<bool>> givenNumbers, int numbersToRemove, Random random) {
    List<Point<int>> positions = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        positions.add(Point(i, j));
      }
    }
    positions.shuffle(random);

    int removed = 0;
    for (Point<int> pos in positions) {
      if (removed >= numbersToRemove) break;

      int row = pos.x, col = pos.y;
      int? temp = grid[row][col];
      grid[row][col] = null;

      if (_hasUniqueSolution(grid)) {
        givenNumbers[row][col] = false;
        removed++;
      } else {
        grid[row][col] = temp;
        givenNumbers[row][col] = true;
      }
    }

    // Mark remaining numbers as given
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] != null) {
          givenNumbers[i][j] = true;
        }
      }
    }
  }

  // / Checks if placing `number` at (row, col) is valid
  // bool isMoveValid(int row, int col, int number) {
  //   if (grid[row].contains(number)) return false; // Check row
  //   if (grid.any((r) => r[col] == number)) return false; // Check column

  //   int startRow = (row ~/ 3) * 3, startCol = (col ~/ 3) * 3;
  //   for (int i = 0; i < 3; i++) {
  //     for (int j = 0; j < 3; j++) {
  //       if (grid[startRow + i][startCol + j] == number) {
  //         return false;
  //       }
  //     }
  //   }

  //   return true;
  // }

  bool isMoveValid(int row, int col, int number) {
    // Skip checking the current cell position when validating
    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && grid[row][c] == number) return false;
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (r != row && grid[r][col] == number) return false;
    }

    // Check 3x3 box
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if ((startRow + i != row || startCol + j != col) &&
            grid[startRow + i][startCol + j] == number) {
          return false;
        }
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

  /// Checks if the Sudoku is completely filled and valid
  bool isSolved() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int? number = grid[row][col];
        if (number == null || !isMoveValid(row, col, number)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Creates a copy with updated values (for Riverpod state updates)
  SudokuBoard copyWith({
    List<List<int?>>? grid,
    List<List<bool>>? givenNumbers,
    int? mistakes,
    int? maxMistakes,
    bool? gameOver,
    List<List<bool>>? invalidCells,
  }) {
    return SudokuBoard(
      grid: grid ?? this.grid,
      givenNumbers: givenNumbers ?? this.givenNumbers,
      mistakes: mistakes ?? this.mistakes,
      maxMistakes: maxMistakes ?? this.maxMistakes,
      gameOver: gameOver ?? this.gameOver,
      invalidCells: invalidCells ?? this.invalidCells,
    );
  }
}
