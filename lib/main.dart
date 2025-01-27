import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../theme/theme.dart';
import '../utlis/router/router.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const SudukoSolver());
}

class SudukoSolver extends StatelessWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.defaultTheme,
      themeMode: ThemeMode.system,
    );
  }
}
