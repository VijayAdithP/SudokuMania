import 'package:flutter/material.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "History",
          style: TTextThemes.lightTextTheme.headlineLarge!,
        ),
      ),
    );
  }
}
