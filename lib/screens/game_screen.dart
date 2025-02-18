// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:sudokumania/models/sudoku_board.dart';
// import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
// import 'package:vibration/vibration.dart';

// class SudokuGamePage extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SudokuGamePageState();
// }

// class _SudokuGamePageState extends ConsumerState<SudokuGamePage> {
//   int? selectedRow;
//   int? selectedCol;
//   late Stopwatch _stopwatch;
//   late SudokuBoard _board;

//   @override
//   void initState() {
//     super.initState();
//     final difficultyString =
//         ref.read(difficultyProvider.notifier).getDifficultyString();
//     _stopwatch = Stopwatch()..start();
//     _board = SudokuBoard.generateNewBoard(difficultyString);
//     _loadBoard();
//     _loadGame();
//     _stopwatch = Stopwatch()..start();
//   }

// void _loadBoard() async {
//   var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//   SudokuBoard? savedBoard = box.get('current_game');

//   final difficultyString =
//       ref.read(difficultyProvider.notifier).getDifficultyString();
//   setState(() {
//     _board = savedBoard ?? SudokuBoard.generateNewBoard(difficultyString);
//   });
// }

// void _loadGame() async {
//   var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//   final difficultyString =
//       ref.read(difficultyProvider.notifier).getDifficultyString();
//   setState(() {
//     _board = box.get('current_game') ?? SudokuBoard.generateNewBoard(difficultyString);
//   });
// }

// void _saveGame() async {
//   var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//   box.put('current_game', _board);
// }

// void _onNumberTap(int number) {
//   if (selectedRow == null || selectedCol == null) return;
//   if (_board.givenNumbers[selectedRow!][selectedCol!]) return;

//   if (!_board.isMoveValid(selectedRow!, selectedCol!, number)) {
//     Vibration.vibrate(duration: 200);
//     setState(() {
//       _board = _board.copyWith(
//         mistakes: _board.mistakes + 1,
//         gameOver: _board.mistakes + 1 >= _board.maxMistakes,
//       );
//     });
//     if (_board.gameOver) _onGameOver();
//   } else {
//     setState(() {
//       _board = _board.copyWith(
//           grid: _board.updateGrid(selectedRow!, selectedCol!, number));
//     });
//     if (_board.isSolved()) _onGameComplete();
//   }
//   _saveGame();
// }

// void _onGameComplete() {
//   _stopwatch.stop();
//   // Navigator.pushReplacement(
//   //   context,
//   //   MaterialPageRoute(
//   //       builder: (context) => SudokuCompletionPage(time: _stopwatch.elapsed)),
//   // );
// }

// void _onGameOver() {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Game Over"),
//       content: Text("You've reached the mistake limit!"),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
//       ],
//     ),
//   );
// }

// void _onPause() {
//   _saveGame();
//   _stopwatch.stop();
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Game Paused"),
//       content: Text("Resume when ready."),
//       actions: [
//         TextButton(
//           onPressed: () {
//             _stopwatch.start();
//             Navigator.pop(context);
//           },
//           child: Text("Resume"),
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildNumberPad() {
//     return GridView.builder(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
//       itemCount: 9,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return ElevatedButton(
//           onPressed: () => _onNumberTap(index + 1),
//           child: Text("${index + 1}"),
//         );
//       },
//     );
//   }

//   Widget _buildGrid() {
//     return GridView.builder(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
//       itemCount: 81,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         int row = index ~/ 9;
//         int col = index % 9;
//         bool isSelected = row == selectedRow && col == selectedCol;
// bool isError = _board.grid[row][col] != null &&
//     !_board.isMoveValid(row, col, _board.grid[row][col]!);
//         return GestureDetector(
//           onTap: () => setState(() {
//             selectedRow = row;
//             selectedCol = col;
//           }),
//           child: Container(
//             margin: EdgeInsets.all(2),
//
//             decoration: BoxDecoration(
// color: isSelected
//     ? Colors.blue.withOpacity(0.3)
//     : (isError ? Colors.red.withOpacity(0.5) : Colors.white),
//               border: Border.all(color: Colors.black),
//             ),
//             child: Text(
//               _board.grid[row][col]?.toString() ?? "",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sudoku"),
//         actions: [IconButton(icon: Icon(Icons.pause), onPressed: _onPause)],
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _buildGrid()),
//           _buildNumberPad(),
//         ],
//       ),
//     );
//   }
// }

// class SudokuCompletionPage extends StatelessWidget {
//   final Duration time;
//   SudokuCompletionPage({required this.time});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Game Completed")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Completed in ${time.inMinutes}:${time.inSeconds % 60}"),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Back to Main Menu"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class SudokuGamePage extends StatefulWidget {
//   @override
//   _SudokuGamePageState createState() => _SudokuGamePageState();
// }

// class _SudokuGamePageState extends State<SudokuGamePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sudoku")),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: _buildGrid(),
//             ),
//           ),
//           SizedBox(height: 10),
//           _buildNumberPad(),
//         ],
//       ),
//     );
//   }

//   Widget _buildGrid() {
//     return GridView.builder(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
//       itemCount: 81,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: EdgeInsets.all(1),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNumberPad() {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3, childAspectRatio: 1.5),
//       itemCount: 9,
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return ElevatedButton(
//           onPressed: () {},
//           child: Text("${index + 1}", style: TextStyle(fontSize: 24)),
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sudokumania/models/sudoku_board.dart';

// class SudokuGamePage extends StatefulWidget {
//   @override
//   _SudokuGamePageState createState() => _SudokuGamePageState();
// }

// class _SudokuGamePageState extends State<SudokuGamePage> {
//   int? selectedRow;
//   int? selectedCol;
//   late Stopwatch _stopwatch;
//   late SudokuBoard _board;

//   @override
//   void initState() {
//     super.initState();
//     _stopwatch = Stopwatch()..start();
//     _board = SudokuBoard.generateNewBoard(0);
//   }

//   void _selectCell(int row, int col) {
//     setState(() {
//       selectedRow = row;
//       selectedCol = col;
//     });
//   }

//   Widget _buildGrid() {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: GridView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 9,
//           childAspectRatio: 1,
//         ),
//         itemCount: 81,
//         itemBuilder: (context, index) {
//           int row = index ~/ 9;
//           int col = index % 9;
//           bool isSelected = row == selectedRow && col == selectedCol;

//           return GestureDetector(
//             onTap: () => _selectCell(row, col),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 0.5),
//                 color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 _board.grid[row][col]?.toString() ?? "",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNumberPad() {
//     return GridView.builder(
//       shrinkWrap: true,
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
//       itemCount: 9,
//       itemBuilder: (context, index) {
//         return ElevatedButton(
//           onPressed: () {},
//           child: Text("${index + 1}"),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sudoku"),
//         actions: [
//           IconButton(icon: Icon(Icons.pause), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 10),
//           Text("Mistakes: 0/3",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Expanded(child: _buildGrid()),
//           _buildNumberPad(),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/models/sudoku_board.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:vibration/vibration.dart';

class SudokuGamePage extends ConsumerStatefulWidget {
  const SudokuGamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends ConsumerState<SudokuGamePage> {
  int? selectedRow;
  int? selectedCol;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeDisplay = '00:00';
  late SudokuBoard _board;
  final DateTime lastPlayed = DateTime.now();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    _loadBoard();
    _startTimer();
    _board = SudokuBoard.generateNewBoard(difficultyString);
    _saveGame();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateTimeDisplay();
      });
    });
  }

  void _updateTimeDisplay() {
    final minutes = _stopwatch.elapsed.inMinutes;
    final seconds = _stopwatch.elapsed.inSeconds % 60;
    _timeDisplay =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _loadBoard() async {
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    setState(() {
      _board = SudokuBoard.generateNewBoard(difficultyString);
    });
  }

  void _saveGame() async {
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    await HiveService.saveGame(GameProgress(
        boardState: _board.grid,
        givenNumbers: _board.givenNumbers,
        mistakes: _board.mistakes,
        elapsedTime: _stopwatch.elapsed.inSeconds,
        difficulty: difficultyString,
        lastPlayed: lastPlayed));
  }

  void _onNumberTap(int number) {
    if (selectedRow == null || selectedCol == null) return;
    if (_board.givenNumbers[selectedRow!][selectedCol!]) return;

    if (!_board.isMoveValid(selectedRow!, selectedCol!, number)) {
      Vibration.vibrate(duration: 200);
      setState(() {
        _board = _board.copyWith(
          mistakes: _board.mistakes + 1,
          gameOver: _board.mistakes + 1 >= _board.maxMistakes,
        );
      });
      if (_board.gameOver) _onGameOver();
    } else {
      setState(() {
        _board = _board.copyWith(
            grid: _board.updateGrid(selectedRow!, selectedCol!, number));
      });
      if (_board.isSolved()) _onGameComplete();
    }
    _saveGame();
  }

  void _onPause() {
    _saveGame();
    _stopwatch.stop();
    _timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Game Paused"),
        content: Text("Resume when ready."),
        actions: [
          TextButton(
            onPressed: () {
              _stopwatch.start();
              _startTimer();
              Navigator.pop(context);
            },
            child: Text("Resume"),
          ),
        ],
      ),
    );
  }

  void _onGameComplete() {
    _stopwatch.stop();
    HiveService.clearSavedGame();
  }

  void _onGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You've reached the mistake limit!"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  void _selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;

          // Check various highlight conditions
          bool isSelected = row == selectedRow && col == selectedCol;
          bool isInSameRow = selectedRow != null && row == selectedRow;
          bool isInSameCol = selectedCol != null && col == selectedCol;
          bool isInSame3x3 = selectedRow != null &&
              selectedCol != null &&
              (row ~/ 3 == selectedRow! ~/ 3) &&
              (col ~/ 3 == selectedCol! ~/ 3);

          // Check if cell has same number as selected cell
          bool hasSameNumber = selectedRow != null &&
              selectedCol != null &&
              _board.grid[selectedRow!][selectedCol!] != null &&
              _board.grid[row][col] != null &&
              _board.grid[row][col] == _board.grid[selectedRow!][selectedCol!];

          bool isError = _board.grid[row][col] != null &&
              !_board.isMoveValid(row, col, _board.grid[row][col]!);

          // Calculate border widths for 3x3 grid separation
          bool isRightBorder = (col + 1) % 3 == 0 && col != 8;
          bool isBottomBorder = (row + 1) % 3 == 0 && row != 8;

          // Determine cell color based on hierarchy
          Color cellColor = Colors.white; // Default background

          if (isError) {
            cellColor = Colors.red[100]!;
          } else if (isSelected) {
            cellColor = Colors.blue[200]!; // Most highlighted
          } else if (hasSameNumber) {
            cellColor = Colors.blue[100]!; // Second most highlighted
          } else if (isInSameRow || isInSameCol || isInSame3x3) {
            cellColor = Colors.blue[50]!; // Mildest highlight
          }

          return GestureDetector(
            onTap: () {
              log(_stopwatch.elapsed.inSeconds.toString());
              _selectCell(row, col);
            },
            child: Container(
              margin: EdgeInsets.all(1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: row == 0 ? 2.0 : 0.5),
                  left: BorderSide(width: col == 0 ? 2.0 : 0.5),
                  right:
                      BorderSide(width: isRightBorder || col == 8 ? 2.0 : 0.5),
                  bottom:
                      BorderSide(width: isBottomBorder || row == 8 ? 2.0 : 0.5),
                ),
                color: cellColor,
              ),
              child: Text(
                _board.grid[row][col]?.toString() ?? "",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: _board.givenNumbers[row][col]
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _board.givenNumbers[row][col]
                      ? Colors.black
                      : Colors.blue[800],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // Widget _buildGrid() {
  //   return AspectRatio(
  //     aspectRatio: 1,
  //     child: GridView.builder(
  //       physics: NeverScrollableScrollPhysics(),
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 9,
  //         childAspectRatio: 1,
  //       ),
  //       itemCount: 81,
  //       itemBuilder: (context, index) {
  //         int row = index ~/ 9;
  //         int col = index % 9;
  //         bool isSelected = row == selectedRow && col == selectedCol;
  //         bool isError = _board.grid[row][col] != null &&
  //             !_board.isMoveValid(row, col, _board.grid[row][col]!);

  //         // Calculate border widths for 3x3 grid separation
  //         bool isRightBorder = (col + 1) % 3 == 0 && col != 8;
  //         bool isBottomBorder = (row + 1) % 3 == 0 && row != 8;

  //         // Determine cell color
  //         Color cellColor = Colors.white; // Default white background

  //         if (_board.givenNumbers[row][col]) {
  //           cellColor = Colors.white; // Light gray for given numbers
  //         } else if (isError) {
  //           cellColor = Colors.red[100]!; // Light red for error cells
  //         } else if (isSelected || _board.givenNumbers[row][col]) {
  //           cellColor = Colors.blue[100]!; // Light blue for selected cells
  //         } else if (isSelected && _board.givenNumbers[row][col]) {
  //           cellColor = Colors.blue[100]!; // Light blue for selected cells
  //         }
  //         // if (isSelected) {
  //         //   if (isError) {
  //         //     cellColor =
  //         //         Colors.red.withOpacity(0.3); // Red for selected error cells
  //         //   } else {
  //         //     cellColor =
  //         //         Colors.blue.withOpacity(0.3); // Blue for selected valid cells
  //         //   }
  //         // }

  //         return GestureDetector(
  //           onTap: () {
  //             _selectCell(row, col);
  //           },
  //           child: Container(
  //             margin: EdgeInsets.all(1),
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 top: BorderSide(width: row == 0 ? 2.0 : 0.5),
  //                 left: BorderSide(width: col == 0 ? 2.0 : 0.5),
  //                 right:
  //                     BorderSide(width: isRightBorder || col == 8 ? 2.0 : 0.5),
  //                 bottom:
  //                     BorderSide(width: isBottomBorder || row == 8 ? 2.0 : 0.5),
  //               ),
  //               color: cellColor,
  //             ),
  //             child: Text(
  //               _board.grid[row][col]?.toString() ?? "",
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: _board.givenNumbers[row][col]
  //                     ? FontWeight.bold
  //                     : FontWeight.normal,
  //                 color: _board.givenNumbers[row][col]
  //                     ? Colors.black
  //                     : Colors.blue[800],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildNumberPad() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: 9,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {
            _onNumberTap(index + 1);
            setState(() {});
          },
          child: Text("${index + 1}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    return Scaffold(
      appBar: AppBar(
        title: Text(difficultyString),
        actions: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: _onPause,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Time: $_timeDisplay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Mistakes: ${_board.mistakes}/3",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(child: _buildGrid()),
          _buildNumberPad(),
        ],
      ),
    );
  }
}
