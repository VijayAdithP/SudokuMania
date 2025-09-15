// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
// import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
// import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
// import 'package:sudokumania/service/hive_service.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';

// class GameRestartDialog extends ConsumerStatefulWidget {
//   const GameRestartDialog({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _GameRestartDialogState();
// }

// class _GameRestartDialogState extends ConsumerState<GameRestartDialog> {
//   GameProgress? lastPlayedGame;

//   Future<void> _loadGameData() async {
//     final gameData = await HiveService.loadGame(); // Wait for data first
//     // log(gameData!.difficulty.toString());
//     setState(() {
//       lastPlayedGame = gameData; // Update UI inside setState
//     });
//   }

//   @override
//   void initState() {
//     _loadGameData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;
//     final textTheme = isLightTheme
//         ? TTextThemes.lightTextTheme
//         : TTextThemes.defaultTextTheme;
//     return Dialog(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 4.5,
//         decoration: BoxDecoration(
// color: isLightTheme ? LColor.dullBackground : TColors.dullBackground,
// borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Still Got a chance",
//                 style: textTheme.headlineMedium,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   "Are you sure you want to restart the game?",
//                   textAlign: TextAlign.center,
//                   style: textTheme.bodyMedium!.copyWith(),
//                 ),
//               ),
//               Expanded(
//                 child: const SizedBox(
//                   height: 15,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   // Create a new board state with no given numbers
//                   if (lastPlayedGame != null) {
//                     List<List<int?>> newBoardState = List.generate(
//                         9,
//                         (i) => List.generate(
//                             9, (j) => lastPlayedGame!.boardState[i][j]));

//                     List<List<bool>> newGivenNumbers =
//                         lastPlayedGame!.givenNumbers;

//                     // Clear only the cells that were marked as given numbers
//                     for (int i = 0; i < 9; i++) {
//                       for (int j = 0; j < 9; j++) {
//                         if (!lastPlayedGame!.givenNumbers[i][j]) {
//                           // If this was a given number, clear it from the board
//                           newBoardState[i][j] = null;
//                         }
//                       }
//                     }
//                     ref.read(timeProvider.notifier).reset();
//                     // Update the saved game with cleared given numbers
//                     await HiveService.saveGame(GameProgress(
//                       boardState: newBoardState,
//                       givenNumbers: newGivenNumbers,
//                       mistakes: 0,
//                       elapsedTime: 0,
//                       difficulty: lastPlayedGame!.difficulty,
//                       lastPlayed: DateTime.now(),
//                     ));

//                     // Set difficulty and navigate to game screen
//                     if (lastPlayedGame!.difficulty == "Easy") {
//                       ref
//                           .read(difficultyProvider.notifier)
//                           .setDifficulty(SudokuDifficulty.easy);
//                     } else if (lastPlayedGame!.difficulty == "Medium") {
//                       ref
//                           .read(difficultyProvider.notifier)
//                           .setDifficulty(SudokuDifficulty.medium);
//                     } else if (lastPlayedGame!.difficulty == "Hard") {
//                       ref
//                           .read(difficultyProvider.notifier)
//                           .setDifficulty(SudokuDifficulty.hard);
//                     } else if (lastPlayedGame!.difficulty == "Nightmare") {
//                       ref
//                           .read(difficultyProvider.notifier)
//                           .setDifficulty(SudokuDifficulty.nightmare);
//                     }

//                     context.push(Routes.gameScreen);
//                   } else if (lastPlayedGame == null) {
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: isLightTheme
//                         ? LColor.primaryDefault
//                         : TColors.primaryDefault,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Center(
//                       child: Text(
//                         "Restart",
//                         style: textTheme.headlineSmall!.copyWith(
//                           color: isLightTheme
//                               ? LColor.buttonDefault
//                               : TColors.buttonDefault.withRed(0),
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class GameRestartDialog extends ConsumerStatefulWidget {
  const GameRestartDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameRestartDialogState();
}

class _GameRestartDialogState extends ConsumerState<GameRestartDialog> {
  GameProgress? lastPlayedGame;

  Future<void> _loadGameData() async {
    final gameData = await HiveService.loadGame();
    setState(() {
      lastPlayedGame = gameData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final dialogPadding = screenWidth * 0.05;
    final buttonPadding = screenWidth * 0.04;
    final spacing = screenWidth * 0.03;
    final borderRadius = 16.0;
    final titleFontSize = screenWidth * 0.05;
    final bodyFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.05;

    return Dialog(
      elevation: 1,
      backgroundColor:
          isLightTheme ? LColor.dullBackground : TColors.dullBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min, //
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Still Got a chance",
              style: textTheme.headlineMedium!.copyWith(
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing),
            Text(
              "Are you sure you want to restart the game?",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                fontSize: bodyFontSize,
              ),
            ),
            SizedBox(height: spacing * 2),
            GestureDetector(
              onTap: () async {
                if (lastPlayedGame != null) {
                  List<List<int?>> newBoardState = List.generate(
                      9,
                      (i) => List.generate(
                          9, (j) => lastPlayedGame!.boardState[i][j]));

                  List<List<bool>> newGivenNumbers =
                      lastPlayedGame!.givenNumbers;

                  for (int i = 0; i < 9; i++) {
                    for (int j = 0; j < 9; j++) {
                      if (!lastPlayedGame!.givenNumbers[i][j]) {
                        newBoardState[i][j] = null;
                      }
                    }
                  }
                  ref.read(timeProvider.notifier).reset();

                  await HiveService.saveGame(GameProgress(
                    boardState: newBoardState,
                    givenNumbers: newGivenNumbers,
                    mistakes: 0,
                    elapsedTime: 0,
                    difficulty: lastPlayedGame!.difficulty,
                    lastPlayed: DateTime.now(),
                  ));

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
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isLightTheme
                      ? LColor.primaryDefault
                      : TColors.primaryDefault,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.all(buttonPadding),
                child: Center(
                  child: Text(
                    "Restart",
                    style: textTheme.headlineSmall!.copyWith(
                      color: isLightTheme
                          ? LColor.buttonDefault
                          : TColors.buttonDefault.withRed(0),
                      fontSize: buttonFontSize,
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
}
