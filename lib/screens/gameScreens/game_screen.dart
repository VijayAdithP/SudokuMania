import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/sudokuBoardModels/sudoku_board.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/screens/settingsScreen/max_mistakes_screen.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/gameScreen/game_over_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/game_restart_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/how_to_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/number_pad.dart';
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
  List<Map<String, dynamic>> _moveHistory = [];

  @override
  void initState() {
    super.initState();
    _continueGame();
    _loadBoard();
    _startTimer();
    _saveGame();
    ref.read(timeProvider.notifier).start();
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
    var maxMistakes = ref.read(maxMistakesProvider);
    if (ref.read(switchStateProvider)) {
      maxMistakes = ref.read(maxMistakesProvider);
    } else {
      maxMistakes = 10000;
    }
    setState(() {
      _board = SudokuBoard.generateNewBoard(difficultyString, maxMistakes);
    });
  }

  Future<void> _continueGame() async {
    final maxMistakes = ref.read(maxMistakesProvider);
    var game = await HiveService.loadGame();
    if (game == null) {
      // Handle the case where the game could not be loaded
      return;
    }

    // Directly use the stored invalidCells from the saved game
    List<List<bool>> invalidCells = game.invalidCells;

    setState(() {
      _board = SudokuBoard(
        grid: game.boardState,
        givenNumbers: game.givenNumbers,
        maxMistakes: maxMistakes,
        mistakes: game.mistakes,
        invalidCells: invalidCells,
      );
    });
  }

  Future<bool> isMoveValidAgainstSolution(int row, int col, int value) async {
    var game = await HiveService.loadGame();
    if (game == null) {
      // Handle the case where the game could not be loaded
      return false;
    }

    // Create a copy of the board state
    var boardCopy = List.generate(
      9,
      (i) => List<int?>.from(game.boardState[i]),
    );

    boardCopy[row][col] = null; // Temporarily remove the value
    bool isValid = _board.isMoveValid(
      row,
      col,
      value,
    );

    return isValid;
  }

  void _saveGame() async {
    final time = ref.read(timeProvider.notifier).getElapsedTime();
    UserCred? userCred = await HiveService.getUserCred();

    final difficultyString =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    final stats = await HiveService.loadUserStats() ?? UserStats();
    await HiveService.saveGame(GameProgress(
      boardState: _board.grid,
      givenNumbers: _board.givenNumbers,
      mistakes: _board.mistakes,
      elapsedTime: time,
      difficulty: difficultyString,
      lastPlayed: lastPlayed,
      invalidCells: _board.invalidCells,
    ));
    var updatedStats = stats.copyWith(
        totalTime: stats.totalTime + time,
        avgTime: UserStats.calculateAvgTime(
          stats.totalTime,
          stats.gamesStarted,
        ));
    if (difficultyString == "Easy") {
      updatedStats = updatedStats.copyWith(
        easyTotalTime: updatedStats.easyTotalTime + time,
        easyAvgTime: UserStats.calculateAvgTime(
          stats.easyTotalTime,
          stats.gamesStarted,
        ),
      );
    } else if (difficultyString == "Medium") {
      updatedStats = updatedStats.copyWith(
        mediumTotalTime: updatedStats.mediumTotalTime + time,
        mediumAvgTime: UserStats.calculateAvgTime(
          stats.mediumTotalTime,
          stats.gamesStarted,
        ),
      );
    } else if (difficultyString == "Hard") {
      updatedStats = updatedStats.copyWith(
        hardTotalTime: updatedStats.hardTotalTime + time,
        hardAvgTime: UserStats.calculateAvgTime(
          stats.hardTotalTime,
          stats.gamesStarted,
        ),
      );
    } else if (difficultyString == "Nightmare") {
      updatedStats = updatedStats.copyWith(
        nightmareTotalTime: updatedStats.nightmareTotalTime + time,
        nightmareAvgTime: UserStats.calculateAvgTime(
          stats.nightmareTotalTime,
          stats.gamesStarted,
        ),
      );
    }

    // Save the updated stats
    await HiveService.saveUserStats(updatedStats);
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, updatedStats);
    }

    // Log the results
    // log("plus the difficulty $difficultyString");
    // log("This is the elapsed time ${updatedStats.easyTotalTime.toString()}");
    // log("This is the current elapsed time ${time.toString()}");
  }

  // void _clearGame() async {
  //   await HiveService.clearSavedGame();
  // }

  void _recordMove(int row, int col, int? previousValue, bool wasInvalid) {
    _moveHistory.add({
      'row': row,
      'col': col,
      'previousValue': previousValue,
      'wasInvalid': wasInvalid,
    });
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

    // Create a copy of the current invalidCells to modify
    var newInvalidCells =
        List.generate(9, (i) => List<bool>.from(_board.invalidCells[i]));

    // Always enter the number
    setState(() {
      // Check if the move is valid or not
      bool isValid = _board.isMoveValid(selectedRow!, selectedCol!, number);

      // Mark this specific cell as invalid if needed
      newInvalidCells[selectedRow!][selectedCol!] = !isValid;

      _board = _board.copyWith(
        grid: _board.updateGrid(selectedRow!, selectedCol!, number),
        invalidCells: newInvalidCells,
      );
      _recordMove(selectedRow!, selectedCol!,
          _board.grid[selectedRow!][selectedCol!], isValid);
      if (!isValid) {
        Vibration.vibrate(duration: 200);
        _board = _board.copyWith(
          mistakes: _board.mistakes + 1,
          gameOver: _board.mistakes + 1 >= _board.maxMistakes,
        );

        if (_board.gameOver) {
          _onGameOver();
        }
      } else if (_board.isSolved()) {
        _onGameComplete();
      }
    });

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
    setState(() {
      paused = true;
    });
  }

  // void _onGameComplete() {

  //   ref.read(timeProvider.notifier).stop();
  //   context.go(Routes.gameCompleteScreen);
  // }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onGameComplete() async {
    ref.read(timeProvider.notifier).stop();
    final selectedDate = ref.read(selectedDateProvider);

    // Check if the game source is calendar
    final gameSource = ref.read(gameSourceProvider);
    if (gameSource == GameSource.calendar) {
      final normalizedDate = normalizeDate(selectedDate!); // Normalize the date
      log("Completing game for date: $normalizedDate"); // Log the date being completed
      await ref
          .read(dailyChallengeProvider.notifier)
          .completeChallenge(normalizedDate, calculateBaseScore());
    }
    context.go(Routes.gameCompleteScreen);
  }

  void _onGameOver() async {
    UserCred? userCred = await HiveService.getUserCred();

    UserStats? currentStats = await HiveService.loadUserStats() ?? UserStats();
    ref.read(timeProvider.notifier).stop();

    setState(() {
      paused = true;
    });

    final updatedStats = currentStats.copyWith(
      currentWinStreak: 0,
    );

    // log("Updated Stats: ${updatedStats.currentWinStreak}"); // Log the updated stats

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GameOverDialog(),
    );

    await HiveService.saveUserStats(updatedStats);
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, updatedStats);
    }
  }

  double calculateBaseScore() {
    return (_board.maxMistakes - _board.mistakes) * 10;
  }

  void _selectCell(int row, int col) {
    final previousValue = _board.grid[row][col];
    final maxMistakes = ref.read(maxMistakesProvider);

    if (isLongPressMode) {
      if (!_board.givenNumbers[row][col]) {
        // Create a copy of the current invalidCells to modify
        var newInvalidCells =
            List.generate(9, (i) => List<bool>.from(_board.invalidCells[i]));

        setState(() {
          // Check if the move is valid before making it
          bool isValid = _board.isMoveValid(row, col, lockedNumber!);

          _recordMove(row, col, previousValue, !isValid);

          // Mark this specific cell as invalid if needed
          newInvalidCells[row][col] = !isValid;

          // Always update with the locked number
          _board = _board.copyWith(
            grid: _board.updateGrid(row, col, lockedNumber!),
            invalidCells: newInvalidCells,
          );

          if (!isValid) {
            Vibration.vibrate(duration: 200);
            setState(() {
              _board = _board.copyWith(
                mistakes: _board.mistakes + 1,
                gameOver: _board.mistakes + 1 >= maxMistakes,
              );
            });
            if (_board.gameOver) _onGameOver();
          } else if (_board.isSolved()) {
            _onGameComplete();
          }
        });

        _saveGame();
      } else if (_board.grid[row][col] != 0) {
        _saveGame();
        setState(() {
          lockedNumber = _board.grid[row][col];
        });
      }
    } else {
      // Normal mode selection (unchanged)
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

                // Color cellColor = const Color.fromARGB(255, 51, 46, 72);
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
                  bool isError = _board.invalidCells[row][col];

                  if (isError) {
                    cellColor = Colors.red.withValues(alpha: 0.3);
                  } else if (isSelected && isError) {
                    cellColor = Colors.red.withValues(alpha: 0.3);
                  } else if (isSelected) {
                    cellColor = TColors.majorHighlight;
                    // cellColor = TColors.buttonDefault;
                  } else if (hasSameNumber) {
                    cellColor = const Color.fromARGB(255, 51, 46, 72)
                        .withValues(alpha: 0.3);
                  } else if (isInSameRow || isInSameCol || isInSame3x3) {
                    cellColor = HexColor("#363e79").withValues(
                      alpha: 0.7,
                    );
                  }
                }
                bool isError = _board.invalidCells[row][col];

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
                      gradient: (_board.grid[row][col] != null &&
                              _board.grid[row][col] == lockedNumber &&
                              isLongPressMode)
                          ? LinearGradient(
                              colors: [TColors.g1Color, TColors.g2Color],
                            )
                          : null,
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
                            : isError
                                ? Colors.red[400]
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

  void erase(int row, int col) {
    // Check if the cell is already empty
    if (_board.grid[row][col] == null) return;

    // Only allow erasing user-entered numbers (not given numbers)
    if (_board.givenNumbers[row][col] == false) {
      setState(() {
        _board.invalidCells[row][col] = false; // Mark the cell as valid
        _board.grid[row][col] = null; // Clear the cell
        _saveGame(); // Save the game state
      });
    }
  }

  void _onUndo() {
    if (_moveHistory.isEmpty) return;

    // Get the last move from history
    final lastMove = _moveHistory.removeLast();
    final row = lastMove['row'];
    final col = lastMove['col'];
    final wasInvalid = lastMove['wasInvalid'];

    // Create a copy of the current invalidCells to modify
    var newInvalidCells =
        List.generate(9, (i) => List<bool>.from(_board.invalidCells[i]));

    // Update the board state
    setState(() {
      _board.invalidCells[row][col] = false; // Mark the cell as valid
      _board.grid[row][col] = null; // Clear the cell
      _saveGame(); // Save the game state

      // If the move was invalid, decrement the mistake counter
      if (wasInvalid) {
        // Remove invalid marker from the cell
        newInvalidCells[row][col] = false;

        _board = _board.copyWith(
          invalidCells: newInvalidCells,
          mistakes: _board.mistakes - 1,
          gameOver: false, // Always set to false since we're reducing mistakes
        );
      } else {
        _board = _board.copyWith(
          invalidCells: newInvalidCells,
        );
      }
    });

    // Save the updated game state
    _saveGame();
  }

  Widget _buildAccButtons(int row, int col) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        accButton(
          50,
          50,
          TColors.backgroundPrimary,
          TColors.dullBackground,
          () {
            _onUndo();
          },
          TColors.textSecondary,
          24,
          HugeIcons.strokeRoundedReload,
        ),
        accButton(
          60,
          60,
          TColors.backgroundPrimary,
          const Color.fromARGB(255, 230, 123, 116),
          () {
            erase(row, col);
          },
          TColors.textSecondary,
          30,
          HugeIcons.strokeRoundedEraser,
        ),
        accButton(
          75,
          75,
          TColors.majorHighlight,
          TColors.majorHighlight,
          () {},
          TColors.iconDefault,
          35,
          HugeIcons.strokeRoundedGoogleGemini,
        ),
        accButton(
          60,
          60,
          TColors.backgroundPrimary,
          TColors.buttonDefault,
          () {
            showDialog(context: context, builder: (context) => HowToDialog());
          },
          TColors.textSecondary,
          30,
          HugeIcons.strokeRoundedBubbleChatQuestion,
        ),
        accButton(
          50,
          50,
          TColors.backgroundPrimary,
          TColors.accentDefault,
          () {
            showDialog(
                context: context, builder: (context) => GameRestartDialog());
          },
          TColors.textSecondary,
          24,
          HugeIcons.strokeRoundedClean,
        ),
      ],
    );
  }

  Widget accButton(double h, double w, Color bg, Color border, Function() onTap,
      Color iconColor, double iconSize, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      splashColor: TColors.textSecondary.withValues(alpha: 0.2),
      onTap: onTap,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: border,
            ),
            shape: BoxShape.circle,
            color: Colors.transparent),
        child: Center(
          child: HugeIcon(
            icon: icon,
            color: iconColor,
            size: iconSize,
          ),
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

    final maxMistakes = ref.read(maxMistakesProvider);
    final gameSource = ref.read(gameSourceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            if (gameSource == GameSource.calendar) {
              ref.read(timeProvider.notifier).reset();
              HiveService.clearSavedGame();
            }
            _saveGame();
            ref.read(timeProvider.notifier).stop();
            context.go(Routes.homePage);
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: TColors.iconDefault,
          ),
        ),
        title: Row(
          spacing: 16,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedGoogleGemini,
              size: 24,
              color: TColors.majorHighlight,
            ),
            Text(
              difficultyString,
              style: TextStyle(
                color: TColors.textDefault,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(Routes.settingsPage);
            },
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSetting07,
              size: 30,
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
                (ref.read(switchStateProvider))
                    ? Text(
                        "Mistakes: ${_board.mistakes}/$maxMistakes",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : SizedBox(),
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
              child: _buildAccButtons(selectedRow ?? 0, selectedCol ?? 0),
            ),
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
