import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/widgets/continue_button.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GameProgress lastPlayedGame = HiveService.loadGame();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(
          color: TColors.iconDefault,
          HugeIcons.strokeRoundedSetting07,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.amber,
              child: Center(
                child: Text(
                  "SUDOKU MANIA",
                  style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      // color: Colors.white,
                      ),
                ),
                FutureBuilder<GameProgress?>(
                  future: HiveService.loadGame(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      GameProgress game = snapshot.data!;
                      return ContinueButton(
                        gameinfo: game,
                      );
                    }

                    return SizedBox();
                  },
                ),
                StartButton(
                  lable: "New Game",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

          // ElevatedButton(
          //     onPressed: () {
          //       context.push(Routes.gameScreen);
          //     },
          //     child: Text(
          //       "Play Game",
          //       style: TTextThemes.lightTextTheme.labelLarge!,
          //     )),