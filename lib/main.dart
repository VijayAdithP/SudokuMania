import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sudokumania/env.dart';
import 'package:sudokumania/hive_registrar.g.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/dataSyncProviders/app_startup_provider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/noti_services.dart';

import '../theme/theme.dart';
import '../utlis/router/router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init(Directory.current.path)
    ..registerAdapters();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// init notif
  final notiServices = NotiServices();
  await notiServices.initNotification();
  await Hive.openBox<ThemePreference>('themeBox');
  await notiServices.scheduleDailyNotification(
    title: "Daily Reminder",
    body: "Don't forget to play Sudoku today!",
    hour: 18,
    minute: 15,
  );
  Gemini.init(apiKey: geminiApiKey);
  runApp(ProviderScope(child: const SudukoSolver()));
}

class SudukoSolver extends ConsumerWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreference = ref.watch(themeProvider);

    ref.watch(appStartupProvider);
    // ref.watch(onlineSyncProvider);
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      debugShowCheckedModeBanner: false,
      theme: themePreference == ThemePreference.light
          ? TAppTheme.lightTheme
          : TAppTheme.defaultTheme,
      themeMode: ThemeMode.system,
    );
  }
}
