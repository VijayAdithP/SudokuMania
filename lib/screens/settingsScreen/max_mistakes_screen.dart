import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class MaxMistakesScreen extends ConsumerStatefulWidget {
  const MaxMistakesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaxMistakesScreenState();
}

class _MaxMistakesScreenState extends ConsumerState<MaxMistakesScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

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
          "Mistakes Limit",
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: isLightTheme
                    ? LColor.primaryDefault
                    : TColors.primaryDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    selectableOption(3, "3 Mistakes Limit Number"),
                    seperator(),
                    selectableOption(5, "5 Mistakes Limit Number"),
                    seperator(),
                    selectableOption(10, "10 Mistakes Limit Number"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectableOption(int value, String text) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    final selectedMistakes = ref.watch(maxMistakesProvider);
    return InkWell(
      onTap: () {
        setState(() {
          ref.read(maxMistakesProvider.notifier).state = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
            if (selectedMistakes == value)
              HugeIcon(
                size: 24,
                icon: HugeIcons.strokeRoundedTick02,
                color:
                    isLightTheme ? LColor.buttonDefault : TColors.buttonDefault,
              ),
          ],
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

final maxMistakesProvider = StateProvider<int>((ref) => 3);
final switchStateProvider = StateProvider<bool>((ref) => true);
