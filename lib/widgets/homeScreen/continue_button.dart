// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:sudokumania/constants/colors.dart';
// // import 'package:sudokumania/models/game_progress.dart';
// // import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// // class ContinueButton extends StatefulWidget {
// //   final String lable;
// //   final GameProgress gameinfo;
// //   const ContinueButton({
// //     required this.gameinfo,
// //     this.lable = "",
// //     super.key,
// //   });

// //   @override
// //   State<ContinueButton> createState() => _ContinueButtonState();
// // }

// // class _ContinueButtonState extends State<ContinueButton> {
// //   @override
// //   Widget build(BuildContext context) {
// //     log("${widget.gameinfo.elapsedTime.toString()} is the time");
// //     return Padding(
// //       padding: const EdgeInsets.only(
// //         right: 16,
// //         left: 16,
// //         bottom: 16,
// //       ),
// //       child: GestureDetector(
// //         child: Container(
// //           width: MediaQuery.of(context).size.width,
// //           decoration: BoxDecoration(
// //             color: TColors.buttonDefault.withRed(0),
// //             // color: TColors.primaryDefault,buttonDefault.withRed(0)
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Center(
// //               child: Column(
// //                 children: [
// //                   Text(
// //                     "Continue",
// //                     // widget.gameinfo.difficulty,
// //                     style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
// //                       color: TColors.textDefault,
// //                       fontSize: 20,
// //                     ),
// //                   ),
// //                   Text.rich(
// //                     TextSpan(
// //                       children: [
// //                         TextSpan(
// //                           text: widget.gameinfo.difficulty,
// //                           style:
// //                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
// //                             color: TColors.textSecondary,
// //                           ),
// //                         ),
// //                         TextSpan(
// //                           text: "-",
// //                           style:
// //                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
// //                             color: TColors.textSecondary,
// //                           ),
// //                         ),
// //                         TextSpan(
// //                           text: widget.gameinfo.formattedTime,
// //                           style:
// //                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
// //                             color: TColors.textSecondary,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
// import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
// import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';

// class ContinueButton extends ConsumerStatefulWidget {
//   final String lable;
//   final GameProgress gameinfo;
//   const ContinueButton({
//     required this.gameinfo,
//     this.lable = "",
//     super.key,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ContinueButtonState();
// }

// class _ContinueButtonState extends ConsumerState<ContinueButton> {
//   @override
//   Widget build(BuildContext context) {
//     log("${widget.gameinfo.elapsedTime.toString()} is the time");
//     return Padding(
//       padding: const EdgeInsets.only(
//         right: 16,
//         left: 16,
//         bottom: 16,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           ref.read(gameSourceProvider.notifier).state = GameSource.normal;
//           if (widget.gameinfo.difficulty == "Easy") {
//             ref
//                 .read(difficultyProvider.notifier)
//                 .setDifficulty(SudokuDifficulty.easy);
//             context.push(Routes.gameScreen);
//           }
//           if (widget.gameinfo.difficulty == "Medium") {
//             ref
//                 .read(difficultyProvider.notifier)
//                 .setDifficulty(SudokuDifficulty.medium);
//             context.push(Routes.gameScreen);
//           }
//           if (widget.gameinfo.difficulty == "Hard") {
//             ref
//                 .read(difficultyProvider.notifier)
//                 .setDifficulty(SudokuDifficulty.hard);
//             context.push(Routes.gameScreen);
//           }
//           if (widget.gameinfo.difficulty == "Nightmare") {
//             ref
//                 .read(difficultyProvider.notifier)
//                 .setDifficulty(SudokuDifficulty.nightmare);
//             context.push(Routes.gameScreen);
//           }
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             color: TColors.buttonDefault.withRed(0),
//             // color: TColors.primaryDefault,buttonDefault.withRed(0)
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Column(
//                 children: [
//                   Text(
//                     "Continue",
//                     // widget.gameinfo.difficulty,
//                     style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                       color: TColors.textDefault,
//                       fontSize: 20,
//                     ),
//                   ),
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.gameinfo.difficulty,
//                           style:
//                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
//                             color: TColors.textSecondary,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "-",
//                           style:
//                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
//                             color: TColors.textSecondary,
//                           ),
//                         ),
//                         TextSpan(
//                           text: widget.gameinfo.formattedTime,
//                           style:
//                               TTextThemes.defaultTextTheme.labelSmall!.copyWith(
//                             color: TColors.textSecondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
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
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class ContinueButton extends ConsumerStatefulWidget {
  final String lable;
  final GameProgress gameinfo;
  const ContinueButton({
    required this.gameinfo,
    this.lable = "",
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends ConsumerState<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    // Define colors based on the theme
    final buttonColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault.withRed(0);
    final textColor = isLightTheme ? LColor.textDefault : TColors.textDefault;
    final secondaryTextColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: () {
          ref.read(gameSourceProvider.notifier).state = GameSource.normal;
          if (widget.gameinfo.difficulty == "Easy") {
            ref
                .read(difficultyProvider.notifier)
                .setDifficulty(SudokuDifficulty.easy);
            context.push(Routes.gameScreen);
          }
          if (widget.gameinfo.difficulty == "Medium") {
            ref
                .read(difficultyProvider.notifier)
                .setDifficulty(SudokuDifficulty.medium);
            context.push(Routes.gameScreen);
          }
          if (widget.gameinfo.difficulty == "Hard") {
            ref
                .read(difficultyProvider.notifier)
                .setDifficulty(SudokuDifficulty.hard);
            context.push(Routes.gameScreen);
          }
          if (widget.gameinfo.difficulty == "Nightmare") {
            ref
                .read(difficultyProvider.notifier)
                .setDifficulty(SudokuDifficulty.nightmare);
            context.push(Routes.gameScreen);
          }
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
              child: Column(
                children: [
                  Text(
                    "Continue",
                    style: textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.gameinfo.difficulty,
                          style: textTheme.labelSmall!.copyWith(
                            color: secondaryTextColor, // Use secondaryTextColor
                          ),
                        ),
                        TextSpan(
                          text: "-",
                          style: textTheme.labelSmall!.copyWith(
                            color: secondaryTextColor, // Use secondaryTextColor
                          ),
                        ),
                        TextSpan(
                          text: widget.gameinfo.formattedTime,
                          style: textTheme.labelSmall!.copyWith(
                            color: secondaryTextColor, // Use secondaryTextColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
