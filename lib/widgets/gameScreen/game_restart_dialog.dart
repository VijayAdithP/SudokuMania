import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class GameRestartDialog extends ConsumerStatefulWidget {
  const GameRestartDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameRestartDialogState();
}

class _GameRestartDialogState extends ConsumerState<GameRestartDialog> {
  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  GameProgress? lastPlayedGame;

  Future<void> _loadGameData() async {
    final gameData = await HiveService.loadGame(); // Wait for data first
    // log(gameData!.difficulty.toString());
    setState(() {
      lastPlayedGame = gameData; // Update UI inside setState
    });
  }

  @override
  void initState() {
    _loadGameData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
        decoration: BoxDecoration(
          color: TColors.dullBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Still Got a chance",
                style: TTextThemes.defaultTextTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Are you sure you want to restart the game?",
                  textAlign: TextAlign.center,
                  style: TTextThemes.defaultTextTheme.bodyMedium!.copyWith(),
                ),
              ),
              Expanded(
                child: const SizedBox(
                  height: 15,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Create a new board state with no given numbers
                  if (lastPlayedGame != null) {
                    List<List<int?>> newBoardState = List.generate(
                        9,
                        (i) => List.generate(
                            9, (j) => lastPlayedGame!.boardState[i][j]));

                    List<List<bool>> newGivenNumbers =
                        lastPlayedGame!.givenNumbers;

                    // Clear only the cells that were marked as given numbers
                    for (int i = 0; i < 9; i++) {
                      for (int j = 0; j < 9; j++) {
                        if (!lastPlayedGame!.givenNumbers[i][j]) {
                          // If this was a given number, clear it from the board
                          newBoardState[i][j] = null;
                        }
                      }
                    }
                    ref.read(timeProvider.notifier).reset();
                    // Update the saved game with cleared given numbers
                    await HiveService.saveGame(GameProgress(
                      boardState: newBoardState,
                      givenNumbers: newGivenNumbers,
                      mistakes: 0,
                      elapsedTime: 0,
                      difficulty: lastPlayedGame!.difficulty,
                      lastPlayed: DateTime.now(),
                    ));

                    // Set difficulty and navigate to game screen
                    if (lastPlayedGame!.difficulty == "Easy") {
                      ref
                          .read(difficultyProvider.notifier)
                          .setDifficulty(SudokuDifficulty.easy);
                    } else if (lastPlayedGame!.difficulty == "Medium") {
                      ref
                          .read(difficultyProvider.notifier)
                          .setDifficulty(SudokuDifficulty.medium);
                    } else if (lastPlayedGame!.difficulty == "Hard") {
                      ref
                          .read(difficultyProvider.notifier)
                          .setDifficulty(SudokuDifficulty.hard);
                    } else if (lastPlayedGame!.difficulty == "Nightmare") {
                      ref
                          .read(difficultyProvider.notifier)
                          .setDifficulty(SudokuDifficulty.nightmare);
                    }

                    context.push(Routes.gameScreen);
                  } else if (lastPlayedGame == null) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: TColors.primaryDefault,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Restart",
                        style: TTextThemes.defaultTextTheme.headlineSmall!
                            .copyWith(
                          color: TColors.buttonDefault.withRed(0),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
