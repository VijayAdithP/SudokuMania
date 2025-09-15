import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/homeScreen/continue_button.dart';
import 'package:sudokumania/widgets/homeScreen/start_game_button.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  GameProgress? lastPlayedGame;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadGameData();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadGameData();
    });
  }

  Future<void> _loadGameData() async {
    final gameData = await HiveService.loadGame();

    if (mounted) {
      setState(() {
        lastPlayedGame = gameData;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    // Define colors based on the theme
    final iconColor = isLightTheme ? LColor.iconDefault : TColors.iconDefault;
    final textColor = isLightTheme ? LColor.textDefault : TColors.textDefault;
    final backgroundColor =
        isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    final gameSource = ref.read(gameSourceProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            context.push(Routes.settingsPage);
          },
          child: Icon(
            color: iconColor, 
            size: 30,
            HugeIcons.strokeRoundedSetting07,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: 80,
                  width: 80,
                  opacity: const AlwaysStoppedAnimation(.7),
                  "assets/images/sudoku.png",
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "SUDOKU MANIA",
                      style: textTheme.headlineLarge!.copyWith(
                        color: textColor, // Set text color dynamically
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.end,
                      "By Vijay Adith P",
                      style: textTheme.bodySmall!.copyWith(
                        color: textColor, // Set text color dynamically
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                if (lastPlayedGame != null && gameSource != GameSource.calendar)
                  ContinueButton(
                    gameinfo: lastPlayedGame!,
                  )
                else
                  const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                    bottom: 16,
                  ),
                  child: StartButton(
                    lable: "New Game",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
