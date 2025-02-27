import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
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
              // Row(
              //   spacing: 16,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CircleAvatar(
              //       radius: 30,
              //       backgroundColor: TColors.iconDefault.withValues(alpha: 0.2),
              //       child: HugeIcon(
              //         icon: HugeIcons.strokeRoundedUser,
              //         size: 24,
              //         color: TColors.iconDefault,
              //       ),
              //     ),
              //     Text(
              //       "Log in to sync you data",
              //       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
              //         fontSize: 20,
              //       ),
              //     ),
              //   ],
              // ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                          "Sounds",
                          "on",
                          HugeIcons.strokeRoundedMusicNote01,
                          const Color.fromARGB(255, 230, 123, 116),
                          true,
                          null,
                          ref),
                      seperator(),
                      tiles("Vibtation", "on", HugeIcons.strokeRoundedVoice,
                          Colors.green, true, null, ref),
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
                          "Mistakes Limit",
                          "on",
                          HugeIcons.strokeRoundedCancel01,
                          const Color.fromARGB(255, 230, 123, 116),
                          false,
                          push,
                          ref),
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

  bool test = false;
  Widget tiles(String title, String value, IconData icon, Color iconColor,
      bool isChangable, Function? nav, WidgetRef ref) {
    final selectedMistakes = ref.watch(maxMistakesProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                Switch(
                  activeTrackColor: TColors.iconDefault,
                  inactiveThumbColor: TColors.backgroundSecondary,
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  trackColor: WidgetStatePropertyAll(
                    TColors.majorHighlight,
                  ),
                  value: test,
                  onChanged: (x) {
                    setState(() {
                      test = !test;
                    });
                  },
                ),
              ],
            ),
            if (!isChangable)
              GestureDetector(
                onTap: () => nav != null ? nav() : null,
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
