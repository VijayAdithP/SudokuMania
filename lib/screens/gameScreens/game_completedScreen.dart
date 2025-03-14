// import 'dart:developer';

// import 'package:confetti/confetti.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameTimeStateProvider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:sudokumania/widgets/homeScreen/start_game_button.dart';

class GameCompletedscreen extends ConsumerStatefulWidget {
  const GameCompletedscreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameCompletedscreenState();
}

class _GameCompletedscreenState extends ConsumerState<GameCompletedscreen> {
  @override
  void initState() {
    super.initState();
    _checkGameSource();
    _initializeGameData();
  }

  // Future<void> _initializeGameData() async {
  //   await _loadGame();
  //   await scoreValue();
  //   await _saveScore();
  //   // if (gameSorce == GameSource.calendar) {
  //   //   _updateDailyChallenges();
  //   // }
  //   await _updateBestTime();
  //   await _updateGameStreaksAndWonCount();
  //   await _updateWinRate();
  //   await _loadUserStats();
  // }

  Future<void> _initializeGameData() async {
    await _loadGame();
    await scoreValue();
    await _loadUserStats();

    // Load the current stats
    UserStats currentStats = await HiveService.loadUserStats() ?? UserStats();

    // Update stats based on game results
    currentStats = await _updateStats(currentStats);

    // Save the updated stats
    await HiveService.saveUserStats(currentStats);

    // Log the updated stats for debugging
    UserStats? totest = await HiveService.loadUserStats();
    log("Updated totalPoints: ${totest!.totalPoints}");
  }

  UserStats? userDetails;
  int? bestTime;
  int score = 0;
  GameProgress? game;
  GameSource? gameSource;
  double dailyScore = 0;

  // late ConfettiController _confettiController;

  int? mistakes;
  Future<void> _loadGame() async {
    game = await HiveService.loadGame();
    setState(() {
      mistakes = game!.mistakes;
    });
  }

  Future<UserStats> _updateStats(UserStats currentStats) async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    // Update best time
    switch (difficulty) {
      case "Easy":
        if (currentStats.easyBestTime == 0 ||
            elapsedTime < currentStats.easyBestTime) {
          currentStats = currentStats.copyWith(easyBestTime: elapsedTime);
        }
        break;
      case "Medium":
        if (elapsedTime < currentStats.mediumBestTime) {
          currentStats = currentStats.copyWith(mediumBestTime: elapsedTime);
        }
        break;
      case "Hard":
        if (elapsedTime < currentStats.hardBestTime) {
          currentStats = currentStats.copyWith(hardBestTime: elapsedTime);
        }
        break;
      case "Nightmare":
        if (elapsedTime < currentStats.nightmareBestTime) {
          currentStats = currentStats.copyWith(nightmareBestTime: elapsedTime);
        }
        break;
    }

    // Update total points and difficulty-specific points
    switch (difficulty) {
      case 'Easy':
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          easyPoints: currentStats.easyPoints + score,
          easyGamesWon: currentStats.easyGamesWon + 1,
        );
        break;
      case 'Medium':
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          mediumPoints: currentStats.mediumPoints + score,
          mediumGamesWon: currentStats.mediumGamesWon + 1,
        );
        break;
      case 'Hard':
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          hardPoints: currentStats.hardPoints + score,
          hardGamesWon: currentStats.hardGamesWon + 1,
        );
        break;
      case 'Nightmare':
        currentStats = currentStats.copyWith(
          totalPoints: currentStats.totalPoints + score,
          nightmarePoints: currentStats.nightmarePoints + score,
          nightmareGamesWon: currentStats.nightmareGamesWon + 1,
        );
        break;
    }

    // Update game streaks and win count
    currentStats = currentStats.copyWith(
      gamesWon: currentStats.gamesWon + 1,
      longestWinStreak:
          (currentStats.currentWinStreak >= currentStats.longestWinStreak)
              ? currentStats.currentWinStreak
              : currentStats.longestWinStreak,
      currentWinStreak: currentStats.currentWinStreak + 1,
    );

    // Update win rates
    currentStats = currentStats.copyWith(
      easyWinRate: UserStats.calculateWinRate(
          currentStats.easyGamesWon, currentStats.easyGamesStarted),
      mediumWinRate: UserStats.calculateWinRate(
          currentStats.mediumGamesWon, currentStats.mediumGamesStarted),
      hardWinRate: UserStats.calculateWinRate(
          currentStats.hardGamesWon, currentStats.hardGamesStarted),
      nightmareWinRate: UserStats.calculateWinRate(
          currentStats.nightmareGamesWon, currentStats.nightmareGamesStarted),
    );

    return currentStats;
  }

  Future<void> _loadUserStats() async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    final currentElapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    UserStats? userDetails = await HiveService.loadUserStats() ?? UserStats();

    switch (difficulty) {
      case "Easy":
        if (userDetails.easyBestTime == 0 ||
            currentElapsedTime < userDetails.easyBestTime) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            easyBestTime: bestTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.easyBestTime;
          });
        }
        break;
      case "Medium":
        if (currentElapsedTime < (userDetails.mediumBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            mediumBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.mediumBestTime;
          });
        }
        break;
      case "Hard":
        if (currentElapsedTime < (userDetails.hardBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            hardBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.hardBestTime;
          });
        }
        break;
      case "Nightmare":
        if (currentElapsedTime < (userDetails.nightmareBestTime)) {
          setState(() {
            bestTime = currentElapsedTime;
          });
          userDetails = userDetails.copyWith(
            nightmareBestTime: currentElapsedTime,
          );
        } else {
          setState(() {
            bestTime = userDetails!.nightmareBestTime;
          });
        }
        break;
      default:
        setState(() {});
        break;
    }
    _saveBestTime();
    // await FirebaseService.updatePlayerStats(userId, username, stats)
  }

  Future<void> _saveBestTime() async {
    // Load the existing user stats
    UserStats? currentStats = await HiveService.loadUserStats();
    UserCred? userCred = await HiveService.getUserCred();

    // If no stats exist, initialize a new UserStats object
    currentStats ??= UserStats();

    // Update the easyBestTime field using copyWith
    final updatedStats = currentStats.copyWith(
      easyBestTime: bestTime,
    );

    // Save the updated stats back to Hive
    await HiveService.saveUserStats(updatedStats);
    if (userCred != null) {
      await FirebaseService.updatePlayerStats(
          userCred.email!, userCred.displayName!, currentStats);
    }
  }

  void _checkGameSource() {
    gameSource = ref.read(gameSourceProvider);
  }

  Future<void> scoreValue() async {
    final difficulty =
        ref.read(difficultyProvider.notifier).getDifficultyString();
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    int baseScore;
    switch (difficulty) {
      case "Easy":
        baseScore = 100;
        break;
      case "Medium":
        baseScore = 150;
        break;
      case "Hard":
        baseScore = 200;
        break;
      case "Nightmare":
        baseScore = 250;
        break;
      default:
        baseScore = 0;
    }

    final timePenalty = elapsedTime ~/ 1000;
    final calculatedScore = baseScore - timePenalty;

    setState(() {
      score = calculatedScore > 0 ? calculatedScore : 0;
    });
  }

  Future<String> formatTime(int milliseconds) async {
    final int totalSeconds = milliseconds ~/ 1000;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  void _clearGame() async {
    await HiveService.clearSavedGame();
    ref.read(selectedDateProvider.notifier).state =
        null; // Reset the selected date
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = ref.read(timeProvider.notifier).getElapsedTime();

    final int totalSeconds = elapsedTime ~/ 1000;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final diffuculty =
        ref.read(difficultyProvider.notifier).getDifficultyString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              "Your Score!",
              style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 40,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    height: 45,
                    width: 45,
                    "assets/images/trophy.svg",
                  ),
                  Text.rich(
                    TextSpan(
                        text: "+ ",
                        style: TTextThemes.defaultTextTheme.headlineSmall!
                            .copyWith(
                          color: TColors.buttonDefault,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: score.toString(),
                            style: TTextThemes.defaultTextTheme.headlineSmall!
                                .copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: TColors.primaryDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    tiles(
                      "Level",
                      diffuculty,
                      HugeIcons.strokeRoundedStar,
                      TColors.buttonDefault,
                    ),
                    seperator(),
                    tiles(
                      "Time",
                      "$minutes:${seconds.toString().padLeft(2, '0')}",
                      HugeIcons.strokeRoundedClock01,
                      TColors.accentDefault,
                    ),
                    seperator(),
                    FutureBuilder<String>(
                      future: bestTime != null
                          ? formatTime(bestTime!)
                          : Future.value("N/A"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return tiles(
                            "Best Time",
                            "Loading...",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        } else if (snapshot.hasError) {
                          return tiles(
                            "Best Time",
                            "Error",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        } else {
                          return tiles(
                            "Best Time",
                            snapshot.data ?? "N/A",
                            HugeIcons.strokeRoundedAward01,
                            Colors.red,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: TColors.primaryDefault,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          tiles(
                            "Mistakes",
                            mistakes.toString(),
                            HugeIcons.strokeRoundedCancel01,
                            Colors.orange,
                          ),
                          seperator(),
                          tiles(
                            "GenHints",
                            mistakes.toString(),
                            HugeIcons.strokeRoundedGoogleGemini,
                            TColors.majorHighlight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // _updateDailyChallenges();
                _clearGame();
                context.go(Routes.homePage);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: TColors.buttonDefault.withRed(10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Main Menu",
                      style:
                          TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (gameSource != GameSource.calendar)
              StartButton(
                lable: "New Game",
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.001,
            ),
          ],
        ),
      ),
    );
  }

  Widget tiles(String title, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                HugeIcon(
                  size: 20,
                  icon: icon,
                  color: iconColor,
                ),
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: TColors.textDefault.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                fontSize: 18,
                letterSpacing: 1.5,
                color: TColors.textDefault.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget seperator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Divider(
        color: TColors.textSecondary.withValues(
          alpha: 0.3,
        ),
      ),
    );
  }
}
