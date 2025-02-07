import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sudokumania/hive_registrar.g.dart';
import 'package:sudokumania/providers/app_startup_provider.dart';
import 'package:sudokumania/providers/online_sync_provider.dart';
import '../theme/theme.dart';
import '../utlis/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  Hive
    ..init(Directory.current.path)
    ..registerAdapters();

  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const SudukoSolver()));
}

class SudukoSolver extends ConsumerWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appStartupProvider); // 🔹 Trigger background sync at startup
    ref.watch(onlineSyncProvider); // 🔹 Listen for network changes
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.defaultTheme,
      themeMode: ThemeMode.system,
    );
  }
}
