import 'package:flutter/material.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Leaderboard",
          style: TTextThemes.lightTextTheme.headlineLarge,
        ),
      ),
    );
  }
}
