import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/providers/gameProgressProviders/gameProgressProviders.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

class GameCompletedscreen extends ConsumerStatefulWidget {
  const GameCompletedscreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameCompletedscreenState();
}

class _GameCompletedscreenState extends ConsumerState<GameCompletedscreen> {
  @override
  void initState() {
    scoreValue();
    _loadGame();
    super.initState();
  }

  int score = 0;

  scoreValue() {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    if (difficulty == "Easy") {
      setState(() {
        score = 100;
      });
    } else if (difficulty == "Medium") {
      setState(() {
        score = 100;
      });
    } else if (difficulty == "Hard") {
      setState(() {
        score = 100;
      });
    } else if (difficulty == "Nightmare") {
      setState(() {
        score = 100;
      });
    }
  }

  void _clearGame() async {
    await HiveService.clearSavedGame();
  }

  int? mistakes;
  Future<void> _loadGame() async {
    var game = await HiveService.loadGame();
    mistakes = game!.mistakes;
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();
    // final minutes = elapsedTime ~/ 60;
    // final seconds = elapsedTime % 60;

    final int totalSeconds = elapsedTime ~/ 1000;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final diffuculty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            // Text("Completed in $minutes:${seconds.toString().padLeft(2, '0')}"),
            // ElevatedButton(
            //   onPressed: () {
            //     context.go(Routes.homePage);
            //   },
            //   child: const Text("Back to Main Menu"),
            // ),
            Text(
              "Your Score!",
              style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 40,
                letterSpacing: 1.5,
                // color: TColors.textSecondary,
              ),
            ),
            Container(
              // height: 80,
              width: MediaQuery.of(context).size.width,
              // color: Colors.blue,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    height: 45,
                    width: 45,
                    "assets/images/trophy.svg",
                  ),
                  Text.rich(
                    TextSpan(
                        text: "+ ",
                        style: TTextThemes.defaultTextTheme.headlineSmall!
                            .copyWith(
                          color: TColors.buttonDefault,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: score.toString(),
                            style: TTextThemes.defaultTextTheme.headlineSmall!
                                .copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: TColors.primaryDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    tiles(
                      "Level",
                      diffuculty,
                      HugeIcons.strokeRoundedStar,
                      TColors.buttonDefault,
                    ),
                    seperator(),
                    tiles(
                      "Time",
                      "$minutes:${seconds.toString().padLeft(2, '0')}",
                      HugeIcons.strokeRoundedClock01,
                      TColors.accentDefault,
                    ),
                    seperator(),
                    tiles(
                      "Best Score",
                      diffuculty,
                      HugeIcons.strokeRoundedAward01,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: TColors.primaryDefault,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    tiles(
                      "Mistakes",
                      mistakes.toString(),
                      HugeIcons.strokeRoundedStar,
                      TColors.buttonDefault,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _clearGame();
                context.go(Routes.homePage);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: TColors.buttonDefault.withRed(10),
                  // color: TColors.primaryDefault,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Main Menu",
                      style:
                          TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                        // color: TColors.buttonDefault.withRed(0),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            StartButton(
              lable: "New Game",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.001,
            ),
          ],
        ),
      ),
    );
  }

  Widget tiles(String title, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                HugeIcon(
                  size: 20,
                  icon: icon,
                  color: iconColor,
                ),
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: TColors.textDefault.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                fontSize: 18,
                letterSpacing: 1.5,
                color: TColors.textDefault.withValues(alpha: 0.8),
              ),
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
