import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/providers/app_startup_provider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "selection",
//               style: TTextThemes.lightTextTheme.headlineLarge!,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   context.push(Routes.settingsPage);
//                   log("something");
//                 },
//                 child: Text(
//                   "settings",
//                   style: TTextThemes.lightTextTheme.labelLarge!,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "selection",
//               style: TTextThemes.lightTextTheme.headlineLarge!,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   context.push(Routes.settingsPage);
//                   ref.watch(appStartupProvider);
//                   log("something");
//                 },
//                 child: Text(
//                   "settings",
//                   style: TTextThemes.lightTextTheme.labelLarge!,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "selection",
              style: TTextThemes.lightTextTheme.headlineLarge!,
            ),
            ElevatedButton(
                onPressed: () {
                  context.push(Routes.settingsPage);
                  // log("something");
                },
                child: Text(
                  "settings",
                  style: TTextThemes.lightTextTheme.labelLarge!,
                )),
          ],
        ),
      ),
    );
  }
}
