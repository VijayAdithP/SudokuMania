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

  const NumberPad(
      {required this.onNumberTap,
      required this.onNumberLongPress,
      required this.isLongPressMode,
      required this.lockedNumber,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NumberPadState();
}

class _NumberPadState extends ConsumerState<NumberPad> {
  Widget _buildGridItem(int number) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
    bool isHighlighted =
        widget.isLongPressMode && widget.lockedNumber == number;
    return GestureDetector(
      onTap: () => widget.onNumberTap(number),
      onLongPress: () => widget.onNumberLongPress(number),
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: isHighlighted
              ? isLightTheme
                  ? LColor.majorHighlight
                  : TColors.majorHighlight
              : isLightTheme
                  ? LColor.buttonDefault.withValues(alpha: 0.3)
                  : TColors.dullBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "$number",
            style: textTheme.bodyMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlighted
                  ? isLightTheme
                      ? Colors.white
                      : TColors.iconDefault.withValues(
                          alpha: 0.7,
                        )
                  : isLightTheme
                      ? LColor.iconDefault.withValues(
                          alpha: 0.7,
                        )
                      : TColors.iconDefault.withValues(
                          alpha: 0.7,
                        ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(9, (index) => _buildGridItem(index + 1)),
        ),
      ],
    );
  }
}
