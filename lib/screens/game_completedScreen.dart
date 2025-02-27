// import 'dart:developer';

// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/providers/gameProgressProviders/gameProgressProviders.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

class GameCompletedscreen extends ConsumerStatefulWidget {
  const GameCompletedscreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameCompletedscreenState();
}

class _GameCompletedscreenState extends ConsumerState<GameCompletedscreen> {
  // @override
  // void initState() {
  //   _loadGame();
  //   _saveScore();
  //   scoreValue();
  //   _loadUserStats();
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    _initializeGameData();
  }

  Future<void> _initializeGameData() async {
    await scoreValue();
    await _saveScore();
    await _loadUserStats();
    await _loadGame();
  }

  UserStats? userDetails;
  int? bestTime;
  int score = 0;
  GameProgress? game;

  // late ConfettiController _confettiController;

  int? mistakes;
  Future<void> _loadGame() async {
    game = await HiveService.loadGame();
    setState(() {
      mistakes = game!.mistakes;
    });
  }

  Future<void> _loadUserStats() async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    final currentElapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    UserStats? userDetails = await HiveService.loadUserStats() ?? UserStats();

    switch (difficulty) {
      case "Easy":
        if (userDetails.easyBestTime == 0 ||
            currentElapsedTime < userDetails.easyBestTime) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            easyBestTime: bestTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.easyBestTime;
          });
        }
        break;
      case "Medium":
        if (currentElapsedTime < (userDetails.mediumBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            mediumBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.mediumBestTime;
          });
        }
        break;
      case "Hard":
        if (currentElapsedTime < (userDetails.hardBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            hardBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.hardBestTime;
          });
        }
        break;
      case "Nightmare":
        if (currentElapsedTime < (userDetails.nightmareBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            nightmareBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.nightmareBestTime;
          });
        }
        break;
      default:
        setState(() {});
        break;
    }
    _saveBestTime();
  }

  Future<void> _saveBestTime() async {
    // Load the existing user stats
    UserStats? currentStats = await HiveService.loadUserStats();

    // If no stats exist, initialize a new UserStats object
    currentStats ??= UserStats();

    // Update the easyBestTime field using copyWith
    final updatedStats = currentStats.copyWith(
      easyBestTime: bestTime,
    );

    // Save the updated stats back to Hive
    await HiveService.saveUserStats(updatedStats);
  }

  Future<void> scoreValue() async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    int baseScore;
    switch (difficulty) {
      case "Easy":
        baseScore = 100;
        break;
      case "Medium":
        baseScore = 150;
        break;
      case "Hard":
        baseScore = 200;
        break;
      case "Nightmare":
        baseScore = 250;
        break;
      default:
        baseScore = 0;
    }

    final timePenalty = elapsedTime ~/ 1000;
    final calculatedScore = baseScore - timePenalty;

    setState(() {
      score = calculatedScore > 0 ? calculatedScore : 0;
    });
  }

  Future<String> formatTime(int milliseconds) async {
    final int totalSeconds = milliseconds ~/ 1000;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> _saveScore() async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();
    switch (difficulty) {
      case "Easy":
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          easyPoints: currentStats.easyPoints + score,
          easyGamesWon: currentStats.easyGamesWon + 1,
          gamesWon: currentStats.gamesWon + 1,
        );
        break;
      case "Medium":
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          mediumPoints: currentStats.mediumPoints + score,
          mediumGamesWon: currentStats.mediumGamesWon + 1,
          gamesWon: currentStats.gamesWon + 1,
        );
        break;
      case "Hard":
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          hardPoints: currentStats.hardPoints + score,
          hardGamesWon: currentStats.hardGamesWon + 1,
          gamesWon: currentStats.gamesWon + 1,
        );
        break;
      case "Nightmare":
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          nightmarePoints: currentStats.nightmarePoints + score,
          nightmareGamesWon: currentStats.nightmareGamesWon + 1,
          gamesWon: currentStats.gamesWon + 1,
        );
        break;
    }
    await HiveService.saveUserStats(currentStats);
  }

  void _clearGame() async {
    await HiveService.clearSavedGame();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
    // final minutes = elapsedTime ~/ 60;
    // final seconds = elapsedTime % 60;

    final int totalSeconds = elapsedTime ~/ 1000;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final diffuculty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            // Text("Completed in $minutes:${seconds.toString().padLeft(2, '0')}"),
            // ElevatedButton(
            //   onPressed: () {
            //     context.go(Routes.homePage);
            //   },
            //   child: const Text("Back to Main Menu"),
            // ),
            Text(
              "Your Score!",
              style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 40,
                letterSpacing: 1.5,
                // color: TColors.textSecondary,
              ),
            ),
            Container(
              // height: 80,
              width: MediaQuery.of(context).size.width,
              // color: Colors.blue,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    height: 45,
                    width: 45,
                    "assets/images/trophy.svg",
                  ),
                  Text.rich(
                    TextSpan(
                        text: "+ ",
                        style: TTextThemes.defaultTextTheme.headlineSmall!
                            .copyWith(
                          color: TColors.buttonDefault,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: score.toString(),
                            style: TTextThemes.defaultTextTheme.headlineSmall!
                                .copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: TColors.primaryDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    tiles(
                      "Level",
                      diffuculty,
                      HugeIcons.strokeRoundedStar,
                      TColors.buttonDefault,
                    ),
                    seperator(),
                    tiles(
                      "Time",
                      "$minutes:${seconds.toString().padLeft(2, '0')}",
                      HugeIcons.strokeRoundedClock01,
                      TColors.accentDefault,
                    ),
                    seperator(),
                    // tiles(
                    //   "Best Time",
                    //   formatTime(bestTime!),
                    //   // "filler",
                    //   HugeIcons.strokeRoundedAward01,
                    //   Colors.red,
                    // ),
                    FutureBuilder<String>(
                      future: bestTime != null
                          ? formatTime(bestTime!)
                          : Future.value("N/A"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return tiles(
                            "Best Time",
                            "Loading...",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        } else if (snapshot.hasError) {
                          return tiles(
                            "Best Time",
                            "Error",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        } else {
                          return tiles(
                            "Best Time",
                            snapshot.data ?? "N/A",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: TColors.primaryDefault,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          tiles(
                            "Mistakes",
                            mistakes.toString(),
                            HugeIcons.strokeRoundedCancel01,
                            Colors.orange,
                          ),
                          seperator(),
                          tiles(
                            "GenHints",
                            mistakes.toString(),
                            HugeIcons.strokeRoundedGoogleGemini,
                            TColors.majorHighlight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _clearGame();
                context.go(Routes.homePage);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: TColors.buttonDefault.withRed(10),
                  // color: TColors.primaryDefault,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Main Menu",
                      style:
                          TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                        // color: TColors.buttonDefault.withRed(0),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            StartButton(
              lable: "New Game",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.001,
            ),
          ],
        ),
      ),
    );
  }

  Widget tiles(String title, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                HugeIcon(
                  size: 20,
                  icon: icon,
                  color: iconColor,
                ),
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: TColors.textDefault.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                fontSize: 18,
                letterSpacing: 1.5,
                color: TColors.textDefault.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget seperator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Divider(
        color: TColors.textSecondary.withValues(
          alpha: 0.3,
        ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/game_progress.dart';
// import 'package:sudokumania/models/user_stats.dart';
// import 'package:sudokumania/providers/gameProgressProviders/gameProgressProviders.dart';
// import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
// import 'package:sudokumania/service/hive_service.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';
// import 'package:sudokumania/widgets/start_game_button.dart';

// class GameCompletedscreen extends ConsumerStatefulWidget {
//   const GameCompletedscreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _GameCompletedscreenState();
// }

// class _GameCompletedscreenState extends ConsumerState<GameCompletedscreen> {
//   @override
//   void initState() {
//     _loadGame();
//     // scoreValue();
//     _loadUserStats();
//     // _saveScore();
//     _confettiController =
//         ConfettiController(duration: const Duration(seconds: 1));
//     _confettiController.play();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }

//   // UserStats? userDetails;
//   String? bestTime;
//   int score = 0;
//   GameProgress? game;
//   late ConfettiController _confettiController;

//   Future<void> _loadUserStats() async {
//     final difficulty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();

//     try {
//       final currentElapsedTime =
//           ref.read(timeProvider.notifier).getElapsedTime();
//       UserStats? userDetails = await HiveService.loadUserStats();
//       switch (difficulty) {
//         case "Easy":
//           if (userDetails?.easyBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.easyBestTime ?? double.infinity)) {
//             setState(() {
//               bestTime = currentElapsedTime.toString();
//             });
//             userDetails = userDetails!.copyWith(
//               easyBestTime: currentElapsedTime,
//             );
//           } else {
//             setState(() {
//               bestTime = userDetails!.easyBestTime.toString();
//             });
//           }
//           break;
//         case "Medium":
//           if (userDetails?.mediumBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.mediumBestTime ?? double.infinity)) {
//             setState(() {
//               bestTime = currentElapsedTime.toString();
//             });
//             userDetails = userDetails!.copyWith(
//               mediumBestTime: currentElapsedTime,
//             );
//           } else {
//             setState(() {
//               bestTime = userDetails!.mediumBestTime.toString();
//             });
//           }
//           break;
//         case "Hard":
//           if (userDetails?.hardBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.hardBestTime ?? double.infinity)) {
//             setState(() {
//               bestTime = currentElapsedTime.toString();
//             });
//             userDetails = userDetails!.copyWith(
//               hardBestTime: currentElapsedTime,
//             );
//           } else {
//             setState(() {
//               bestTime = userDetails!.hardBestTime.toString();
//             });
//           }
//           break;
//         case "Nightmare":
//           if (userDetails?.nightmareBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.nightmareBestTime ?? double.infinity)) {
//             setState(() {
//               bestTime = currentElapsedTime.toString();
//             });
//             userDetails = userDetails!.copyWith(
//               nightmareBestTime: currentElapsedTime,
//             );
//           } else {
//             setState(() {
//               bestTime = userDetails!.nightmareBestTime.toString();
//             });
//           }
//           break;
//         default:
//           // Handle default case if necessary
//           break;
//       }
//       await HiveService.saveUserStats(userDetails!);
//     } catch (e) {
//       debugPrint("Error loading user stats: $e");
//     }
//   }

//   scoreValue() {
//     final difficulty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();
//     final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
//     final mistakes = game!.mistakes;

//     int baseScore;
//     switch (difficulty) {
//       case "Easy":
//         baseScore = 100;
//         break;
//       case "Medium":
//         baseScore = 150;
//         break;
//       case "Hard":
//         baseScore = 200;
//         break;
//       case "Nightmare":
//         baseScore = 250;
//         break;
//       default:
//         baseScore = 0;
//     }

//     final timePenalty = elapsedTime ~/ 1000;
//     final mistakePenalty = mistakes * 10;
//     final calculatedScore = baseScore - timePenalty - mistakePenalty;

//     setState(() {
//       score = calculatedScore > 0 ? calculatedScore : 0;
//     });
//   }

//   String formatTime(int milliseconds) {
//     final int totalSeconds = milliseconds ~/ 1000;
//     final int minutes = (totalSeconds % 3600) ~/ 60;
//     final int seconds = totalSeconds % 60;
//     return "$minutes:${seconds.toString().padLeft(2, '0')}";
//   }

//   Future<void> _saveScore() async {
//     final difficulty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();
//     UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();
//     switch (difficulty) {
//       case "Easy":
//         currentStats = currentStats.copyWith(
//           totalPoints: currentStats.totalPoints + score,
//           easyPoints: currentStats.easyPoints + score,
//           easyGamesWon: currentStats.easyGamesWon + 1,
//           gamesWon: currentStats.gamesWon + 1,
//         );
//         break;
//       case "Medium":
//         currentStats = currentStats.copyWith(
//           totalPoints: currentStats.totalPoints + score,
//           mediumPoints: currentStats.mediumPoints + score,
//           mediumGamesWon: currentStats.mediumGamesWon + 1,
//           gamesWon: currentStats.gamesWon + 1,
//         );
//         break;
//       case "Hard":
//         currentStats = currentStats.copyWith(
//           totalPoints: currentStats.totalPoints + score,
//           hardPoints: currentStats.hardPoints + score,
//           hardGamesWon: currentStats.hardGamesWon + 1,
//           gamesWon: currentStats.gamesWon + 1,
//         );
//         break;
//       case "Nightmare":
//         currentStats = currentStats.copyWith(
//           totalPoints: currentStats.totalPoints + score,
//           nightmarePoints: currentStats.nightmarePoints + score,
//           nightmareGamesWon: currentStats.nightmareGamesWon + 1,
//           gamesWon: currentStats.gamesWon + 1,
//         );
//         break;
//     }

//     await HiveService.saveUserStats(currentStats);
//   }

//   void _clearGame() async {
//     await HiveService.clearSavedGame();
//   }

//   int? mistakes;
//   Future<void> _loadGame() async {
//     log("Pls work ${mistakes.toString()}");
//     game = await HiveService.loadGame();
//     setState(() {
//       mistakes = game!.mistakes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
//     // final minutes = elapsedTime ~/ 60;
//     // final seconds = elapsedTime % 60;

//     final int totalSeconds = elapsedTime ~/ 1000;
//     final int minutes = (totalSeconds % 3600) ~/ 60;
//     final int seconds = totalSeconds % 60;

//     final diffuculty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 20,
//           horizontal: 16,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           spacing: 16,
//           children: [
//             Text(
//               "Your Score!",
//               style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
//                 fontWeight: FontWeight.normal,
//                 fontSize: 40,
//                 letterSpacing: 1.5,
//                 // color: TColors.textSecondary,
//               ),
//             ),
//             Stack(
//               children: [
//                 Container(
//                   // height: 80,
//                   width: MediaQuery.of(context).size.width,
//                   // color: Colors.blue,
//                   child: Row(
//                     spacing: 10,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         height: 45,
//                         width: 45,
//                         "assets/images/trophy.svg",
//                       ),
//                       Text.rich(
//                         TextSpan(
//                             text: "+ ",
//                             style: TTextThemes.defaultTextTheme.headlineSmall!
//                                 .copyWith(
//                               color: TColors.buttonDefault,
//                               fontWeight: FontWeight.normal,
//                               fontSize: 20,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: score.toString(),
//                                 style: TTextThemes
//                                     .defaultTextTheme.headlineSmall!
//                                     .copyWith(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 20,
//                                 ),
//                               )
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: 200,
//                   top: 0,
//                   child: ConfettiWidget(
//                     confettiController: _confettiController,
//                     blastDirectionality: BlastDirectionality.explosive,
//                     shouldLoop: true,
//                     colors: const [
//                       Colors.red,
//                       Colors.blue,
//                       Colors.green,
//                       Colors.yellow,
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: TColors.primaryDefault,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Column(
//                   children: [
//                     tiles(
//                       "Level",
//                       diffuculty,
//                       HugeIcons.strokeRoundedStar,
//                       TColors.buttonDefault,
//                     ),
//                     seperator(),
//                     tiles(
//                       "Time",
//                       "$minutes:${seconds.toString().padLeft(2, '0')}",
//                       HugeIcons.strokeRoundedClock01,
//                       TColors.accentDefault,
//                     ),
//                     seperator(),
//                     // tiles(
//                     //   "Best Time",
//                     //   bestTime ?? "null",
//                     //   HugeIcons.strokeRoundedAward01,
//                     //   Colors.red,
//                     // ),
//                     tiles(
//                       "Best Time",
//                       bestTime != null
//                           ? formatTime(int.parse(bestTime!))
//                           : "N/A",
//                       HugeIcons.strokeRoundedAward01,
//                       Colors.red,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: TColors.primaryDefault,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Column(
//                         children: [
//                           tiles(
//                             "Mistakes",
//                             mistakes.toString(),
//                             HugeIcons.strokeRoundedCancel01,
//                             Colors.orange,
//                           ),
//                           seperator(),
//                           tiles(
//                             "GenHints",
//                             mistakes.toString(),
//                             HugeIcons.strokeRoundedGoogleGemini,
//                             TColors.majorHighlight,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 _clearGame();
//                 context.go(Routes.homePage);
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: TColors.buttonDefault.withRed(10),
//                   // color: TColors.primaryDefault,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Center(
//                     child: Text(
//                       "Main Menu",
//                       style:
//                           TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                         // color: TColors.buttonDefault.withRed(0),
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             StartButton(
//               lable: "New Game",
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.001,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget tiles(String title, String value, IconData icon, Color iconColor) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         color: Colors.transparent,
//         width: MediaQuery.of(context).size.width,
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               spacing: 20,
//               children: [
//                 HugeIcon(
//                   size: 20,
//                   icon: icon,
//                   color: iconColor,
//                 ),
//                 Text(
//                   textAlign: TextAlign.center,
//                   title,
//                   style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                     fontSize: 18,
//                     letterSpacing: 1.5,
//                     color: TColors.textDefault.withValues(alpha: 0.8),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               value,
//               textAlign: TextAlign.center,
//               style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                 fontSize: 18,
//                 letterSpacing: 1.5,
//                 color: TColors.textDefault.withValues(alpha: 0.8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget seperator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Divider(
//         color: TColors.textSecondary.withValues(
//           alpha: 0.3,
//         ),
//       ),
//     );
//   }
// }

// class GameCompletedscreen extends ConsumerStatefulWidget {
//   const GameCompletedscreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _GameCompletedscreenState();
// }

// class _GameCompletedscreenState extends ConsumerState<GameCompletedscreen> {
//   @override
//   void initState() {
//     _loadGame();
//     scoreValue();
//     _loadUserStats();
//     _saveScore();
//     _confettiController =
//         ConfettiController(duration: const Duration(seconds: 1));
//     _confettiController.play();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }

//   String? bestTime;
//   int score = 0;
//   GameProgress? game;
//   late ConfettiController _confettiController;
//   int? mistakes;

//   Future<void> _loadUserStats() async {
//     try {
//       final difficulty =
//           ref.read(difficultyProvider.notifier).getDifficultyString();
//       UserStats? userDetails = await HiveService.loadUserStats();

//       // Get the current elapsed time from the game
//       final currentElapsedTime = game!.elapsedTime;

//       switch (difficulty) {
//         case "Easy":
//           if (userDetails?.easyBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.easyBestTime ?? double.infinity)) {
//             bestTime = currentElapsedTime.toString();
//           } else {
//             bestTime = userDetails!.easyBestTime.toString();
//           }
//           break;
//         case "Medium":
//           if (userDetails?.mediumBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.mediumBestTime ?? double.infinity)) {
//             bestTime = currentElapsedTime.toString();
//           } else {
//             bestTime = userDetails!.mediumBestTime.toString();
//           }
//           break;
//         case "Hard":
//           if (userDetails?.hardBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.hardBestTime ?? double.infinity)) {
//             bestTime = currentElapsedTime.toString();
//           } else {
//             bestTime = userDetails!.hardBestTime.toString();
//           }
//           break;
//         case "Nightmare":
//           if (userDetails?.nightmareBestTime == null ||
//               currentElapsedTime <
//                   (userDetails?.nightmareBestTime ?? double.infinity)) {
//             bestTime = currentElapsedTime.toString();
//           } else {
//             bestTime = userDetails!.nightmareBestTime.toString();
//           }
//           break;
//         default:
//           // Handle default case if necessary
//           break;
//       }
//     } catch (e) {
//       debugPrint("Error loading user stats: $e");
//     }
//   }

//   void scoreValue() {
//     final difficulty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();
//     final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

//     int baseScore;
//     switch (difficulty) {
//       case "Easy":
//         baseScore = 100;
//         break;
//       case "Medium":
//         baseScore = 150;
//         break;
//       case "Hard":
//         baseScore = 200;
//         break;
//       case "Nightmare":
//         baseScore = 250;
//         break;
//       default:
//         baseScore = 0;
//     }

//     // Adjust score based on time and mistakes
//     final timePenalty = elapsedTime ~/ 1000; // Penalize longer times
//     final mistakePenalty = mistakes! * 10; // Penalize mistakes
//     final calculatedScore = baseScore - timePenalty - mistakePenalty;

//     setState(() {
//       score = calculatedScore > 0
//           ? calculatedScore
//           : 0; // Ensure score is not negative
//     });
//   }

//   String formatTime(int milliseconds) {
//     final int totalSeconds = milliseconds ~/ 1000;
//     final int minutes = (totalSeconds % 3600) ~/ 60;
//     final int seconds = totalSeconds % 60;
//     return "$minutes:${seconds.toString().padLeft(2, '0')}";
//   }

//   Future<void> _saveScore() async {
//     try {
//       final difficulty =
//           ref.read(difficultyProvider.notifier).getDifficultyString();
//       UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();
//       switch (difficulty) {
//         case "Easy":
//           currentStats = currentStats.copyWith(
//             totalPoints: currentStats.totalPoints + score,
//             easyPoints: currentStats.easyPoints + score,
//             easyGamesWon: currentStats.easyGamesWon + 1,
//           );
//           break;
//         case "Medium":
//           currentStats = currentStats.copyWith(
//             totalPoints: currentStats.totalPoints + score,
//             mediumPoints: currentStats.mediumPoints + score,
//             mediumGamesWon: currentStats.mediumGamesWon + 1,
//           );
//           break;
//         case "Hard":
//           currentStats = currentStats.copyWith(
//             totalPoints: currentStats.totalPoints + score,
//             hardPoints: currentStats.hardPoints + score,
//             hardGamesWon: currentStats.hardGamesWon + 1,
//           );
//           break;
//         case "Nightmare":
//           currentStats = currentStats.copyWith(
//             totalPoints: currentStats.totalPoints + score,
//             nightmarePoints: currentStats.nightmarePoints + score,
//             nightmareGamesWon: currentStats.nightmareGamesWon + 1,
//           );
//           break;
//       }
//       await HiveService.saveUserStats(currentStats);
//     } catch (e) {
//       debugPrint("Error saving score: $e");
//     }
//   }

//   void _clearGame() async {
//     await HiveService.clearSavedGame();
//   }

//   Future<void> _loadGame() async {
//     try {
//       game = await HiveService.loadGame();
//       setState(() {
//         mistakes = game!.mistakes ?? 0;
//       });
//     } catch (e) {
//       debugPrint("Error loading game: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
//     final int totalSeconds = elapsedTime ~/ 1000;
//     final int minutes = (totalSeconds % 3600) ~/ 60;
//     final int seconds = totalSeconds % 60;

//     final diffuculty =
//         ref.read(difficultyProvider.notifier).getDifficultyString();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 20,
//           horizontal: 16,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           spacing: 16,
//           children: [
//             Text(
//               "Your Score!",
//               style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
//                 fontWeight: FontWeight.normal,
//                 fontSize: 40,
//                 letterSpacing: 1.5,
//               ),
//             ),
//             Stack(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     spacing: 10,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         height: 45,
//                         width: 45,
//                         "assets/images/trophy.svg",
//                       ),
//                       Text.rich(
//                         TextSpan(
//                             text: "+ ",
//                             style: TTextThemes.defaultTextTheme.headlineSmall!
//                                 .copyWith(
//                               color: TColors.buttonDefault,
//                               fontWeight: FontWeight.normal,
//                               fontSize: 20,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: score.toString(),
//                                 style: TTextThemes
//                                     .defaultTextTheme.headlineSmall!
//                                     .copyWith(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 20,
//                                 ),
//                               )
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ConfettiWidget(
//                   confettiController: _confettiController,
//                   blastDirectionality: BlastDirectionality.explosive,
//                   shouldLoop: true,
//                   colors: const [Colors.red, Colors.blue, Colors.green],
//                 ),
//               ],
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: TColors.primaryDefault,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Column(
//                   children: [
//                     tiles(
//                       "Level",
//                       diffuculty,
//                       HugeIcons.strokeRoundedStar,
//                       TColors.buttonDefault,
//                     ),
//                     seperator(),
//                     tiles(
//                       "Time",
//                       "$minutes:${seconds.toString().padLeft(2, '0')}",
//                       HugeIcons.strokeRoundedClock01,
//                       TColors.accentDefault,
//                     ),
//                     seperator(),
//                     tiles(
//                       "Best Time",
//                       bestTime != null
//                           ? formatTime(int.parse(bestTime!))
//                           : "N/A",
//                       HugeIcons.strokeRoundedAward01,
//                       Colors.red,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: TColors.primaryDefault,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Column(
//                         children: [
//                           // tiles(
//                           //   "Mistakes",
//                           //   mistakes.toString(),
//                           //   HugeIcons.strokeRoundedCancel01,
//                           //   Colors.orange,
//                           // ),
//                           tiles(
//                             "Mistakes",
//                             (mistakes ?? 0)
//                                 .toString(), // Default to 0 if mistakes is null
//                             HugeIcons.strokeRoundedCancel01,
//                             Colors.orange,
//                           ),
//                           seperator(),
//                           tiles(
//                             "GenHints",
//                             mistakes.toString(),
//                             HugeIcons.strokeRoundedGoogleGemini,
//                             TColors.majorHighlight,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 _clearGame();
//                 context.go(Routes.homePage);
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: TColors.buttonDefault.withRed(10),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Center(
//                     child: Text(
//                       "Main Menu",
//                       style:
//                           TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             StartButton(
//               lable: "New Game",
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.001,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget tiles(String title, String value, IconData icon, Color iconColor) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         color: Colors.transparent,
//         width: MediaQuery.of(context).size.width,
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               spacing: 20,
//               children: [
//                 HugeIcon(
//                   size: 20,
//                   icon: icon,
//                   color: iconColor,
//                 ),
//                 Text(
//                   textAlign: TextAlign.center,
//                   title,
//                   style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                     fontSize: 18,
//                     letterSpacing: 1.5,
//                     color: TColors.textDefault.withValues(alpha: 0.8),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               value,
//               textAlign: TextAlign.center,
//               style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                 fontSize: 18,
//                 letterSpacing: 1.5,
//                 color: TColors.textDefault.withValues(alpha: 0.8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget seperator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Divider(
//         color: TColors.textSecondary.withValues(
//           alpha: 0.3,
//         ),
//       ),
//     );
//   }
// }
