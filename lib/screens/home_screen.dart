import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/widgets/continue_button.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GameProgress? lastPlayedGame;

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    lastPlayedGame = await HiveService.loadGame();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(),
                ),
                if (lastPlayedGame != null)
                  ContinueButton(
                    gameinfo: lastPlayedGame!,
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
