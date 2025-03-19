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
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
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
                "Need Help?",
                style: textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "This will redirect you to an external site where you can learn how to play Sudoku",
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
                onTap: _launchUrl,
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
                        "Go to website",
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
            ],
          ),
        ),
      ),
    );
  }
}
