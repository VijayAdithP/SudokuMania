import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class NumberPad extends ConsumerStatefulWidget {
  final bool isLongPressMode;
  final int? lockedNumber;
  final Function(int) onNumberTap;
  final Function(int) onNumberLongPress;

  const NumberPad({
    required this.onNumberTap,
    required this.onNumberLongPress,
    required this.isLongPressMode,
    required this.lockedNumber,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NumberPadState();
}

class _NumberPadState extends ConsumerState<NumberPad> {
  Widget _buildGridItem(int number, double itemSize, TextStyle textStyle,
      bool isHighlighted, bool isLightTheme) {
    return GestureDetector(
      onTap: () => widget.onNumberTap(number),
      onLongPress: () => widget.onNumberLongPress(number),
      child: Container(
        height: itemSize,
        width: itemSize,
        decoration: BoxDecoration(
          color: isHighlighted
              ? isLightTheme
                  ? LColor.majorHighlight
                  : TColors.majorHighlight
              : isLightTheme
                  ? LColor.buttonDefault.withValues(alpha: 0.3)
                  : TColors.dullBackground,
          borderRadius: BorderRadius.circular(itemSize * 0.2),
        ),
        child: Center(
          child: Text(
            "$number",
            style: textStyle.copyWith(
              fontSize: itemSize * 0.28,
              fontWeight: FontWeight.bold,
              color: isHighlighted
                  ? isLightTheme
                      ? Colors.white
                      : TColors.iconDefault.withValues(alpha: 0.7)
                  : isLightTheme
                      ? LColor.iconDefault.withValues(alpha: 0.7)
                      : TColors.iconDefault.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Define item size relative to screen width
    final itemSize = screenWidth * 0.15;
    final spacing = screenWidth * 0.03;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing * 0.03,
        vertical: spacing * 0.5,
      ),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.center,
        children: List.generate(
          9,
          (index) {
            final number = index + 1;
            final isHighlighted = widget.isLongPressMode && widget.lockedNumber == number;
            return _buildGridItem(number, itemSize, textTheme.bodyMedium!, isHighlighted, isLightTheme);
          },
        ),
      ),
    );
  }
}
