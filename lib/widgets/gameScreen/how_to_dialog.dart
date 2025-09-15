// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
// import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HowToDialog extends ConsumerStatefulWidget {
//   const HowToDialog({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HowToDialogState();
// }

// class _HowToDialogState extends ConsumerState<HowToDialog> {
//   final Uri _url = Uri.parse(
//       'https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/');

//   Future<void> _launchUrl() async {
//     if (!await launchUrl(_url)) {
//       throw Exception('Could not launch $_url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;
//     final textTheme = isLightTheme
//         ? TTextThemes.lightTextTheme
//         : TTextThemes.defaultTextTheme;

//     // Get screen size for responsiveness
//     final size = MediaQuery.of(context).size;
//     final screenWidth = size.width;
//     final screenHeight = size.height;

//     // Define sizes dynamically
//     final dialogWidth = screenWidth * 0.85;
//     final dialogHeight = screenHeight * 0.3;
//     final borderRadius = dialogWidth * 0.05;
//     final padding = dialogWidth * 0.05;
//     final buttonPadding = dialogWidth * 0.04;
//     final spacing = screenHeight * 0.015;
//     final buttonFontSize = dialogWidth * 0.05;

//     return Dialog(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
//       child: Container(
//         width: dialogWidth,
//         height: dialogHeight,
//         decoration: BoxDecoration(
          // color: isLightTheme ? LColor.dullBackground : TColors.dullBackground,
          // borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(padding),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Need Help?",
//                 style: textTheme.headlineMedium!.copyWith(
//                   fontSize: buttonFontSize * 1.2,
//                 ),
//               ),
//               SizedBox(height: spacing),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: padding * 0.5),
//                 child: Text(
//                   "This will redirect you to an external site where you can learn how to play Sudoku",
//                   textAlign: TextAlign.center,
//                   style: textTheme.bodyMedium!.copyWith(
//                     fontSize: buttonFontSize * 0.8,
//                   ),
//                 ),
//               ),
//               SizedBox(height: spacing * 2),
//               GestureDetector(
//                 onTap: _launchUrl,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: isLightTheme
//                         ? LColor.primaryDefault
//                         : TColors.primaryDefault,
//                     borderRadius: BorderRadius.circular(borderRadius * 0.8),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(buttonPadding),
//                     child: Center(
//                       child: Text(
//                         "Go to website",
//                         style: textTheme.headlineSmall!.copyWith(
//                           color: isLightTheme
//                               ? LColor.buttonDefault
//                               : TColors.buttonDefault.withRed(0),
//                           fontSize: buttonFontSize,
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
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToDialog extends ConsumerStatefulWidget {
  const HowToDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HowToDialogState();
}

class _HowToDialogState extends ConsumerState<HowToDialog> {
  final Uri _url = Uri.parse(
      'https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogPadding = screenWidth * 0.05;
    final buttonFontSize = screenWidth * 0.045;
    final titleFontSize = screenWidth * 0.05;
    final bodyFontSize = screenWidth * 0.04;
    final borderRadius = 16.0;

    return Dialog(
      backgroundColor:   isLightTheme ? LColor.dullBackground : TColors.dullBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink-wrap the content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Need Help?",
              style: textTheme.headlineMedium!.copyWith(
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: dialogPadding * 0.5),
            Text(
              "This will redirect you to an external site where you can learn how to play Sudoku",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                fontSize: bodyFontSize,
              ),
            ),
            SizedBox(height: dialogPadding),
            GestureDetector(
              onTap: _launchUrl,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isLightTheme
                      ? LColor.primaryDefault
                      : TColors.primaryDefault,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.all(dialogPadding * 0.75),
                child: Center(
                  child: Text(
                    "Go to website",
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
