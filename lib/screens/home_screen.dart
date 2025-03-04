import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/game_progress.dart';
import 'package:sudokumania/providers/type_game_provider.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/continue_button.dart';
import 'package:sudokumania/widgets/start_game_button.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
// final gameDataProvider = FutureProvider.autoDispose<GameProgress?>((ref) async {
//   ref.keepAlive();
//   log("Loading game data from provider");
//   return await HiveService.loadGame();
// });

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  GameProgress? lastPlayedGame;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadGameData();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadGameData();
    });
  }

  Future<void> _loadGameData() async {
    final gameData = await HiveService.loadGame();
    // log("Im loaded");
    // log(gameData!.difficulty.toString());
    if (mounted) {
      setState(() {
        lastPlayedGame = gameData;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     log("Forcing provider refresh on page load");
  //     ref.refresh(gameDataProvider);
  //   });
  // }

  // void _refreshData() {
  //   // Force refresh the provider
  //   // ref.invalidate(gameDataProvider);
  //   ref.refresh(gameDataProvider);
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Subscribe to route changes
  //   final route = ModalRoute.of(context);
  //   if (route is PageRoute) {
  //     routeObserver.subscribe(this, route);
  //   }
  // }

  // @override
  // void didPopNext() {
  //   log("didPopNext called, refreshing data");
  //   // This is called when user returns to this page from another page
  //   _refreshData();
  //   super.didPopNext();
  // }

  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final gameSource = ref.read(gameSourceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            context.push(Routes.settingsPage);
          },
          child: Icon(
            color: TColors.iconDefault,
            size: 30,
            HugeIcons.strokeRoundedSetting07,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                height: 80,
                width: 80,
                opacity: const AlwaysStoppedAnimation(.7),
                "assets/images/sudoku.png",
              ),
              // Positioned(
              //   top: 80,
              //   left: 80,
              //   right: 80,
              //   child: Image.asset(
              //     opacity: const AlwaysStoppedAnimation(.7),
              //     "assets/images/sudoku.png",
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "SUDOKU MANIA",
                    style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                      color: TColors.textDefault,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.end,
                    "By Vijay Adith P",
                    style: TTextThemes.defaultTextTheme.bodySmall!.copyWith(
                      color: TColors.textDefault,
                    ),
                  ),
                ],
              ),
            ],
          )),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                if (lastPlayedGame != null && gameSource != GameSource.calendar)
                  ContinueButton(
                    gameinfo: lastPlayedGame!,
                  )
                else
                  const SizedBox.shrink(),
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
