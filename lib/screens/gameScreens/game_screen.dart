import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/genContent%20Models/gen_content_model.dart';
import 'package:sudokumania/models/sudokuBoardModels/sudoku_board.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/notifProviders/viberation_provider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/screens/settingsScreen/max_mistakes_screen.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/gameScreen/game_over_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/game_restart_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/hint_sheet.dart';
import 'package:sudokumania/widgets/gameScreen/how_to_dialog.dart';
import 'package:sudokumania/widgets/gameScreen/number_pad.dart';
import 'package:vibration/vibration.dart';

final hintDataProvider = StateProvider<GenContent?>((ref) => null);

class SudokuGamePage extends ConsumerStatefulWidget {
  const SudokuGamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends ConsumerState<SudokuGamePage>
    with SingleTickerProviderStateMixin {
  int? selectedRow;
  int? selectedCol;
  // late Timer _timer;
  // String _timeDisplay = '00:00';
  late SudokuBoard _board;
  bool paused = false;
  final DateTime lastPlayed = DateTime.now();
  final List<Map<String, dynamic>> _moveHistory = [];
  late AnimationController _genButtonController;

  @override
  void initState() {
    super.initState();
    _continueGame();
    _loadBoard();
    _startTimer();
    _saveGame();
    ref.read(timeProvider.notifier).start();
    _genButtonController = AnimationController(
      vsync: this, // 'this' is the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 1500), // Adjust duration
    );
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

  @override
  void dispose() {
    _genButtonController.dispose(); // Important to release resources
    super.dispose();
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
    final maxMistakes = ref.read(maxMistakesProvider);

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
        maxMistakes: maxMistakes,
      );
      _recordMove(selectedRow!, selectedCol!,
          _board.grid[selectedRow!][selectedCol!], isValid);
      if (!isValid) {
        bool vibe = ref.watch(vibeProvider);
        if (vibe) {
          Vibration.vibrate(duration: 200);
        }
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
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
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

                Color cellColor = isLightTheme
                    ? const Color.fromARGB(255, 198, 199, 238)
                    : const Color.fromARGB(255, 51, 46, 72);

                if (isLongPressMode) {
                  // In long press mode, only highlight matching numbers
                  if (_board.grid[row][col] != null &&
                      _board.grid[row][col] == lockedNumber) {
                    cellColor = isLightTheme
                        ? LColor.majorHighlight
                        : TColors.majorHighlight;
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
                    cellColor = isLightTheme
                        ? LColor.majorHighlight
                        : TColors.majorHighlight;
                    // cellColor = TColors.buttonDefault;
                  } else if (hasSameNumber) {
                    cellColor = isLightTheme
                        ? LColor.majorHighlight.withValues(alpha: 0.5)
                        : const Color.fromARGB(255, 51, 46, 72)
                            .withValues(alpha: 0.3);
                  } else if (isInSameRow || isInSameCol || isInSame3x3) {
                    cellColor = isLightTheme
                        ? LColor.buttonDefault.withValues(
                            alpha: 0.3,
                          )
                        : HexColor("#363e79").withValues(
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
                            ? (cellColor ==
                                    (isLightTheme
                                        ? LColor.majorHighlight
                                        : TColors.majorHighlight))
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
                  color: isLightTheme
                      ? Color.fromARGB(56, 51, 46, 72)
                      : Color.fromARGB(180, 51, 46, 72),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: isLightTheme
                              ? LColor.majorHighlight
                              : TColors.majorHighlight,
                        ),
                        color: isLightTheme
                            // ? HexColor("#F2F8FC")
                            ? Colors.transparent
                            : const Color.fromARGB(255, 51, 46, 72),
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
                            color: isLightTheme
                                ? LColor.majorHighlight
                                : TColors.majorHighlight,
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
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final secondaryTextColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;

    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        accButton(
          50,
          50,
          isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
          isLightTheme ? LColor.dullBackground : TColors.dullBackground,
          () {
            _onUndo();
          },
          secondaryTextColor,
          24,
          HugeIcons.strokeRoundedReload,
        ),
        accButton(
          60,
          60,
          isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
          const Color.fromARGB(255, 230, 123, 116),
          () {
            erase(row, col);
          },
          secondaryTextColor,
          30,
          HugeIcons.strokeRoundedEraser,
        ),
        accButton(
          75,
          75,
          isLightTheme ? LColor.majorHighlight : TColors.majorHighlight,
          isLightTheme ? LColor.majorHighlight : TColors.majorHighlight,
          () {
            hintGen(ref);
          },
          isLightTheme ? LColor.iconDefault : TColors.iconDefault,
          35,
          HugeIcons.strokeRoundedGoogleGemini,
          isGen: true,
        ),
        accButton(
          60,
          60,
          isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
          isLightTheme ? LColor.buttonDefault : TColors.buttonDefault,
          () {
            showDialog(context: context, builder: (context) => HowToDialog());
          },
          isLightTheme ? LColor.textSecondary : TColors.textSecondary,
          30,
          HugeIcons.strokeRoundedBubbleChatQuestion,
        ),
        accButton(
          50,
          50,
          isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
          isLightTheme ? LColor.accentDefault : TColors.accentDefault,
          () {
            showDialog(
                context: context, builder: (context) => GameRestartDialog());
          },
          isLightTheme ? LColor.textSecondary : TColors.textSecondary,
          24,
          HugeIcons.strokeRoundedClean,
        ),
      ],
    );
  }

  GenContent genContent = GenContent();

  Future<GenContent> hintGen(WidgetRef ref) async {
    final gemini = Gemini.instance;
    try {
      ref.read(hintLoadingProvider.notifier).state = true;
      final value = await gemini.prompt(
        parts: [
          Part.text(_board.grid.toString()),
          Part.text(
              "This is the data of a sudoko game give me the next best possible move with step by step explanation."),
          Part.text(
              "do not complete the sudoku that is not what i am asking give me the row and col index of the next best cell and the number in it"),
          Part.text("The indexing should be from 0"),
          Part.text(
              "I want you to give me the output is a json format(do not give this '```json' and '```' at the end and start of the output)."),
          Part.text(
              "And the json data should follow this format {explanation(type String): 'content', possible_number(type int): 'content', row(type int) : 'row index', column(type int): 'column index'} "),
          Part.text(
              "The output you are generating will be shown to the user so don't use the index values."),
          Part.text(
              "Finally always put all the infomation that i need such as the row and the column index of the cell at the last indes of the json."),
          Part.text(
              "Do not generate an acknowledgement just simply generate the neccessary content"),
          Part.text(
              "Always follow this format never deviate. Do not ever give me an output that is not in this json format.Plus always be sure that the possible number is the correct number again Do not give me a faulty answer."),
        ],
      );
      setState(() {
        genContent = GenContent.fromJson(jsonDecode(value!.output!));
      });
      ref.read(hintDataProvider.notifier).state = genContent;
      ref.read(hintLoadingProvider.notifier).state = false;
      return genContent;
    } catch (e) {
      // ref.read(hintLoadingProvider.notifier).state = false;
      rethrow;
    }
  }

  Widget accButton(double h, double w, Color bg, Color border, Function() onTap,
      Color iconColor, double iconSize, IconData icon,
      {bool isGen = false}) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    bool isAnimating = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          splashColor: isLightTheme
              ? LColor.textSecondary.withValues(alpha: 0.2)
              : TColors.textSecondary.withValues(alpha: 0.2),
          onTap: () {
            onTap();
            if (isGen && !isAnimating) {
              setState(() {
                ref.read(hintSheetBooleanProvider.notifier).state = true;
                isAnimating = true;
              });

              showModalBottomSheet(
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return HintSheet(
                      genContentFuture: hintGen(ref),
                      fetchHintData: () => hintGen(ref),
                      onCancelPressed: () {
                        ref.read(hintSheetBooleanProvider.notifier).state =
                            false;
                      },
                      onFinishPressed: () {
                        final row = genContent.row!;
                        final col = genContent.column!;
                        final number = genContent.possibleNumber!;

                        if (_board.givenNumbers[row][col]) return;

                        var newInvalidCells = List.generate(
                            9, (i) => List<bool>.from(_board.invalidCells[i]));

                        setState(() {
                          bool isValid = _board.isMoveValid(row, col, number);
                          newInvalidCells[row][col] = !isValid;

                          _board = _board.copyWith(
                            grid: _board.updateGrid(row, col, number),
                            invalidCells: newInvalidCells,
                          );

                          _recordMove(row, col, _board.grid[row][col], isValid);

                          if (!isValid) {
                            bool vibe = ref.watch(vibeProvider);
                            if (vibe) Vibration.vibrate(duration: 200);

                            _board = _board.copyWith(
                              mistakes: _board.mistakes + 1,
                              gameOver:
                                  _board.mistakes + 1 >= _board.maxMistakes,
                            );

                            if (_board.gameOver) _onGameOver();
                          } else if (_board.isSolved()) {
                            _onGameComplete();
                          }
                        });

                        _saveGame();
                        ref.read(hintSheetBooleanProvider.notifier).state =
                            false;
                      },
                    );
                  });

              Future.delayed(2000.ms, () {
                if (mounted) {
                  setState(() {
                    isAnimating = false;
                  });
                }
              });
            }
          },
          child: Container(
            height: h,
            width: w,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: border,
              ),
              shape: BoxShape.circle,
              color: isLightTheme
                  ? LColor.buttonDefault.withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
            child: Center(
              child: isGen
                  ? AnimatedBuilder(
                      animation: AlwaysStoppedAnimation(0.0),
                      builder: (context, child) {
                        return HugeIcon(
                          icon: icon,
                          color: iconColor,
                          size: iconSize,
                        )
                            .animate(
                              autoPlay: isAnimating,
                              onComplete: (controller) {
                                // Animation completed
                              },
                            )
                            .shake(
                              hz: 4,
                              curve: Curves.easeInOutCubic,
                              duration: 600.ms,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1, 1.1),
                              duration: 600.ms,
                            )
                            .then(delay: 300.ms)
                            .scale(
                              begin: const Offset(1, 1.1),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                            );
                      },
                    )
                  : HugeIcon(
                      icon: icon,
                      color: iconColor,
                      size: iconSize,
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

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
    final geminiHint = ref.watch(hintSheetBooleanProvider);

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final itemSize = screenWidth * 0.15;
    final spacing = screenWidth * 0.03;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
              setState(() {
                ref.read(hintSheetBooleanProvider.notifier).state = false;
              });
            },
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 30,
              color: isLightTheme ? LColor.iconDefault : TColors.iconDefault,
            ),
          ),
          title: Row(
            spacing: 16,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedGoogleGemini,
                size: 24,
                color: isLightTheme
                    ? LColor.majorHighlight
                    : TColors.majorHighlight,
              ),
              Text(
                difficultyString,
                style: TextStyle(
                  color:
                      isLightTheme ? LColor.textDefault : TColors.textDefault,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.push(Routes.settingsPage);
              },
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSetting07,
                size: 30,
                color: isLightTheme ? LColor.iconDefault : TColors.iconDefault,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: spacing,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: Text(
                          displayTime,
                          style: TextStyle(
                            color: isLightTheme
                                ? LColor.textDefault
                                : TColors.textDefault,
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      if (!paused)
                        CircleAvatar(
                          backgroundColor: isLightTheme
                              ? LColor.backgroundAccent.withValues(alpha: .2)
                              : TColors.backgroundAccent.withValues(alpha: 0.2),
                          child: IconButton(
                            icon: Icon(
                              Icons.pause,
                              color: isLightTheme
                                  ? LColor.backgroundAccent.withRed(1)
                                  : TColors.backgroundAccent,
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
                            color: isLightTheme
                                ? LColor.textDefault
                                : TColors.textDefault,
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
              if (geminiHint)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Column(),
                ),
            ],
          ),
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
