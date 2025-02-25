import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/continue_button.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final gameDataProvider = FutureProvider.autoDispose<GameProgress?>((ref) async {
  return await HiveService.loadGame();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  GameProgress? lastPlayedGame;

  Future<void> _loadGameData() async {
    final gameData = await HiveService.loadGame(); // Wait for data first
    log(gameData!.difficulty.toString());
    setState(() {
      lastPlayedGame = gameData; // Update UI inside setState
    });
  }

  @override
  void initState() {
    super.initState();
    // Initial load is handled by the provider
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // This is called when user returns to this page from another page
    // Refresh the data
    ref.refresh(gameDataProvider);
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameDataAsync = ref.watch(gameDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            context.push(Routes.settingsPage);
          },
          child: Icon(
            color: TColors.iconDefault,
            HugeIcons.strokeRoundedSetting07,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "SUDOKU MANIA",
                  style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                gameDataAsync.when(
                  data: (gameData) {
                    if (gameData != null) {
                      return ContinueButton(
                        gameinfo: gameData,
                      );
                    }
                    // Return empty container if no saved game
                    return const SizedBox.shrink();
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text('Error: $error'),
                ),
                // if (lastPlayedGame != null)
                //   ContinueButton(
                //     gameinfo: lastPlayedGame!,
                //   ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                    bottom: 16,
                  ),
                  child: StartButton(
                    lable: "New Game",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

// Game progress provider with update functionality
// final gameProgressProvider =
//     StateNotifierProvider<GameProgressNotifier, AsyncValue<GameProgress?>>(
//         (ref) {
//   return GameProgressNotifier();
// });

// class GameProgressNotifier extends StateNotifier<AsyncValue<GameProgress?>> {
//   GameProgressNotifier() : super(const AsyncValue.loading()) {
//     loadGameData();
//   }

//   Future<void> loadGameData() async {
//     state = const AsyncValue.loading();
//     try {
//       final gameProgress = await HiveService.loadGame();
//       state = AsyncValue.data(gameProgress);
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//     }
//   }
// }

// // Updated HomeScreen remains the same as before
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(gameProgressProvider.notifier).loadGameData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gameProgressAsync = ref.watch(gameProgressProvider);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: Icon(
//           color: TColors.iconDefault,
//           HugeIcons.strokeRoundedSetting07,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               child: Center(
//                 child: Text(
//                   "SUDOKU MANIA",
//                   style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
//                     fontSize: 40,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Container(),
//                 ),
                // gameProgressAsync.when(
                //   loading: () => const CircularProgressIndicator(),
                //   error: (error, stack) => Text('Error loading game data'),
                //   data: (gameProgress) => Column(
                //     children: [
                //       if (gameProgress != null)
                //         ContinueButton(
                //           gameinfo: gameProgress,
                //         ),
//                       StartButton(
//                         lable: "New Game",
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
