import 'package:flutter/material.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "settings",
          style: TTextThemes.lightTextTheme.headlineLarge!,
        ),
      ),
    );
  }
}
