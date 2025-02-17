import 'package:flutter/material.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class ContinueButton extends StatefulWidget {
  final String lable;
  final GameProgress gameinfo;
  const ContinueButton({
    required this.gameinfo,
    this.lable = "",
    super.key,
  });

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: TColors.buttonDefault.withRed(0),
          // color: TColors.primaryDefault,buttonDefault.withRed(0)
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Continue",
                  // widget.gameinfo.difficulty,
                  style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                    color: TColors.textDefault,
                    fontSize: 20,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.gameinfo.difficulty,
                        style:
                            TTextThemes.defaultTextTheme.labelSmall!.copyWith(
                          color: TColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: "-",
                        style:
                            TTextThemes.defaultTextTheme.labelSmall!.copyWith(
                          color: TColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: widget.gameinfo.elapsedTime.toString(),
                        style:
                            TTextThemes.defaultTextTheme.labelSmall!.copyWith(
                          color: TColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
