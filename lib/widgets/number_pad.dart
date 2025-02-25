import 'package:flutter/material.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class NumberPad extends StatefulWidget {
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
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  Widget _buildGridItem(int number) {
    bool isHighlighted =
        widget.isLongPressMode && widget.lockedNumber == number;
    return GestureDetector(
      onTap: () => widget.onNumberTap(number),
      onLongPress: () => widget.onNumberLongPress(number),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color:
              isHighlighted ? TColors.majorHighlight : TColors.dullBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "$number",
            style: TTextThemes.defaultTextTheme.bodyMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.iconDefault.withValues(
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
