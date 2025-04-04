import 'package:flutter/material.dart';
// class DialogFb3 extends StatelessWidget {
//   const DialogFb3({super.key});

//   final primaryColor = const Color(0xff4338CA);
//   final secondaryColor = const Color(0xff6D28D9);
//   final accentColor = const Color(0xffffffff);
//   final backgroundColor = const Color(0xffffffff);
//   final errorColor = const Color(0xffEF4444);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         width: MediaQuery.of(context).size.width / 1.5,
//         height: MediaQuery.of(context).size.height / 5,
//         decoration: BoxDecoration(
//             color: TColors.dullBackground,
//             // gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
//             borderRadius: BorderRadius.circular(15.0),
//             boxShadow: [
//               BoxShadow(
//                   offset: const Offset(12, 26),
//                   blurRadius: 50,
//                   spreadRadius: 0,
//                   color: Colors.grey.withValues(alpha: .1)),
//             ]),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // CircleAvatar(
//             //   backgroundColor: accentColor.withValues(alpha: .05),
//             //   radius: 25,
//             //   // child: HugeIcon(icon: HugeIcons., color: color),
//             //   // child: Image.network(
//             //   //     "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/FlutterBricksLogo-Med.png?alt=media&token=7d03fedc-75b8-44d5-a4be-c1878de7ed52"),
//             // ),

//             Text(
//               "Game Over",
//               style: TTextThemes.defaultTextTheme.headlineMedium,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 "You lost the game because you made mistake",
//                 textAlign: TextAlign.center,
//                 style: TTextThemes.defaultTextTheme.bodyMedium!.copyWith(),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class GameOverDialog extends ConsumerStatefulWidget {
  const GameOverDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends ConsumerState<GameOverDialog> {
  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  GameProgress? lastPlayedGame;

  Future<void> _loadGameData() async {
    UserCred? userCred = await HiveService.getUserCred();

    final gameData = await HiveService.loadGame();
    setState(() {
      lastPlayedGame = gameData;
    });

    UserStats? currentStats = await HiveService.loadUserStats() ?? UserStats();
    final updatedStats = currentStats.copyWith(
      currentWinStreak: 0,
    );
    await HiveService.saveUserStats(updatedStats);
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, updatedStats);
    }
  }

  @override
  void initState() {
    _loadGameData();
    super.initState();
  }

  void _clearGame() async {
    UserCred? userCred = await HiveService.getUserCred();

    await HiveService.clearSavedGame();
    UserStats? currentStats = await HiveService.loadUserStats() ?? UserStats();
    final updatedStats = currentStats.copyWith(
      currentWinStreak: 0,
    );
    await HiveService.saveUserStats(updatedStats);
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, updatedStats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.5,
        decoration: BoxDecoration(
          color: isLightTheme ? LColor.dullBackground : TColors.dullBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Game Over",
                style: textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "You lost the game because you made mistake",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(),
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
                    // _clearGame();
                    context.push(Routes.gameScreen);
                  }
                  UserStats? currentStats =
                      await HiveService.loadUserStats() ?? UserStats();
                  UserCred? userCred = await HiveService.getUserCred();

                  final updatedStats = currentStats.copyWith(
                    currentWinStreak: 0,
                  );
                  await HiveService.saveUserStats(updatedStats);
                  if (userCred != null) {
                    await FirebaseService.updatePlayerStats(
                        userCred.email!, userCred.displayName!, updatedStats);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: isLightTheme
                        ? LColor.primaryDefault
                        : TColors.primaryDefault,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Restart",
                        style: textTheme.headlineSmall!.copyWith(
                          color: isLightTheme
                              ? LColor.buttonDefault
                              : TColors.buttonDefault.withRed(0),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  context.go(Routes.homePage);
                  _clearGame();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: isLightTheme
                        ? LColor.buttonDefault
                        : TColors.buttonDefault.withRed(10),
                    // color: TColors.primaryDefault,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Main Menu",
                        style: textTheme.headlineSmall!.copyWith(
                          color:
                              isLightTheme ? Colors.white : TColors.textDefault,
                          // color: TColors.buttonDefault.withRed(0),
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
