// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:sudokumania/models/sudoku_board.dart';
// import 'package:vibration/vibration.dart';

// class SudokuGamePage extends StatefulWidget {
//   @override
//   _SudokuGamePageState createState() => _SudokuGamePageState();
// }

// class _SudokuGamePageState extends State<SudokuGamePage> {
//   int? selectedRow;
//   int? selectedCol;
//   late Stopwatch _stopwatch;

//   @override
//   void initState() {
//     super.initState();
//     _loadBoard();
//     _loadGame();
//     _stopwatch = Stopwatch()..start();
//   }

//   late SudokuBoard _board = SudokuBoard.generateNewBoard();

//   void _loadBoard() async {
//     var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//     SudokuBoard? savedBoard = box.get('current_game');

//     setState(() {
//       _board = savedBoard ?? SudokuBoard.generateNewBoard();
//     });
//   }

//   void _loadGame() async {
//     var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//     setState(() {
//       _board = box.get('current_game') ?? SudokuBoard.generateNewBoard();
//     });
//   }

//   void _saveGame() async {
//     var box = await Hive.openBox<SudokuBoard>('sudoku_game');
//     box.put('current_game', _board);
//   }

//   void _onNumberTap(int number) {
//     if (selectedRow == null || selectedCol == null) return;
//     if (_board.givenNumbers[selectedRow!][selectedCol!]) return;

//     if (!_board.isMoveValid(selectedRow!, selectedCol!, number)) {
//       Vibration.vibrate(duration: 200);
//       setState(() {
//         _board = _board.copyWith(
//           mistakes: _board.mistakes + 1,
//           gameOver: _board.mistakes + 1 >= _board.maxMistakes,
//         );
//       });
//       if (_board.gameOver) _onGameOver();
//     } else {
//       setState(() {
//         _board = _board.copyWith(
//             grid: _board.updateGrid(selectedRow!, selectedCol!, number));
//       });
//       if (_board.isSolved()) _onGameComplete();
//     }
//     _saveGame();
//   }

//   void _onGameComplete() {
//     _stopwatch.stop();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => SudokuCompletionPage(time: _stopwatch.elapsed)),
//     );
//   }

//   void _onGameOver() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Game Over"),
//         content: Text("You've reached the mistake limit!"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
//         ],
//       ),
//     );
//   }

//   void _onPause() {
//     _saveGame();
//     _stopwatch.stop();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Game Paused"),
//         content: Text("Resume when ready."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _stopwatch.start();
//               Navigator.pop(context);
//             },
//             child: Text("Resume"),
//           ),
//         ],
//       ),
//     );
//   }

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
//         bool isError = _board.grid[row][col] != null &&
//             !_board.isMoveValid(row, col, _board.grid[row][col]!);
//         return GestureDetector(
//           onTap: () => setState(() {
//             selectedRow = row;
//             selectedCol = col;
//           }),
//           child: Container(
//             margin: EdgeInsets.all(2),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? Colors.blue.withOpacity(0.3)
//                   : (isError ? Colors.red.withOpacity(0.5) : Colors.white),
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
import 'package:flutter/material.dart';
import 'package:sudokumania/models/sudoku_board.dart';

class SudokuGamePage extends StatefulWidget {
  @override
  _SudokuGamePageState createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage> {
  int? selectedRow;
  int? selectedCol;
  late Stopwatch _stopwatch;
  late SudokuBoard _board;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _board = SudokuBoard.generateNewBoard();
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
          bool isSelected = row == selectedRow && col == selectedCol;
          
          return GestureDetector(
            onTap: () => _selectCell(row, col),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                _board.grid[row][col]?.toString() ?? "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: 9,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {},
          child: Text("${index + 1}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku"),
        actions: [
          IconButton(icon: Icon(Icons.pause), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text("Mistakes: 0/3", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(child: _buildGrid()),
          _buildNumberPad(),
        ],
      ),
    );
  }
}
