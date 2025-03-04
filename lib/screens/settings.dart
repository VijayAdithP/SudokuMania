import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/providers/daily_challenges_provider.dart';
import 'package:sudokumania/screens/max_mistakes_screen.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           onTap: () => Navigator.pop(context),
//           child: HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowLeft01,
//             size: 24,
//             color: TColors.iconDefault,
//           ),
//         ),
//         title: Text(
//           "Settings",
//           style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             spacing: 16,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Row(
//               //   spacing: 16,
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     CircleAvatar(
//               //       radius: 30,
//               //       backgroundColor: TColors.iconDefault.withValues(alpha: 0.2),
//               //       child: HugeIcon(
//               //         icon: HugeIcons.strokeRoundedUser,
//               //         size: 24,
//               //         color: TColors.iconDefault,
//               //       ),
//               //     ),
//               //     Text(
//               //       "Log in to sync you data",
//               //       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//               //         fontSize: 20,
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               dullContainer(
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       tiles("Sounds", "on", HugeIcons.strokeRoundedMusicNote01,
//                           const Color.fromARGB(255, 230, 123, 116), true, null),
//                       seperator(),
//                       tiles("Vibtation", "on", HugeIcons.strokeRoundedVoice,
//                           Colors.green, true, null),
//                     ],
//                   ),
//                 ),
//               ),
//               dullContainer(
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       tiles(
//                           "Mistakes Limit",
//                           "on",
//                           HugeIcons.strokeRoundedCancel01,
//                           const Color.fromARGB(255, 230, 123, 116),
//                           false,
//                           push),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void push() {
//     context.push(Routes.maxMistakesScreen);
//   }

//   Widget dullContainer(Widget child) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: TColors.primaryDefault,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: child,
//     );
//   }

//   bool test = false;
//   Widget tiles(String title, String value, IconData icon, Color iconColor,
//       bool isChangable, Function? nav) {
//     final selectedMistakes = ref.watch(maxMistakesProvider);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         color: Colors.transparent,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: iconColor.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: HugeIcon(
//                           size: 24,
//                           icon: icon,
//                           color: iconColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       title,
//                       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                         fontSize: 18,
//                         letterSpacing: 1.5,
//                         color: TColors.textDefault.withValues(alpha: 0.8),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Switch(
//                   activeTrackColor: TColors.iconDefault,
//                   inactiveThumbColor: TColors.backgroundSecondary,
//                   trackOutlineColor: const WidgetStatePropertyAll(
//                     Colors.transparent,
//                   ),
//                   trackColor: WidgetStatePropertyAll(
//                     TColors.majorHighlight,
//                   ),
//                   value: test,
//                   onChanged: (x) {
//                     setState(() {
//                       test = !test;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             if (!isChangable)
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 16,
//                 ),
//                 child: GestureDetector(
//                   onTap: () => nav != null ? nav() : null,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Mistakes limit number",
//                         style:
//                             TTextThemes.defaultTextTheme.labelLarge!.copyWith(
//                           fontSize: 15,
//                         ),
//                       ),
//                       HugeIcon(
//                         icon: HugeIcons.strokeRoundedArrowRight01,
//                         size: 24,
//                         color: TColors.iconDefault,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final Map<String, bool> _switchStates = {
    "Sounds": false,
    "Vibration": false,
    "Mistakes Limit": false,
    "Clear Data": false,
    "account": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          radius: 50,
          onTap: () => Navigator.pop(context),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: TColors.iconDefault,
          ),
        ),
        title: Text(
          "Settings",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                          "Sounds",
                          "on",
                          HugeIcons.strokeRoundedMusicNote01,
                          TColors.buttonDefault,
                          true,
                          false,
                          null,
                          ref,
                          _switchStates["Sounds"]!, (value) {
                        setState(() {
                          _switchStates["Sounds"] = value;
                        });
                      }),
                      seperator(),
                      tiles(
                        "Vibtation",
                        "on",
                        HugeIcons.strokeRoundedVoice,
                        Colors.green,
                        true,
                        false,
                        null,
                        ref,
                        _switchStates["Vibration"]!,
                        (value) {
                          setState(() {
                            _switchStates["Vibration"] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // tiles(
                      //     "Mistakes Limit",
                      //     "on",
                      //     HugeIcons.strokeRoundedCancel01,
                      //     const Color.fromARGB(255, 230, 123, 116),
                      //     false,
                      //     false,
                      //     push,
                      //     ref,
                      //     _switchStates["Mistakes Limit"]!, (value) {
                      //   setState(() {
                      //     setState(() {
                      //       ref.read(maxMistakesProvider.notifier).state = 11;
                      //     });
                      //     _switchStates["Mistakes Limit"] = value;
                      //   });
                      // }),
                      tiles(
                        "Mistakes Limit",
                        "on",
                        HugeIcons.strokeRoundedCancel01,
                        const Color.fromARGB(255, 230, 123, 116),
                        !ref.read(switchStateProvider),
                        false,
                        push,
                        ref,
                        ref.watch(switchStateProvider),
                        (value) {
                          setState(() {
                            ref.read(switchStateProvider.notifier).state =
                                value;
                            if (value) {
                              ref.read(maxMistakesProvider.notifier).state = 3;
                            } else {
                              ref.read(maxMistakesProvider.notifier).state =
                                  1000000;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                        "Account",
                        "on",
                        HugeIcons.strokeRoundedUser,
                        TColors.accentDefault,
                        true,
                        true,
                        () => {
                          context.push(Routes.accountDetails),
                        },
                        ref,
                        _switchStates["account"]!,
                        (value) {
                          setState(() {
                            _switchStates["account"] = value;
                          });
                        },
                      ),
                      seperator(),
                      tiles(
                        "Clear Data",
                        "on",
                        HugeIcons.strokeRoundedDelete04,
                        Colors.red,
                        true,
                        true,
                        () => {
                          resetData(),
                        },
                        ref,
                        _switchStates["Clear Data"]!,
                        (value) {
                          setState(() {
                            _switchStates["Clear Data"] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void push() {
    context.push(Routes.maxMistakesScreen);
  }

  Widget dullContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: TColors.primaryDefault,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  resetData() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.8,
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
                    "Reset Data",
                    style: TTextThemes.defaultTextTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Are you sure you want to reset your data?",
                      textAlign: TextAlign.center,
                      style:
                          TTextThemes.defaultTextTheme.bodyMedium!.copyWith(),
                    ),
                  ),
                  Expanded(
                    child: const SizedBox(height: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Hive.deleteFromDisk();
                      Navigator.pop(context);
                      ref.invalidate(dailyChallengeProvider);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 127, 74, 70),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Reset",
                            style: TTextThemes.defaultTextTheme.headlineSmall!
                                .copyWith(
                              color: Colors.red,
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
      },
    );
  }

  bool test = false;
  // Widget tiles(String title, String value, IconData icon, Color iconColor,
  //     bool isChangable, bool isTappable, Function()? nav, WidgetRef ref) {
  //   final selectedMistakes = ref.watch(maxMistakesProvider);

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: GestureDetector(
  //       onTap: nav,
  //       child: Container(
  //         color: Colors.transparent,
  //         width: MediaQuery.of(context).size.width,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: iconColor.withValues(alpha: 0.1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: HugeIcon(
  //                           size: 24,
  //                           icon: icon,
  //                           color: iconColor,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Text(
  //                       title,
  //                       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
  //                         fontSize: 18,
  //                         letterSpacing: 1.5,
  //                         color: TColors.textDefault.withValues(alpha: 0.8),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 if (!isTappable)
  //                   Switch(
  //                     activeTrackColor: TColors.iconDefault,
  //                     inactiveThumbColor: TColors.backgroundSecondary,
  //                     trackOutlineColor: const WidgetStatePropertyAll(
  //                       Colors.transparent,
  //                     ),
  //                     trackColor: WidgetStatePropertyAll(
  //                       TColors.majorHighlight,
  //                     ),
  //                     value: test,
  //                     onChanged: (x) {
  //                       setState(() {
  //                         test = !test;
  //                       });
  //                     },
  //                   ),
  //               ],
  //             ),
  //             if (!isChangable)
  //               GestureDetector(
  //                 onTap: nav,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 16,
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "$selectedMistakes Mistakes limit number",
  //                         style:
  //                             TTextThemes.defaultTextTheme.labelLarge!.copyWith(
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                       HugeIcon(
  //                         icon: HugeIcons.strokeRoundedArrowRight01,
  //                         size: 24,
  //                         color: TColors.iconDefault,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget tiles(
      String title,
      String value,
      IconData icon,
      Color iconColor,
      bool isChangable,
      bool isTappable,
      Function()? nav,
      WidgetRef ref,
      bool switchState,
      Function(bool) onSwitchChanged) {
    final selectedMistakes = ref.watch(maxMistakesProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: nav,
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HugeIcon(
                            size: 24,
                            icon: icon,
                            color: iconColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          letterSpacing: 1.5,
                          color: TColors.textDefault.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  if (isTappable)
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      size: 24,
                      color: TColors.iconDefault,
                    ),
                  if (!isTappable)
                    Switch(
                      activeTrackColor: TColors.iconDefault,
                      inactiveThumbColor: TColors.backgroundSecondary,
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      trackColor: WidgetStatePropertyAll(
                        TColors.majorHighlight,
                      ),
                      value: switchState,
                      onChanged: onSwitchChanged,
                    ),
                ],
              ),
              if (!isChangable)
                GestureDetector(
                  onTap: nav,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$selectedMistakes Mistakes limit number",
                          style:
                              TTextThemes.defaultTextTheme.labelLarge!.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          size: 24,
                          color: TColors.iconDefault,
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
