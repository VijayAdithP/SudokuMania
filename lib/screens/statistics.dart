// import 'package:flutter/material.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// class StatisticsPage extends StatefulWidget {
//   const StatisticsPage({super.key});

//   @override
//   State<StatisticsPage> createState() => _StatisticsPageState();
// }

// class _StatisticsPageState extends State<StatisticsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           "Statistics",
//           style: TTextThemes.lightTextTheme.headlineLarge!,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hive_ce/hive.dart';

// class StatisticsPage extends StatefulWidget {
//   @override
//   _StatisticsPageState createState() => _StatisticsPageState();
// }

// class _StatisticsPageState extends State<StatisticsPage> {
//   Map<String, dynamic>? playerStats;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() async {
//     var box = await Hive.openBox('user_data');
//     userId = box.get('user_id');
//     if (userId != null) {
//       _fetchPlayerStats();
//     }
//   }

//   void _fetchPlayerStats() async {
//     var box = await Hive.openBox('player_stats');
//     var localStats = box.get(userId);

//     setState(() {
//       playerStats = localStats;
//     });

//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       if (snapshot.exists) {
//         setState(() {
//           playerStats = snapshot.data() as Map<String, dynamic>?;
//         });
//         box.put(userId, playerStats);
//       }
//     } catch (e) {
//       print("Error fetching stats: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Stats")),
//       body: playerStats == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Username: ${playerStats!['username'] ?? 'N/A'}",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text("Total Points: ${playerStats!['points'] ?? 0}"),
//                   Text("Games Played: ${playerStats!['gamesPlayed'] ?? 0}"),
//                   Text(
//                       "Win Percentage: ${playerStats!['winPercentage'] ?? 0}%"),
//                 ],
//               ),
//             ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, dynamic>? playerStats;
  String? userId;
  String? userName;
  UserStats? currentStats;

  @override
  void initState() {
    super.initState();
    HiveService.saveUserId("testUser123");
    _loadUserStats();
    _loadUserData();
  }

  void _loadUserData() async {
    userId = HiveService.getUserId().toString();
    userName = await HiveService.getUsername();
    final stats = await HiveService.loadUserStats(); // Reload stats from Hive
    setState(() {
      currentStats = stats; // Update the state with the new data
    });
    _fetchPlayerStats(); // Fetch player stats from Firestore
  }

  Future<void> _loadUserStats() async {
    final stats = await HiveService.loadUserStats();
    setState(() {
      currentStats = stats;
    });
  }

  bool _isReloading = false;
  Future<void> _saveUserStats(UserStats stats) async {
    await HiveService.saveUserStats(stats);
  }

  void _fetchPlayerStats() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc("testUser123")
          .get();
      if (snapshot.exists) {
        setState(() {
          playerStats = snapshot.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        actions: [
          // IconButton(
          //   icon: AnimatedSwitcher(
          //     duration: const Duration(seconds: 1),
          //     transitionBuilder: (child, anim) => RotationTransition(
          //       turns: child.key == ValueKey('icon1')
          //           ? Tween<double>(begin: -1, end: 1).animate(anim)
          //           : Tween<double>(begin: 1, end: -1).animate(anim),
          //       child: FadeTransition(opacity: anim, child: child),
          //     ),
          //     child: _currIndex == 0
          //         ? Icon(
          //             HugeIcons.strokeRoundedRefresh,
          //             color: TColors.iconDefault,
          //             key: const ValueKey('icon1'),
          //             size: 20,
          //           )
          //         : Icon(
          //             HugeIcons.strokeRoundedRefresh,
          //             color: TColors.iconDefault,
          //             key: const ValueKey('icon2'),
          //             size: 20,
          //           ),
          //   ),
          //   onPressed: () async {
          //     // setState(() {});
          //     await _loadUserStats();
          //     setState(() {
          //       _currIndex = _currIndex == 0 ? 1 : 0;
          //     });
          //   },
          // ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == ValueKey('icon1')
                    ? Tween<double>(begin: -1, end: 1).animate(anim)
                    : Tween<double>(begin: 1, end: -1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _currIndex == 0
                  ? Icon(
                      HugeIcons.strokeRoundedRefresh,
                      color: TColors.iconDefault,
                      key: const ValueKey('icon1'),
                      size: 20,
                    )
                  : Icon(
                      HugeIcons.strokeRoundedRefresh,
                      color: TColors.iconDefault,
                      key: const ValueKey('icon2'),
                      size: 20,
                    ),
            ),
            onPressed: () async {
              if (_isReloading) return; // Prevent multiple reloads
              setState(() {
                _isReloading = true;
              });

              await _loadUserStats();
              _loadUserData();
              setState(() {
                _currIndex = _currIndex == 0 ? 1 : 0;
                _isReloading = false;
              });
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Statistics",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: currentStats == null
          ? Center(
              child: Text(
                "Initiate a game to access you stats",
                style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: TColors.textSecondary,
                ),
              ),
            )
          : DefaultTabController(
              length: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(Routes.loginScreen);
                    },
                    child: Text(
                      userName == null ? "Login to Sync Data" : "$userName",
                      style:
                          TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: TColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Wrap the TabBar in a Builder
                  Builder(
                    builder: (context) {
                      return TabBar(
                        isScrollable: true,
                        labelColor: TColors.buttonDefault,
                        unselectedLabelColor: TColors.textSecondary,
                        indicatorColor: TColors.accentDefault,
                        labelStyle: TTextThemes.defaultTextTheme.headlineSmall!
                            .copyWith(),
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          Tab(text: 'Overall'),
                          Tab(text: 'Easy'),
                          Tab(text: 'Medium'),
                          Tab(text: 'Hard'),
                          Tab(text: 'Nightmare'),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    // Wrap the TabBarView in a Builder
                    child: Builder(
                      builder: (context) {
                        return TabBarView(
                          children: [
                            // Overall Tab
                            _buildStatsTab(
                              currentStats: currentStats,
                            ),
                            // Easy Tab
                            _buildDifficultyTab(
                              "Easy",
                              currentStats,
                            ),
                            // Medium Tab
                            _buildDifficultyTab(
                              "Medium",
                              currentStats,
                            ),
                            // Hard Tab
                            _buildDifficultyTab(
                              "Hard",
                              currentStats,
                            ),
                            // Nightmare Tab
                            _buildDifficultyTab(
                              "Nightmare",
                              currentStats,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsTab({required UserStats? currentStats}) {
    String formatTime(int milliseconds) {
      final int totalSeconds = milliseconds ~/ 1000;
      final int minutes = (totalSeconds % 3600) ~/ 60;
      final int seconds = totalSeconds % 60;
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }

    // overAllBestTime();
    String overAllBestTime(UserStats currentStats) {
      final List<int?> bestTimes = [
        currentStats.bestTime,
        currentStats.easyBestTime,
        currentStats.mediumBestTime,
        currentStats.hardBestTime,
        currentStats.nightmareBestTime,
      ];
      // Get all the best times in milliseconds

      // Filter out null values and 0 values
      final validTimes =
          bestTimes.where((time) => time != null && time > 0).toList();

      // If no valid times are found, return a default message
      if (validTimes.isEmpty) {
        return "0";
      }

      // Find the minimum time
      final int? minTime = validTimes.reduce((a, b) => a! < b! ? a : b);

      // Convert milliseconds to seconds
      final int totalSeconds = minTime! ~/ 1000;

      // Format the time into minutes and seconds
      final int minutes = (totalSeconds % 3600) ~/ 60;
      final int seconds = totalSeconds % 60;

      // Save the best time to Hive
      // await HiveService.saveUserStats(UserStats(
      //   bestTime: minTime,
      // ));

      log("the best time ${"$minutes:${seconds.toString().padLeft(2, '0')}"}");
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }

    log(currentStats!.currentWinStreak.toString());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Games Started",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                  "Total Games",
                                  currentStats!.gamesStarted.toString(),
                                  HugeIcons.strokeRoundedListView,
                                  Colors.green,
                                  () {}),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Time",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                  "Average Time",
                                  formatTime(
                                    UserStats.calculateAvgTime(
                                      currentStats.totalTime,
                                      currentStats.gamesStarted,
                                    ),
                                  ),
                                  HugeIcons.strokeRoundedTime01,
                                  TColors.buttonDefault,
                                  () {}),
                              seperator(),
                              // FutureBuilder<String>(
                              //   future: overAllBestTime(currentStats),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.waiting) {
                              //       return CircularProgressIndicator(); // Show loading indicator
                              //     } else if (snapshot.hasError) {
                              //       return Text("Error: ${snapshot.error}");
                              //     } else if (snapshot.hasData) {
                              //       return tiles(
                              //         "Overall Best Time",
                              //         snapshot.data!,
                              //         HugeIcons.strokeRoundedCrown,
                              //         TColors.majorHighlight,
                              //         () {},
                              //       );
                              //     } else {
                              //       return Text("No data");
                              //     }
                              //   },
                              // ),
                              tiles(
                                  "Overall Best Time",
                                  // formatTime(currentStats.bestTime),
                                  overAllBestTime(currentStats),
                                  HugeIcons.strokeRoundedCrown,
                                  TColors.majorHighlight,
                                  () {}),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Score",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                  "Total Score",
                                  currentStats.totalPoints.toString(),
                                  Icons.score,
                                  Colors.lightGreenAccent,
                                  () {}),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Wins",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                  "Total Wins",
                                  currentStats.gamesWon.toString(),
                                  Icons.emoji_events_outlined,
                                  Colors.green,
                                  () {}),
                              seperator(),
                              tiles(
                                  "Longest Winning Streak",
                                  currentStats.longestWinStreak.toString(),
                                  Icons.auto_graph_outlined,
                                  TColors.iconDefault,
                                  () {}),
                              seperator(),
                              tiles(
                                  "Current Winning Streak",
                                  currentStats.currentWinStreak.toString(),
                                  HugeIcons.strokeRoundedTickDouble02,
                                  TColors.secondaryDefault,
                                  () {}),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
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

  Widget _buildDifficultyTab(
    String difficulty,
    UserStats? currentStats,
  ) {
    // Ensure currentStats is not null
    if (currentStats == null) {
      return Center(child: Text("No data available"));
    }

    // Helper function to get dynamic stats based on difficulty
    dynamic getStat(String statName) {
      switch (difficulty.toLowerCase()) {
        case 'easy':
          switch (statName) {
            case 'gamesStarted':
              return currentStats.easyGamesStarted;
            case 'avgTime':
              return currentStats.easyAvgTime;
            case 'bestTime':
              return currentStats.easyBestTime;
            case 'points':
              return currentStats.easyPoints;
            case 'gamesWon':
              return currentStats.easyGamesWon;
            case 'winRate':
              return currentStats.easyWinRate;
            case 'totalTime':
              return currentStats.easyTotalTime;
            default:
              return null;
          }
        case 'medium':
          switch (statName) {
            case 'gamesStarted':
              return currentStats.mediumGamesStarted;
            case 'avgTime':
              return currentStats.mediumAvgTime;
            case 'bestTime':
              return currentStats.mediumBestTime;
            case 'points':
              return currentStats.mediumPoints;
            case 'gamesWon':
              return currentStats.mediumGamesWon;
            case 'winRate':
              return currentStats.mediumWinRate;
            case 'totalTime':
              return currentStats.mediumTotalTime;
            default:
              return null;
          }
        case 'hard':
          switch (statName) {
            case 'gamesStarted':
              return currentStats.hardGamesStarted;
            case 'avgTime':
              return currentStats.hardAvgTime;
            case 'bestTime':
              return currentStats.hardBestTime;
            case 'points':
              return currentStats.hardPoints;
            case 'gamesWon':
              return currentStats.hardGamesWon;
            case 'winRate':
              return currentStats.hardWinRate;
            case 'totalTime':
              return currentStats.hardTotalTime;
            default:
              return null;
          }
        case 'nightmare':
          switch (statName) {
            case 'gamesStarted':
              return currentStats.nightmareGamesStarted;
            case 'avgTime':
              return currentStats.nightmareAvgTime;
            case 'bestTime':
              return currentStats.nightmareBestTime;
            case 'points':
              return currentStats.nightmarePoints;
            case 'gamesWon':
              return currentStats.nightmareGamesWon;
            case 'winRate':
              return currentStats.nightmareWinRate;
            case 'totalTime':
              return currentStats.nightmareTotalTime;
            default:
              return null;
          }
        default:
          return null;
      }
    }

    String formatTime(int milliseconds) {
      final int totalSeconds = milliseconds ~/ 1000;
      final int minutes = (totalSeconds % 3600) ~/ 60;
      final int seconds = totalSeconds % 60;
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }

    // Future<String> overAllWinRate(UserStats currentStats) async {
    //   await HiveService.saveUserStats(UserStats(
    //       winRate: UserStats.calculateWinRate(
    //           getStat('gamesWon'), getStat('gamesStarted'))));
    //   return "${UserStats.calculateWinRate(getStat('gamesWon'), getStat('gamesStarted')).toString()}%";
    // }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Game Started",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                "Total Games",
                                getStat('gamesStarted').toString(),
                                HugeIcons.strokeRoundedListView,
                                Colors.green,
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Time",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                "Average Time",
                                formatTime(UserStats.calculateAvgTime(
                                    getStat('totalTime'),
                                    getStat('gamesStarted'))),
                                HugeIcons.strokeRoundedTime01,
                                TColors.buttonDefault,
                                () {},
                              ),
                              seperator(),
                              tiles(
                                "Best Time",
                                formatTime(getStat('bestTime')),
                                HugeIcons.strokeRoundedCrown,
                                TColors.majorHighlight,
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Score",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                "Total Score",
                                getStat('points').toString(),
                                Icons.score,
                                Colors.lightGreenAccent,
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Wins",
                      style: TTextThemes.defaultTextTheme.headlineMedium,
                    ),
                  ),
                  dullContainer(
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              tiles(
                                "Total Wins",
                                getStat('gamesWon').toString(),
                                Icons.emoji_events_outlined,
                                Colors.green,
                                () {},
                              ),
                              // seperator(),
                              // FutureBuilder<String>(
                              //   future: overAllWinRate(currentStats),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.waiting) {
                              //       return CircularProgressIndicator(); // Show loading indicator
                              //     } else if (snapshot.hasError) {
                              //       return Text("Error: ${snapshot.error}");
                              //     } else if (snapshot.hasData) {
                              //       return tiles(
                              //         "Win Rate",
                              //         snapshot.data!,
                              //         HugeIcons.strokeRoundedCrown,
                              //         TColors.majorHighlight,
                              //         () {},
                              //       );
                              //     } else {
                              //       return Text("No data");
                              //     }
                              //   },
                              // )
                              seperator(),
                              tiles(
                                " Win Rate",
                                "${(UserStats.calculateWinRate(getStat('gamesWon'), getStat('gamesStarted'))).toStringAsFixed(1)}%",
                                Icons.star_rate_rounded,
                                const Color.fromARGB(255, 225, 136, 129),
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool test = false;
  Widget tiles(String title, String value, IconData icon, Color iconColor,
      Function? nav) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HugeIcon(
                          size: 24,
                          icon: icon,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
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
          ],
        ),
      ),
    );
  }

  Widget dullContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: TColors.primaryDefault,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
