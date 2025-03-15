import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class ThemeSelection extends ConsumerStatefulWidget {
  const ThemeSelection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends ConsumerState<ThemeSelection> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          radius: 50,
          onTap: () => Navigator.pop(context),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: isLightTheme ? LColor.iconDefault : TColors.iconDefault,
          ),
        ),
        title: Text(
          "Theme Selection",
          style: (isLightTheme
                  ? TTextThemes.lightTextTheme
                  : TTextThemes.defaultTextTheme)
              .headlineMedium!
              .copyWith(
                fontWeight: FontWeight.normal,
              ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                selectableOption(
                  3,
                  "Default Theme",
                  TColors.primaryDefault,
                  TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  TColors.buttonDefault,
                  ThemePreference.dark,
                ),
                selectableOption(
                  5,
                  "Light Theme",
                  LColor.primaryDefault,
                  TTextThemes.lightTextTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  LColor.darkContrast,
                  ThemePreference.light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectableOption(
    int value,
    String text,
    Color backgroundColor,
    TextStyle textStyle,
    Color iconColor,
    ThemePreference themePreference, // Pass the theme preference
  ) {
    final isSelected = ref.watch(themeProvider) ==
        themePreference; // Check if the theme is selected

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(themeProvider.notifier)
              .toggleTheme(themePreference); // Update the theme
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: textStyle,
              ),
              if (isSelected) // Show the tick icon only if the theme is selected
                HugeIcon(
                  size: 24,
                  icon: HugeIcons.strokeRoundedTick02,
                  color: iconColor,
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
