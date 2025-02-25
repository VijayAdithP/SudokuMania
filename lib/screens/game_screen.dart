import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/models/sudoku_board.dart';
import 'package:sudokumania/providers/gameProgressProviders/gameProgressProviders.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/number_pad.dart';
import 'package:vibration/vibration.dart';

class SudokuGamePage extends ConsumerStatefulWidget {
  const SudokuGamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends ConsumerState<SudokuGamePage> {
  int? selectedRow;
  int? selectedCol;
  // late Timer _timer;
  // String _timeDisplay = '00:00';
  late SudokuBoard _board;
  bool paused = false;
  final DateTime lastPlayed = DateTime.now();

  @override
  void initState() {
    super.initState();
    _continueGame();
    _loadBoard();
    _startTimer();
    _saveGame();
    ref.read(timeProvider.notifier).start(); // Start time
  }

  void _startTimer() {
    Future(() {
      if (mounted) {
        final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
        ref.read(timeProvider.notifier)
          ..addTime(elapsedTime)
          ..start();
      }
    });
  }

  void _loadBoard() async {
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    setState(() {
      _board = SudokuBoard.generateNewBoard(difficultyString);
    });
  }

  void _continueGame() async {
    var game = await HiveService.loadGame();
    log("🧐 Loaded game: $game");
    if (game != null) {
      setState(() {
        _board = SudokuBoard(
          grid: game.boardState,
          givenNumbers: game.givenNumbers,
          maxMistakes: game.mistakes,
          mistakes: game.mistakes,
        );
      });
    }
  }

  void _saveGame() async {
    final time = ref.read(timeProvider.notifier).getElapsedTime();
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    await HiveService.saveGame(GameProgress(
        boardState: _board.grid,
        givenNumbers: _board.givenNumbers,
        mistakes: _board.mistakes,
        elapsedTime: time,
        difficulty: difficultyString,
        lastPlayed: lastPlayed));
    log("${time}");
  }

  void _clearGame() async {
    await HiveService.clearSavedGame();
    var game = await HiveService.loadGame();
    log("🧐 After clearing, loaded game: $game");
  }

  int? lockedNumber;
  bool isLongPressMode = false;

  void _onNumberTap(int number) {
    if (isLongPressMode && lockedNumber == number) {
      setState(() {
        lockedNumber = null;
        isLongPressMode = false;
      });
      return;
    }

    if (isLongPressMode) {
      setState(() {
        lockedNumber = number;
      });
      return;
    }
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
      if (_board.gameOver) {
        _onGameOver();
        _clearGame();
      }
    } else {
      setState(() {
        _board = _board.copyWith(
            grid: _board.updateGrid(selectedRow!, selectedCol!, number));
      });
      if (_board.isSolved()) _onGameComplete();
    }
    _saveGame();
  }

  void _onNumberLongPress(int number) {
    setState(() {
      if (lockedNumber == number && isLongPressMode) {
        lockedNumber = null;
        isLongPressMode = false;
      } else {
        lockedNumber = number;
        isLongPressMode = true;
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  void _onPause() {
    _saveGame();
    ref.read(timeProvider.notifier).stop();
    // _timer.cancel();
    setState(() {
      paused = true;
    });
  }

  void _onGameComplete() {
    ref.read(timeProvider.notifier).stop();
    _clearGame();
    context.go(Routes.gameCompleteScreen);
  }

  void _onGameOver() {
    ref.read(timeProvider.notifier).stop();
    // _timer.cancel();
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
    if (isLongPressMode) {
      if (_board.grid[row][col] == null && !_board.givenNumbers[row][col]) {
        // Empty cell in long press mode - try to input locked number
        setState(() {
          if (_board.isMoveValid(row, col, lockedNumber!)) {
            _board = _board.copyWith(
                grid: _board.updateGrid(row, col, lockedNumber!));
            if (_board.isSolved()) _onGameComplete();
          } else {
            Vibration.vibrate(duration: 200);
            _board = _board.copyWith(
              mistakes: _board.mistakes + 1,
              gameOver: _board.mistakes + 1 >= _board.maxMistakes,
            );
            if (_board.gameOver) _onGameOver();
          }
          _saveGame();
        });
      } else if (_board.grid[row][col] != 0) {
        // Non-empty cell in long press mode - update locked number
        setState(() {
          _saveGame();
          lockedNumber = _board.grid[row][col];
        });
      }
      // If cell is empty, we keep the existing locked number
    } else {
      // Normal mode selection
      setState(() {
        selectedRow = row;
        selectedCol = col;
        if (_board.grid[row][col] != 0) {
          lockedNumber = _board.grid[row][col];
        } else {
          lockedNumber = null;
        }
      });
    }
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipPath(
        clipper: SquircleClipper(cornerRadius: 50),
        child: Stack(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1,
              ),
              itemCount: 81,
              itemBuilder: (context, index) {
                int row = index ~/ 9;
                int col = index % 9;

                Color cellColor = const Color.fromARGB(255, 51, 46, 72);

                if (isLongPressMode) {
                  // In long press mode, only highlight matching numbers
                  if (_board.grid[row][col] != null &&
                      _board.grid[row][col] == lockedNumber) {
                    cellColor = TColors.majorHighlight;
                  }
                } else {
                  // Normal mode highlighting
                  bool isSelected = row == selectedRow && col == selectedCol;
                  bool isInSameRow = selectedRow != null && row == selectedRow;
                  bool isInSameCol = selectedCol != null && col == selectedCol;
                  bool isInSame3x3 = selectedRow != null &&
                      selectedCol != null &&
                      (row ~/ 3 == selectedRow! ~/ 3) &&
                      (col ~/ 3 == selectedCol! ~/ 3);
                  bool hasSameNumber = selectedRow != null &&
                      selectedCol != null &&
                      _board.grid[selectedRow!][selectedCol!] != null &&
                      _board.grid[row][col] != null &&
                      _board.grid[row][col] ==
                          _board.grid[selectedRow!][selectedCol!];
                  bool isError = _board.grid[row][col] != null &&
                      !_board.isMoveValid(row, col, _board.grid[row][col]!);

                  if (isError) {
                    cellColor = Colors.red[100]!;
                  } else if (isSelected) {
                    cellColor = TColors.majorHighlight;
                  } else if (hasSameNumber) {
                    cellColor = const Color.fromARGB(255, 51, 46, 72)
                        .withValues(alpha: 0.3);
                  } else if (isInSameRow || isInSameCol || isInSame3x3) {
                    cellColor = HexColor("#363e79").withValues(
                      alpha: 0.7,
                    );
                  }
                }

                // Rest of your existing grid cell code...
                bool isRightOf3x3 = (col + 1) % 3 == 0 && col != 8;
                bool isBottomOf3x3 = (row + 1) % 3 == 0 && row != 8;
                bool isLeftOf3x3 = col % 3 == 0 && col != 0;
                bool isTopOf3x3 = row % 3 == 0 && row != 0;

                EdgeInsets cellMargin = EdgeInsets.only(
                  top: isTopOf3x3 ? 2.0 : 1.0,
                  left: isLeftOf3x3 ? 2.0 : 1.0,
                  right: isRightOf3x3 ? 2.0 : 1.0,
                  bottom: isBottomOf3x3 ? 2.0 : 1.0,
                );

                return GestureDetector(
                  onTap: paused
                      ? null
                      : () {
                          _selectCell(row, col);
                        },
                  child: Container(
                    margin: cellMargin,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cellColor,
                    ),
                    child: Text(
                      _board.grid[row][col]?.toString() ?? "",
                      style: TTextThemes.defaultTextTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: _board.givenNumbers[row][col]
                            ? (cellColor == TColors.majorHighlight)
                                ? Colors.white
                                : TColors.textSecondary
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (paused)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color.fromARGB(180, 51, 46, 72),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: TColors.majorHighlight,
                        ),
                        color: const Color.fromARGB(255, 51, 46, 72),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: IconButton(
                          onPressed: () {
                            ref.read(timeProvider.notifier).start();
                            setState(() {
                              paused = false;
                              _startTimer();
                            });
                          },
                          icon: HugeIcon(
                            size: 38,
                            icon: HugeIcons.strokeRoundedPlay,
                            color: TColors.majorHighlight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeState = ref.watch(timeProvider);
    final elapsedMilliseconds = timeState.elapsedMilliseconds;
    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    final int totalSeconds = elapsedMilliseconds ~/ 1000;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final String displayTime = hours > 0
        ? '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            _saveGame();
            context.go(Routes.homePage);
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            color: TColors.iconDefault,
          ),
        ),
        title: Text(
          difficultyString,
          style: TextStyle(
            color: TColors.textDefault,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSetting07,
              size: 24,
              color: TColors.iconDefault,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 30,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: Text(
                        displayTime,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    if (!paused)
                      CircleAvatar(
                        backgroundColor:
                            TColors.backgroundAccent.withValues(alpha: 0.2),
                        child: IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: TColors.backgroundAccent,
                          ),
                          onPressed: _onPause,
                        ),
                      ),
                  ],
                ),
                Text(
                  "Mistakes: ${_board.mistakes}/${_board.maxMistakes}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            _buildGrid(),
            NumberPad(
              isLongPressMode: isLongPressMode,
              lockedNumber: lockedNumber,
              onNumberTap: (number) {
                _onNumberTap(number);
              },
              onNumberLongPress: (number) {
                _onNumberLongPress(number);
              },
            ),
            Expanded(
                child: Container(
              color: Colors.red,
            )),
          ],
        ),
      ),
    );
  }
}

// This creates a "squircle" effect - a more continuous and smoother curve
class SquircleClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double curveFactor; // Higher values make the curve more pronounced

  SquircleClipper({
    required this.cornerRadius,
    this.curveFactor =
        0.001, // Adjust between 0.3-0.9 for different curve effects
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Calculate control points distance while maintaining the same corner boundary
    final controlDistance = cornerRadius * curveFactor;

    // Top left corner
    path.moveTo(0, cornerRadius);
    path.cubicTo(0, controlDistance, controlDistance, 0, cornerRadius, 0);

    // Top edge to top right corner
    path.lineTo(width - cornerRadius, 0);
    path.cubicTo(width - controlDistance, 0, width, controlDistance, width,
        cornerRadius);

    // Right edge to bottom right corner
    path.lineTo(width, height - cornerRadius);
    path.cubicTo(width, height - controlDistance, width - controlDistance,
        height, width - cornerRadius, height);

    // Bottom edge to bottom left corner
    path.lineTo(cornerRadius, height);
    path.cubicTo(controlDistance, height, 0, height - controlDistance, 0,
        height - cornerRadius);

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
