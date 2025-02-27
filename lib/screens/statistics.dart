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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

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
    if (userId != null) {
      _fetchPlayerStats();
    }
  }

  Future<void> _loadUserStats() async {
    final stats = await HiveService.loadUserStats();
    setState(() {
      currentStats = stats;
    });
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

  //  onRefresh: () async {
  //     await _loadUserStats();
  //   },
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       backgroundColor: Colors.transparent,
  //       title: Text(
  //         "Statistics",
  //         style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
  //           fontWeight: FontWeight.normal,
  //         ),
  //       ),
  //     ),
  //     body: currentStats == null
  //         ? Center(child: CircularProgressIndicator())
  //         : SingleChildScrollView(
  //             physics: AlwaysScrollableScrollPhysics(),
  //             child: Padding(
  //               padding: EdgeInsets.all(16.0),
  //               child: SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     InkWell(
  //                       radius: 100,
  //                       child: Text(
  //                         (userName == null)
  //                             ? "Login in to Sync Data"
  //                             : "$userName.toString()",
  //                         style: TTextThemes.defaultTextTheme.headlineSmall!
  //                             .copyWith(
  //                           fontWeight: FontWeight.normal,
  //                           color: TColors.textSecondary,
  //                         ),
  //                       ),
  //                     ),
  //                     Text("Started games: ${currentStats!.gamesStarted}"),
  //                     Text(
  //                         "easy Started games: ${currentStats!.easyGamesStarted}"),
  //                     Text(
  //                         "medium Started games: ${currentStats!.mediumGamesStarted}"),
  //                     Text(
  //                         "hard Started games: ${currentStats!.hardGamesStarted}"),
  //                     Text(
  //                         "nightmare Started games: ${currentStats!.nightmareGamesStarted}"),
  //                     Text("Average Time: ${currentStats!.avgTime}"),
  //                     Text("easy Average Time: ${currentStats!.easyAvgTime}"),
  //                     Text(
  //                         "meditm Average Time: ${currentStats!.mediumAvgTime}"),
  //                     Text("hard Average Time: ${currentStats!.hardAvgTime}"),
  //                     Text(
  //                         "nightmare Average Time: ${currentStats!.nightmareAvgTime}"),
  //                     Text("Best Time: ${currentStats!.bestTime}"),
  //                     Text("easy Best Time: ${currentStats!.easyBestTime}"),
  //                     Text("medium Best Time: ${currentStats!.mediumBestTime}"),
  //                     Text("hard Best Time: ${currentStats!.hardBestTime}"),
  //                     Text(
  //                         "nightmare Best Time: ${currentStats!.nightmareBestTime}"),
  //                     Text("Easy Points: ${currentStats!.easyPoints}"),
  //                     Text("Medium Points: ${currentStats!.mediumPoints}"),
  //                     Text("Hard Points: ${currentStats!.hardPoints}"),
  //                     Text("NightmarePoints: ${currentStats!.nightmarePoints}"),
  //                     Text("Games Won: ${currentStats!.gamesWon}"),
  //                     Text("TotalPoints: ${currentStats!.totalPoints}"),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       backgroundColor: Colors.transparent,
  //       title: Text(
  //         "Statistics",
  //         style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
  //           fontWeight: FontWeight.normal,
  //         ),
  //       ),
  //     ),
  //     body: currentStats == null
  //         ? Center(child: CircularProgressIndicator())
  //         : DefaultTabController(
  //             length: 5,
  //             child: Column(
  //               children: [
  //                 // Login text widget at the top
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: InkWell(
  //                     radius: 100,
  //                     child: Text(
  //                       (userName == null)
  //                           ? "Login in to Sync Data"
  //                           : "$userName.toString()",
  //                       style: TTextThemes.defaultTextTheme.headlineSmall!
  //                           .copyWith(
  //                         fontWeight: FontWeight.normal,
  //                         color: TColors.textSecondary,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // TabBar with five tabs
  //                 TabBar(
  //                   tabs: [
  //                     Tab(text: "Overall"),
  //                     Tab(text: "Easy"),
  //                     Tab(text: "Medium"),
  //                     Tab(text: "Hard"),
  //                     Tab(text: "Nightmare"),
  //                   ],
  //                 ),
  //                 // Expanded TabBarView to display content for each tab
  //                 Expanded(
  //                   child: TabBarView(
  //                     children: [
  //                       // Overall Tab: Display overall statistics
  //                       SingleChildScrollView(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                                 "Started games: ${currentStats!.gamesStarted}"),
  //                             Text("Average Time: ${currentStats!.avgTime}"),
  //                             Text("Best Time: ${currentStats!.bestTime}"),
  //                             Text("Games Won: ${currentStats!.gamesWon}"),
  //                             Text("TotalPoints: ${currentStats!.totalPoints}"),
  //                           ],
  //                         ),
  //                       ),
  //                       // Easy Tab: Display easy-level statistics
  //                       SingleChildScrollView(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                                 "Easy Started games: ${currentStats!.easyGamesStarted}"),
  //                             Text(
  //                                 "Easy Average Time: ${currentStats!.easyAvgTime}"),
  //                             Text(
  //                                 "Easy Best Time: ${currentStats!.easyBestTime}"),
  //                             Text("Easy Points: ${currentStats!.easyPoints}"),
  //                           ],
  //                         ),
  //                       ),
  //                       // Medium Tab: Display medium-level statistics
  //                       SingleChildScrollView(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                                 "Medium Started games: ${currentStats!.mediumGamesStarted}"),
  //                             Text(
  //                                 "Medium Average Time: ${currentStats!.mediumAvgTime}"),
  //                             Text(
  //                                 "Medium Best Time: ${currentStats!.mediumBestTime}"),
  //                             Text(
  //                                 "Medium Points: ${currentStats!.mediumPoints}"),
  //                           ],
  //                         ),
  //                       ),
  //                       // Hard Tab: Display hard-level statistics
  //                       SingleChildScrollView(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                                 "Hard Started games: ${currentStats!.hardGamesStarted}"),
  //                             Text(
  //                                 "Hard Average Time: ${currentStats!.hardAvgTime}"),
  //                             Text(
  //                                 "Hard Best Time: ${currentStats!.hardBestTime}"),
  //                             Text("Hard Points: ${currentStats!.hardPoints}"),
  //                           ],
  //                         ),
  //                       ),
  //                       // Nightmare Tab: Display nightmare-level statistics
  //                       SingleChildScrollView(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                                 "Nightmare Started games: ${currentStats!.nightmareGamesStarted}"),
  //                             Text(
  //                                 "Nightmare Average Time: ${currentStats!.nightmareAvgTime}"),
  //                             Text(
  //                                 "Nightmare Best Time: ${currentStats!.nightmareBestTime}"),
  //                             Text(
  //                                 "Nightmare Points: ${currentStats!.nightmarePoints}"),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        actions: [
          InkWell(
            radius: 50,
            onTap: () async {
              await _loadUserStats();
              setState(() {});
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              color: TColors.iconDefault,
            ),
          )
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
          ? Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    radius: 100,
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
                                  currentStats.avgTime.toString(),
                                  HugeIcons.strokeRoundedTime01,
                                  TColors.buttonDefault,
                                  () {}),
                              seperator(),
                              tiles(
                                  "Overall Best Time",
                                  formatTime(currentStats.avgTime),
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
                                "Win Rate",
                                "${currentStats.winRate}%",
                                Icons.star_rate_rounded,
                                const Color.fromARGB(255, 225, 136, 129),
                                () {},
                              ),
                              seperator(),
                              tiles(
                                  "Longest Winning Streak",
                                  currentStats.longestWinStreak.toString(),
                                  Icons.auto_graph_outlined,
                                  TColors.iconDefault,
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
                                formatTime(getStat('avgTime')),
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
                              seperator(),
                              tiles(
                                " Win Rate",
                                "${getStat('winRate')}%",
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
  // Widget _buildDifficultyTab(
  //   // int gamesStarted,
  //   // String avgTime,
  //   // String bestTime,
  //   // int points,
  //   String diffuclty,
  //   UserStats? currentStats,
  // ) {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               vertical: 16,
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 10),
  //                   child: Text(
  //                     "Game Started",
  //                     style: TTextThemes.defaultTextTheme.headlineMedium,
  //                   ),
  //                 ),
  //                 dullContainer(
  //                   Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             tiles(
  //                                 "Total $diffuclty Games",
  //                                 currentStats!.easyGamesStarted.toString(),
  //                                 HugeIcons.strokeRoundedListView,
  //                                 Colors.green,
  //                                 () {}),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 10),
  //                   child: Text(
  //                     "Time",
  //                     style: TTextThemes.defaultTextTheme.headlineMedium,
  //                   ),
  //                 ),
  //                 dullContainer(
  //                   Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             tiles(
  //                                 "Average Time",
  //                                 currentStats.easyAvgTime.toString(),
  //                                 HugeIcons.strokeRoundedTime01,
  //                                 TColors.buttonDefault,
  //                                 () {}),
  //                             seperator(),
  //                             tiles(
  //                                 "$diffuclty Game Best Time",
  //                                 currentStats.easyBestTime.toString(),
  //                                 HugeIcons.strokeRoundedCrown,
  //                                 TColors.majorHighlight,
  //                                 () {}),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 10),
  //                   child: Text(
  //                     "Score",
  //                     style: TTextThemes.defaultTextTheme.headlineMedium,
  //                   ),
  //                 ),
  //                 dullContainer(
  //                   Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             tiles(
  //                                 "$diffuclty Score",
  //                                 //switch (diffuclty) {
  //                                 //   case "Easy":
  //                                 //       currentStats.easyPoints.toString(),
  //                                 //   case "medium":
  //                                 //       currentStats.easyPoints.toString(),
  //                                 //   case "hard":
  //                                 //       currentStats.easyPoints.toString(),
  //                                 //   case "expert":
  //                                 //       currentStats.easyPoints.toString(),
  //                                 //   case "nightmare":
  //                                 //       currentStats.easyPoints.toString(),

  //                                 // },
  //                                 currentStats.easyPoints.toString(),
  //                                 Icons.score,
  //                                 Colors.lightGreenAccent,
  //                                 () {}),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 10),
  //                   child: Text(
  //                     "Wins",
  //                     style: TTextThemes.defaultTextTheme.headlineMedium,
  //                   ),
  //                 ),
  //                 dullContainer(
  //                   Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             tiles(
  //                                 "$diffuclty Wins",
  //                                 currentStats.easyGamesWon.toString(),
  //                                 Icons.emoji_events_outlined,
  //                                 Colors.green,
  //                                 () {}),
  //                             seperator(),
  //                             tiles(
  //                               "$diffuclty Win Rate",
  //                               "${currentStats.easyWinRate}%",
  //                               Icons.star_rate_rounded,
  //                               const Color.fromARGB(255, 225, 136, 129),
  //                               () {},
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                // Switch(
                //   activeTrackColor: TColors.iconDefault,
                //   inactiveThumbColor: TColors.backgroundSecondary,
                //   trackOutlineColor: const WidgetStatePropertyAll(
                //     Colors.transparent,
                //   ),
                //   trackColor: WidgetStatePropertyAll(
                //     TColors.majorHighlight,
                //   ),
                //   value: test,
                //   onChanged: (x) {
                //     setState(() {
                //       test = !test;
                //     });
                //   },
                // ),
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

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '$title: $value',
        style: TTextThemes.defaultTextTheme.bodyLarge,
      ),
    );
  }
}
