import 'package:flutter/material.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Statistics",
          style: TTextThemes.lightTextTheme.headlineLarge!,
        ),
      ),
    );
  }
}
