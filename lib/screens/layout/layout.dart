// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
// import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// import './destinations.dart';

// class LayoutScaffold extends ConsumerWidget {
//   const LayoutScaffold({
//     required this.navigationShell,
//     Key? key,
//   }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

//   final StatefulNavigationShell navigationShell;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;
//     final textTheme = isLightTheme
//         ? TTextThemes.lightTextTheme
//         : TTextThemes.defaultTextTheme;
//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: Theme(
//         data: ThemeData(
//           splashColor: Colors.transparent,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: TColors.textSecondary,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(
//               top: 2,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 topRight: Radius.circular(25),
//               ),
//               child: NavigationBarTheme(
//                 data: NavigationBarThemeData(
//                   backgroundColor: TColors.primaryDefault,
//                   indicatorColor: Colors.transparent,
//                   iconTheme: WidgetStatePropertyAll(
//                     IconThemeData(
//                       color: TColors.iconDefault,
//                       size: 30,
//                     ),
//                   ),
//                   height: MediaQuery.of(context).size.height * 0.08,
//                 ),
//                 child: NavigationBar(
//                   labelBehavior:
//                       NavigationDestinationLabelBehavior.onlyShowSelected,
//                   labelTextStyle: WidgetStatePropertyAll(
//                     TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: TColors.buttonDefault.withRed(0),
//                     ),
//                   ),
//                   selectedIndex: navigationShell.currentIndex,
//                   onDestinationSelected: navigationShell.goBranch,
//                   destinations: destinations
//                       .map((destination) => NavigationDestination(
//                             icon: Icon(
//                               destination.icon,
//                               color: TColors.textSecondary,
//                             ),
//                             label: destination.label,
//                             selectedIcon: Icon(
//                               destination.selectedIcon,
//                               color: TColors.buttonDefault.withRed(0),
//                             ),
//                           ))
//                       .toList(),
//                 ),
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
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';

import './destinations.dart';

class LayoutScaffold extends ConsumerWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    final bottomNavBarColor =
        isLightTheme ? LColor.primaryDefault : TColors.primaryDefault;
    final iconColor = isLightTheme ? LColor.iconDefault : TColors.iconDefault;
    final selectedIconColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault;
    final textColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: textColor,
            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(24),
            //   topRight: Radius.circular(24),
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 2,
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: bottomNavBarColor, // Use bottomNavBarColor
                indicatorColor: Colors.transparent,
                iconTheme: WidgetStatePropertyAll(
                  IconThemeData(
                    color: iconColor, // Use iconColor
                    size: 24,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              child: NavigationBar(

                labelBehavior:
                    // NavigationDestinationLabelBehavior.alwaysHide,
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                labelTextStyle: WidgetStatePropertyAll(

                  TextStyle(
                    fontSize: screenWidth * 0.030,
                    fontWeight: FontWeight.bold,
                    color: selectedIconColor, // Use selectedIconColor
                  ),
                ),
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: navigationShell.goBranch,
                destinations: destinations
                    .map((destination) => NavigationDestination(
                          icon: Icon(
                            destination.icon,
                            color:
                                textColor, // Use textColor for unselected icons
                          ),
                          label: destination.label,
                          selectedIcon: Icon(
                            destination.selectedIcon,
                            color: selectedIconColor, // Use selectedIconColor
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
