import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "selection",
              style: TTextThemes.lightTextTheme.headlineLarge!,
            ),
            ElevatedButton(
                onPressed: () {
                  context.push(Routes.settingsPage);
                },
                child: Text(
                  "settings",
                  style: TTextThemes.lightTextTheme.labelLarge!,
                )),
          ],
        ),
      ),
    );
  }
}
