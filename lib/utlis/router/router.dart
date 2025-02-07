import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/const_test.dart';
import '../../screens/leaderboard.dart';
import '../../screens/history.dart';
import '../../screens/home_screen.dart';
import '../../screens/settings.dart';
import '../../screens/statistics.dart';
import '../../screens/layout/layout.dart';
import '../router/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.homePage,
  routes: [
    GoRoute(
      path: Routes.constTestPage,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => Consttest(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.homePage,
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.leaderboardPage,
              builder: (context, state) => LeaderboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.dailyChallengesPage,
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.statsPage,
              builder: (context, state) => const StatisticsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.settingsPage,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SettingsPage(),
    ),
  ],
);
