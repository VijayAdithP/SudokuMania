import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sudokumania/hive_registrar.g.dart';
import '../theme/theme.dart';
import '../utlis/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  Hive
    ..init(Directory.current.path)
    ..registerAdapters();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SudukoSolver());
}

class SudukoSolver extends StatelessWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.defaultTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
