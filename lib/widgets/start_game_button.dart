// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';

// class StartButton extends StatefulWidget {
//   final String lable;
//   const StartButton({
//     this.lable = "",
//     super.key,
//   });

//   @override
//   State<StartButton> createState() => _StartButtonState();
// }

// List<String> difficultyLevels = [
//   "Easy",
//   "Medium",
//   "hard",
//   "Nightmare",
// ];
// List<String> difficultyLevelsEmojies = [
//   "😄",
//   "😐",
//   "😥",
//   "😵",
// ];

// class _StartButtonState extends State<StartButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         right: 16,
//         left: 16,
//         bottom: 16,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet<dynamic>(
//             isScrollControlled: true,
//             context: context,
//             builder: (BuildContext bc) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: TColors.backgroundPrimary,
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(25.0),
//                     topRight: const Radius.circular(25.0),
//                   ),
//                 ),
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewPadding.bottom,
//                 ),
//                 child: Column(
//                   spacing: 16,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16),
//                       child: Text(
//                         "New Game",
//                         style: TTextThemes.defaultTextTheme.headlineSmall!
//                             .copyWith(
//                           color: TColors.buttonDefault.withRed(0),
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: difficultyLevels.length,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: InkWell(
//                                 onTap: () {
//                                   context.push(Routes.gameScreen);
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: SizedBox(
//                                   // color: Colors.amber,
//                                   height: 50,
//                                   child: Center(
//                                     child: Row(
//                                       spacing: 8,
//                                       children: [
//                                         Text(
//                                           difficultyLevelsEmojies[index],
//                                           style: TTextThemes
//                                               .defaultTextTheme.headlineSmall!
//                                               .copyWith(
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                         Text(
//                                           difficultyLevels[index],
//                                           style: TTextThemes
//                                               .defaultTextTheme.headlineSmall!
//                                               .copyWith(
//                                             // color:
//                                             //     TColors.buttonDefault.withRed(0),
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // if (index != difficultyLevels.length - 1)
//                             //   Padding(
//                             //     padding: const EdgeInsets.symmetric(
//                             //       horizontal: 16,
//                             //     ),
//                             //     child: Divider(
//                             //       thickness: 2,
//                             //       color: TColors.textSecondary,
//                             //     ),
//                             //   )
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             // color: TColors.buttonDefault.withRed(10),
//             color: TColors.primaryDefault,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Text(
//                 widget.lable,
//                 style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                   color: TColors.buttonDefault.withRed(0),
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/providers/gameProgressProviders/gameProgressProviders.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/providers/type_game_provider.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({this.lable = "", super.key});
  final String lable;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  List<String> difficultyLevels = [
    "Easy",
    "Medium",
    "hard",
    "Nightmare",
  ];
  List<String> difficultyLevelsEmojies = [
    "😄",
    "😐",
    "😥",
    "😵",
  ];

  Future<void> updateStatsForGameStart(String difficulty) async {
    UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();

    switch (difficulty) {
      case "Easy":
        currentStats = currentStats.copyWith(
          gamesStarted: currentStats.gamesStarted + 1,
          easyGamesStarted: currentStats.easyGamesStarted + 1,
        );
        break;
      case "Medium":
        currentStats = currentStats.copyWith(
          gamesStarted: currentStats.gamesStarted + 1,
          mediumGamesStarted: currentStats.mediumGamesStarted + 1,
        );
        break;
      case "Hard":
        currentStats = currentStats.copyWith(
          gamesStarted: currentStats.gamesStarted + 1,
          hardGamesStarted: currentStats.hardGamesStarted + 1,
        );
        break;
      case "Nightmare":
        currentStats = currentStats.copyWith(
          gamesStarted: currentStats.gamesStarted + 1,
          nightmareGamesStarted: currentStats.nightmareGamesStarted + 1,
        );
        break;
    }

    log("lets see ${currentStats.gamesStarted.toString()}");

    await HiveService.saveUserStats(currentStats);
  }

  void getUserId() async {
    final username = await HiveService.getUserId();
    log("Still here $username");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getUserId();
        showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          useRootNavigator: true,
          context: context,
          builder: (BuildContext bc) {
            return Container(
              decoration: BoxDecoration(
                color: TColors.backgroundPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "New Game",
                      style:
                          TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                        color: TColors.buttonDefault.withRed(0),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: difficultyLevels.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              onTap: () async {
                                ref
                                    .read(difficultyProvider.notifier)
                                    .setDifficulty(
                                        SudokuDifficulty.values[index]);
                                context.push(Routes.gameScreen);
                                ref.read(timeProvider.notifier).reset();
                                updateStatsForGameStart(
                                    difficultyLevels[index]);
                                ref.read(gameSourceProvider.notifier).state =
                                    GameSource.normal;
                                Navigator.of(context).pop();
                                HiveService.clearSavedGame();
                              },
                              child: SizedBox(
                                // color: Colors.amber,
                                height: 50,
                                child: Center(
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Text(
                                        difficultyLevelsEmojies[index],
                                        style: TTextThemes
                                            .defaultTextTheme.headlineSmall!
                                            .copyWith(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        difficultyLevels[index],
                                        style: TTextThemes
                                            .defaultTextTheme.headlineSmall!
                                            .copyWith(
                                          // color:
                                          //     TColors.buttonDefault.withRed(0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // color: TColors.buttonDefault.withRed(10),
          color: TColors.primaryDefault,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              widget.lable,
              style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                color: TColors.buttonDefault.withRed(0),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
