import 'package:flutter/material.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class Consttest extends StatefulWidget {
  const Consttest({super.key});

  @override
  State<Consttest> createState() => _ConsttestState();
}

class _ConsttestState extends State<Consttest> {
  @override
  Widget build(BuildContext context) {
    final textStyles = [
      TTextThemes.lightTextTheme.headlineLarge,
      TTextThemes.lightTextTheme.headlineMedium,
      TTextThemes.lightTextTheme.headlineSmall,
      TTextThemes.lightTextTheme.titleLarge,
      TTextThemes.lightTextTheme.titleMedium,
      TTextThemes.lightTextTheme.titleSmall,
      TTextThemes.lightTextTheme.bodyLarge,
      TTextThemes.lightTextTheme.bodyMedium,
      TTextThemes.lightTextTheme.bodySmall,
      TTextThemes.lightTextTheme.labelLarge,
      TTextThemes.lightTextTheme.labelMedium,
    ];

    final colors = [
      TColors.primaryDefault,
      TColors.secondaryDefault,
      TColors.accentDefault,
      TColors.backgroundPrimary,
      TColors.backgroundSecondary,
      TColors.backgroundAccent,
      TColors.textDefault,
      TColors.textSecondary,
      TColors.iconDefault,
      TColors.iconSecondary
    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: textStyles.map((style) {
                return Text(
                  "Testing",
                  style: style,
                );
              }).toList(),
            ),
            Column(
              children: colors.map((colors) {
                return Container(
                  height: 30,
                  color: colors,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
