// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
// import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
// import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
// import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
// import 'package:sudokumania/service/firebase_service.dart';
// import 'package:sudokumania/service/hive_service.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';

// class StartButton extends ConsumerStatefulWidget {
//   const StartButton({this.lable = "", super.key});
//   final String lable;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _StartButtonState();
// }

// class _StartButtonState extends ConsumerState<StartButton> {
//   List<String> difficultyLevels = [
//     "Easy",
//     "Medium",
//     "Hard",
//     "Nightmare",
//   ];
//   List<String> difficultyLevelsEmojies = [
//     "😄",
//     "😐",
//     "😥",
//     "😵",
//   ];

//   Future<void> updateStatsForGameStart(String difficulty) async {
//     UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();
//     UserCred? userCred = await HiveService.getUserCred();

//     switch (difficulty) {
//       case "Easy":
//         currentStats = currentStats.copyWith(
//           gamesStarted: currentStats.gamesStarted + 1,
//           easyGamesStarted: currentStats.easyGamesStarted + 1,
//         );
//         break;
//       case "Medium":
//         currentStats = currentStats.copyWith(
//           gamesStarted: currentStats.gamesStarted + 1,
//           mediumGamesStarted: currentStats.mediumGamesStarted + 1,
//         );
//         break;
//       case "Hard":
//         currentStats = currentStats.copyWith(
//           gamesStarted: currentStats.gamesStarted + 1,
//           hardGamesStarted: currentStats.hardGamesStarted + 1,
//         );
//         break;
//       case "Nightmare":
//         currentStats = currentStats.copyWith(
//           gamesStarted: currentStats.gamesStarted + 1,
//           nightmareGamesStarted: currentStats.nightmareGamesStarted + 1,
//         );
//         break;
//     }

//     log("lets see ${currentStats.gamesStarted.toString()}");

//     await HiveService.saveUserStats(currentStats);
//     if (userCred != null) {
//       await FirebaseService.updatePlayerStats(
//           userCred.email!, userCred.displayName!, currentStats);
//     }
//   }

//   void getUserId() async {
//     final username = await HiveService.getUserId();
//     log("Still here $username");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         getUserId();
//         showModalBottomSheet<dynamic>(
//           isScrollControlled: true,
//           useRootNavigator: true,
//           context: context,
//           builder: (BuildContext bc) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: TColors.backgroundPrimary,
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(25.0),
//                   topRight: const Radius.circular(25.0),
//                 ),
//               ),
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewPadding.bottom,
//               ),
//               child: Column(
//                 spacing: 16,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Text(
//                       "New Game",
//                       style:
//                           TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                         color: TColors.buttonDefault.withRed(0),
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: difficultyLevels.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: InkWell(
//                               onTap: () async {
//                                 ref
//                                     .read(difficultyProvider.notifier)
//                                     .setDifficulty(
//                                         SudokuDifficulty.values[index]);
//                                 context.push(Routes.gameScreen);
//                                 ref.read(timeProvider.notifier).reset();
//                                 updateStatsForGameStart(
//                                     difficultyLevels[index]);
//                                 log(difficultyLevels[index]);
//                                 ref.read(gameSourceProvider.notifier).state =
//                                     GameSource.normal;
//                                 Navigator.of(context).pop();
//                                 HiveService.clearSavedGame();
//                               },
//                               child: SizedBox(
//                                 // color: Colors.amber,
//                                 height: 50,
//                                 child: Center(
//                                   child: Row(
//                                     spacing: 8,
//                                     children: [
//                                       Text(
//                                         difficultyLevelsEmojies[index],
//                                         style: TTextThemes
//                                             .defaultTextTheme.headlineSmall!
//                                             .copyWith(
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                       Text(
//                                         difficultyLevels[index],
//                                         style: TTextThemes
//                                             .defaultTextTheme.headlineSmall!
//                                             .copyWith(
//                                           // color:
//                                           //     TColors.buttonDefault.withRed(0),
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           // color: TColors.buttonDefault.withRed(10),
//           color: TColors.primaryDefault,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Text(
//               widget.lable,
//               style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                 color: TColors.buttonDefault.withRed(0),
//                 fontSize: 20,
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
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/firebase_service.dart';
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
    "Hard",
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
    UserCred? userCred = await HiveService.getUserCred();

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
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, currentStats);
    }
  }

  void getUserId() async {
    final username = await HiveService.getUserId();
    log("Still here $username");
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    // Define colors based on the theme
    final buttonColor =
        isLightTheme ? LColor.primaryDefault : TColors.primaryDefault;
    final textColor = isLightTheme
        ? LColor.buttonDefault.withGreen(0)
        : TColors.buttonDefault.withRed(0);
    final diffucultyTextColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault.withRed(0);
    final backgroundColor =
        isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

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
                color: backgroundColor, // Use backgroundColor dynamically
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
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
                      style: textTheme.headlineSmall!.copyWith(
                        color: textColor, // Use textColor dynamically
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                log(difficultyLevels[index]);
                                ref.read(gameSourceProvider.notifier).state =
                                    GameSource.normal;
                                Navigator.of(context).pop();
                                HiveService.clearSavedGame();
                              },
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Text(
                                        difficultyLevelsEmojies[index],
                                        style:
                                            textTheme.headlineSmall!.copyWith(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        difficultyLevels[index],
                                        style:
                                            textTheme.headlineSmall!.copyWith(
                                          color:
                                              diffucultyTextColor, // Use diffucultytextColor
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
          color: buttonColor, // Use buttonColor dynamically
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              widget.lable,
              style: textTheme.headlineSmall!.copyWith(
                color: textColor, // Use textColor dynamically
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
