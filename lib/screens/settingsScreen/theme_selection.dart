import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
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
          "Theme Selection",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
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
                ),
                selectableOption(
                  5,
                  "Light Theme",
                  LColor.primaryDefault,
                  TTextThemes.lightTextTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  LColor.darkContrast,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectableOption(int value, String text, Color backgroundColor,
      TextStyle textStyle, Color iconColor) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: textStyle,
              ),
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
