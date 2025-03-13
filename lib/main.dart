import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sudokumania/hive_registrar.g.dart';
import 'package:sudokumania/providers/dataSyncProviders/app_startup_provider.dart';
import 'package:sudokumania/service/noti_services.dart';
import '../theme/theme.dart';
import '../utlis/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

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

  await notiServices.scheduleDailyNotification(
    title: "Daily Reminder",
    body: "Don't forget to play Sudoku today!",
    hour: 23,
    minute: 48,
  );
  runApp(ProviderScope(child: const SudukoSolver()));
}

class SudukoSolver extends ConsumerWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appStartupProvider);
    // ref.watch(onlineSyncProvider);
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.defaultTheme,
      themeMode: ThemeMode.system,
    );
  }
}
