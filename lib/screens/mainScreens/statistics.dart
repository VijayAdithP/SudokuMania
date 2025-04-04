// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
// import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
// import 'package:sudokumania/service/hive_service.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';

// class StatisticsPage extends ConsumerStatefulWidget {
//   const StatisticsPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _StatisticsPageState();
// }

// class _StatisticsPageState extends ConsumerState<StatisticsPage>
//     with SingleTickerProviderStateMixin {
//   Map<String, dynamic>? playerStats;
//   String? userId;
//   String? userName;
//   UserStats? currentStats;
//   UserCred? userCred;
//   late TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 5, vsync: this);
//     _loadUserData();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose(); // Dispose TabController
//     super.dispose();
//   }

//   void _loadUserData() async {
//     UserCred? userCred = await HiveService.getUserCred();
//     if (userCred != null) {
//       userId = userCred.email;
//       userName = userCred.displayName;
//       _fetchPlayerStats(); // Fetch player stats from Firestore
//     } else {
//       userCred = null;
//     }

//     final stats = await HiveService.loadUserStats(); // Reload stats from Hive
//     // setState(() {
//     //   currentStats = stats; // Update the state with the new data
//     // });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         currentStats = stats;
//       });
//     });
//   }

//   Future<void> _loadUserStats() async {
//     UserCred? userCred = await HiveService.getUserCred();
//     final stats = await HiveService.loadUserStats();
//     setState(() {
//       currentStats = stats;
//     });
//   }

//   bool _isReloading = false;
//   Timer? _timer;

//   void _fetchPlayerStats() async {
//     userCred = await HiveService.getUserCred();
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCred!.email)
//           .get();
//       if (snapshot.exists) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           setState(() {
//             playerStats = snapshot.data() as Map<String, dynamic>?;
//           });
//         });
//       }
//     } catch (e) {
//       print("Error fetching stats: $e");
//     }
//   }

//   int _currIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actionsPadding: EdgeInsets.symmetric(
//           horizontal: 16,
//         ),
//         actions: [
//           IconButton(
//             icon: AnimatedSwitcher(
//               duration: const Duration(seconds: 1),
//               transitionBuilder: (child, anim) => RotationTransition(
//                 turns: child.key == ValueKey('icon1')
//                     ? Tween<double>(begin: -1, end: 1).animate(anim)
//                     : Tween<double>(begin: 1, end: -1).animate(anim),
//                 child: FadeTransition(opacity: anim, child: child),
//               ),
//               child: _currIndex == 0
//                   ? Icon(
//                       HugeIcons.strokeRoundedRefresh,
//                       color: TColors.iconDefault,
//                       key: const ValueKey('icon1'),
//                       size: 20,
//                     )
//                   : Icon(
//                       HugeIcons.strokeRoundedRefresh,
//                       color: TColors.iconDefault,
//                       key: const ValueKey('icon2'),
//                       size: 20,
//                     ),
//             ),
//             onPressed: () async {
//               if (_isReloading) return; // Prevent multiple reloads
//               setState(() {
//                 _isReloading = true;
//               });

//               await _loadUserStats();
//               _loadUserData();
//               setState(() {
//                 _currIndex = _currIndex == 0 ? 1 : 0;
//                 _isReloading = false;
//               });
//             },
//           ),
//         ],
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           "Statistics",
//           style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ),
//       body: currentStats == null
//           ? Center(
//               child: Text(
//                 "Initiate a game to access you stats",
//                 style: TTextThemes.defaultTextTheme.headlineSmall!.copyWith(
//                   fontWeight: FontWeight.normal,
//                   color: TColors.textSecondary,
//                 ),
//               ),
//             )
//           : DefaultTabController(
//               length: 5,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       userCred == null
//                           ? context.push(Routes.loginScreen)
//                           : null;
//                     },
//                     child: Text(
//                       userCred == null ? "Login to Sync Data" : userName!,
//                       style: userCred == null
//                           ? TTextThemes.defaultTextTheme.headlineSmall!
//                               .copyWith(
//                               fontWeight: FontWeight.normal,
//                               color: TColors.textSecondary,
//                             )
//                           : TTextThemes.defaultTextTheme.headlineLarge!
//                               .copyWith(
//                               fontWeight: FontWeight.normal,
//                               color: TColors.buttonDefault,
//                             ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   // Wrap the TabBar in a Builder
//                   TabBar(
//                     isScrollable: true,
//                     labelColor: TColors.buttonDefault,
//                     unselectedLabelColor: TColors.textSecondary,
//                     indicatorColor: TColors.accentDefault,
//                     labelStyle:
//                         TTextThemes.defaultTextTheme.headlineSmall!.copyWith(),
//                     tabAlignment: TabAlignment.start,
//                     tabs: [
//                       Tab(text: 'Overall'),
//                       Tab(text: 'Easy'),
//                       Tab(text: 'Medium'),
//                       Tab(text: 'Hard'),
//                       Tab(text: 'Nightmare'),
//                     ],
//                   ),
//                   Expanded(
//                     // Wrap the TabBarView in a Builder
//                     child: TabBarView(
//                       children: [
//                         // Overall Tab
//                         _buildStatsTab(
//                           currentStats: currentStats,
//                         ),
//                         // Easy Tab
//                         _buildDifficultyTab(
//                           "Easy",
//                           currentStats,
//                         ),
//                         // Medium Tab
//                         _buildDifficultyTab(
//                           "Medium",
//                           currentStats,
//                         ),
//                         // Hard Tab
//                         _buildDifficultyTab(
//                           "Hard",
//                           currentStats,
//                         ),
//                         // Nightmare Tab
//                         _buildDifficultyTab(
//                           "Nightmare",
//                           currentStats,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatsTab({required UserStats? currentStats}) {
//     String formatTime(int milliseconds) {
//       final int totalSeconds = milliseconds ~/ 1000;
//       final int minutes = (totalSeconds % 3600) ~/ 60;
//       final int seconds = totalSeconds % 60;
//       return "$minutes:${seconds.toString().padLeft(2, '0')}";
//     }

//     // overAllBestTime();
//     String overAllBestTime(UserStats currentStats) {
//       final List<int?> bestTimes = [
//         currentStats.bestTime,
//         currentStats.easyBestTime,
//         currentStats.mediumBestTime,
//         currentStats.hardBestTime,
//         currentStats.nightmareBestTime,
//       ];
//       // Get all the best times in milliseconds

//       // Filter out null values and 0 values
//       final validTimes =
//           bestTimes.where((time) => time != null && time > 0).toList();

//       // If no valid times are found, return a default message
//       if (validTimes.isEmpty) {
//         return "0";
//       }

//       // Find the minimum time
//       final int? minTime = validTimes.reduce((a, b) => a! < b! ? a : b);

//       // Convert milliseconds to seconds
//       final int totalSeconds = minTime! ~/ 1000;

//       // Format the time into minutes and seconds
//       final int minutes = (totalSeconds % 3600) ~/ 60;
//       final int seconds = totalSeconds % 60;

//       // Save the best time to Hive
//       // await HiveService.saveUserStats(UserStats(
//       //   bestTime: minTime,
//       // ));

//       // log("the best time ${"$minutes:${seconds.toString().padLeft(2, '0')}"}");
//       return "$minutes:${seconds.toString().padLeft(2, '0')}";
//     }

//     // log(currentStats!.currentWinStreak.toString());
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 16,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Text(
//                       "Games Started",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                   "Total Games",
//                                   currentStats!.gamesStarted.toString(),
//                                   HugeIcons.strokeRoundedListView,
//                                   Colors.green,
//                                   () {}),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Time",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                   "Average Time",
//                                   formatTime(
//                                     UserStats.calculateAvgTime(
//                                       currentStats.totalTime,
//                                       currentStats.gamesStarted,
//                                     ),
//                                   ),
//                                   HugeIcons.strokeRoundedTime01,
//                                   TColors.buttonDefault,
//                                   () {}),
//                               seperator(),
//                               // FutureBuilder<String>(
//                               //   future: overAllBestTime(currentStats),
//                               //   builder: (context, snapshot) {
//                               //     if (snapshot.connectionState ==
//                               //         ConnectionState.waiting) {
//                               //       return CircularProgressIndicator(); // Show loading indicator
//                               //     } else if (snapshot.hasError) {
//                               //       return Text("Error: ${snapshot.error}");
//                               //     } else if (snapshot.hasData) {
//                               //       return tiles(
//                               //         "Overall Best Time",
//                               //         snapshot.data!,
//                               //         HugeIcons.strokeRoundedCrown,
//                               //         TColors.majorHighlight,
//                               //         () {},
//                               //       );
//                               //     } else {
//                               //       return Text("No data");
//                               //     }
//                               //   },
//                               // ),
//                               tiles(
//                                   "Overall Best Time",
//                                   // formatTime(currentStats.bestTime),
//                                   overAllBestTime(currentStats),
//                                   HugeIcons.strokeRoundedCrown,
//                                   TColors.majorHighlight,
//                                   () {}),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Score",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                   "Total Score",
//                                   currentStats.totalPoints.toString(),
//                                   Icons.score,
//                                   Colors.lightGreenAccent,
//                                   () {}),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Wins",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                   "Total Wins",
//                                   currentStats.gamesWon.toString(),
//                                   Icons.emoji_events_outlined,
//                                   Colors.green,
//                                   () {}),
//                               seperator(),
//                               tiles(
//                                   "Longest Winning Streak",
//                                   currentStats.longestWinStreak.toString(),
//                                   Icons.auto_graph_outlined,
//                                   TColors.iconDefault,
//                                   () {}),
//                               seperator(),
//                               tiles(
//                                   "Current Winning Streak",
//                                   currentStats.currentWinStreak.toString(),
//                                   HugeIcons.strokeRoundedTickDouble02,
//                                   TColors.secondaryDefault,
//                                   () {}),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget seperator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Divider(
//         color: TColors.textSecondary.withValues(
//           alpha: 0.3,
//         ),
//       ),
//     );
//   }

//   Widget _buildDifficultyTab(
//     String difficulty,
//     UserStats? currentStats,
//   ) {
//     // Ensure currentStats is not null
//     if (currentStats == null) {
//       return Center(child: Text("No data available"));
//     }

//     // Helper function to get dynamic stats based on difficulty
//     dynamic getStat(String statName) {
//       switch (difficulty.toLowerCase()) {
//         case 'easy':
//           switch (statName) {
//             case 'gamesStarted':
//               return currentStats.easyGamesStarted;
//             case 'avgTime':
//               return currentStats.easyAvgTime;
//             case 'bestTime':
//               return currentStats.easyBestTime;
//             case 'points':
//               return currentStats.easyPoints;
//             case 'gamesWon':
//               return currentStats.easyGamesWon;
//             case 'winRate':
//               return currentStats.easyWinRate;
//             case 'totalTime':
//               return currentStats.easyTotalTime;
//             default:
//               return null;
//           }
//         case 'medium':
//           switch (statName) {
//             case 'gamesStarted':
//               return currentStats.mediumGamesStarted;
//             case 'avgTime':
//               return currentStats.mediumAvgTime;
//             case 'bestTime':
//               return currentStats.mediumBestTime;
//             case 'points':
//               return currentStats.mediumPoints;
//             case 'gamesWon':
//               return currentStats.mediumGamesWon;
//             case 'winRate':
//               return currentStats.mediumWinRate;
//             case 'totalTime':
//               return currentStats.mediumTotalTime;
//             default:
//               return null;
//           }
//         case 'hard':
//           switch (statName) {
//             case 'gamesStarted':
//               return currentStats.hardGamesStarted;
//             case 'avgTime':
//               return currentStats.hardAvgTime;
//             case 'bestTime':
//               return currentStats.hardBestTime;
//             case 'points':
//               return currentStats.hardPoints;
//             case 'gamesWon':
//               return currentStats.hardGamesWon;
//             case 'winRate':
//               return currentStats.hardWinRate;
//             case 'totalTime':
//               return currentStats.hardTotalTime;
//             default:
//               return null;
//           }
//         case 'nightmare':
//           switch (statName) {
//             case 'gamesStarted':
//               return currentStats.nightmareGamesStarted;
//             case 'avgTime':
//               return currentStats.nightmareAvgTime;
//             case 'bestTime':
//               return currentStats.nightmareBestTime;
//             case 'points':
//               return currentStats.nightmarePoints;
//             case 'gamesWon':
//               return currentStats.nightmareGamesWon;
//             case 'winRate':
//               return currentStats.nightmareWinRate;
//             case 'totalTime':
//               return currentStats.nightmareTotalTime;
//             default:
//               return null;
//           }
//         default:
//           return null;
//       }
//     }

//     String formatTime(int milliseconds) {
//       final int totalSeconds = milliseconds ~/ 1000;
//       final int minutes = (totalSeconds % 3600) ~/ 60;
//       final int seconds = totalSeconds % 60;
//       return "$minutes:${seconds.toString().padLeft(2, '0')}";
//     }

//     // Future<String> overAllWinRate(UserStats currentStats) async {
//     //   await HiveService.saveUserStats(UserStats(
//     //       winRate: UserStats.calculateWinRate(
//     //           getStat('gamesWon'), getStat('gamesStarted'))));
//     //   return "${UserStats.calculateWinRate(getStat('gamesWon'), getStat('gamesStarted')).toString()}%";
//     // }

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Text(
//                       "Game Started",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                 "Total Games",
//                                 getStat('gamesStarted').toString(),
//                                 HugeIcons.strokeRoundedListView,
//                                 Colors.green,
//                                 () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Time",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                 "Average Time",
//                                 formatTime(UserStats.calculateAvgTime(
//                                     getStat('totalTime'),
//                                     getStat('gamesStarted'))),
//                                 HugeIcons.strokeRoundedTime01,
//                                 TColors.buttonDefault,
//                                 () {},
//                               ),
//                               seperator(),
//                               tiles(
//                                 "Best Time",
//                                 formatTime(getStat('bestTime')),
//                                 HugeIcons.strokeRoundedCrown,
//                                 TColors.majorHighlight,
//                                 () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Score",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                 "Total Score",
//                                 getStat('points').toString(),
//                                 Icons.score,
//                                 Colors.lightGreenAccent,
//                                 () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Wins",
//                       style: TTextThemes.defaultTextTheme.headlineMedium,
//                     ),
//                   ),
//                   dullContainer(
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               tiles(
//                                 "Total Wins",
//                                 getStat('gamesWon').toString(),
//                                 Icons.emoji_events_outlined,
//                                 Colors.green,
//                                 () {},
//                               ),
//                               // seperator(),
//                               // FutureBuilder<String>(
//                               //   future: overAllWinRate(currentStats),
//                               //   builder: (context, snapshot) {
//                               //     if (snapshot.connectionState ==
//                               //         ConnectionState.waiting) {
//                               //       return CircularProgressIndicator(); // Show loading indicator
//                               //     } else if (snapshot.hasError) {
//                               //       return Text("Error: ${snapshot.error}");
//                               //     } else if (snapshot.hasData) {
//                               //       return tiles(
//                               //         "Win Rate",
//                               //         snapshot.data!,
//                               //         HugeIcons.strokeRoundedCrown,
//                               //         TColors.majorHighlight,
//                               //         () {},
//                               //       );
//                               //     } else {
//                               //       return Text("No data");
//                               //     }
//                               //   },
//                               // )
//                               seperator(),
//                               tiles(
//                                 " Win Rate",
//                                 "${(UserStats.calculateWinRate(getStat('gamesWon'), getStat('gamesStarted'))).toStringAsFixed(1)}%",
//                                 Icons.star_rate_rounded,
//                                 const Color.fromARGB(255, 225, 136, 129),
//                                 () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget tiles(String title, String value, IconData icon, Color iconColor,
//       Function? nav) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         color: Colors.transparent,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: iconColor.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: HugeIcon(
//                           size: 24,
//                           icon: icon,
//                           color: iconColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       title,
//                       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                         fontSize: 18,
//                         letterSpacing: 1.5,
//                         color: TColors.textDefault.withValues(alpha: 0.8),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   value,
//                   textAlign: TextAlign.center,
//                   style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                     fontSize: 18,
//                     letterSpacing: 1.5,
//                     color: TColors.textDefault.withValues(alpha: 0.8),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget dullContainer(Widget child) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: TColors.primaryDefault,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: child,
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? playerStats;
  String? userId;
  String? userName;
  UserStats? currentStats;
  UserCred? userCred;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  void _loadUserData() async {
    UserCred? userCred = await HiveService.getUserCred();
    if (userCred != null) {
      userId = userCred.email;
      userName = userCred.displayName;
      _fetchPlayerStats(); // Fetch player stats from Firestore
    } else {
      userCred = null;
    }

    final stats = await HiveService.loadUserStats(); // Reload stats from Hive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentStats = stats;
      });
    });
  }

  Future<void> _loadUserStats() async {
    final stats = await HiveService.loadUserStats();
    UserStats? userdata = await HiveService.loadUserStats();
    UserCred? userCred = await HiveService.getUserCred();

    if (userdata != null && userCred != null) {
      await FirebaseService.updatePlayerStats(
        userCred.email!,
        userCred.displayName!,
        userdata,
      );
    }
    setState(() {
      currentStats = stats;
    });
  }

  bool _isReloading = false;
  Timer? _timer;

  void _fetchPlayerStats() async {
    userCred = await HiveService.getUserCred();
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred!.email)
          .get();
      if (snapshot.exists) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            playerStats = snapshot.data() as Map<String, dynamic>?;
          });
        });
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    // Define colors based on the theme

    final iconColor = isLightTheme ? LColor.iconDefault : TColors.iconDefault;
    final buttonColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault;
    final highlightColor =
        isLightTheme ? LColor.majorHighlight : TColors.majorHighlight;
    final secondaryTextColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: -1, end: 1).animate(anim)
                    : Tween<double>(begin: 1, end: -1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _currIndex == 0
                  ? Icon(
                      HugeIcons.strokeRoundedRefresh,
                      color: iconColor, // Use iconColor dynamically
                      key: const ValueKey('icon1'),
                      size: 20,
                    )
                  : Icon(
                      HugeIcons.strokeRoundedRefresh,
                      color: iconColor, // Use iconColor dynamically
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
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: currentStats == null
          ? Center(
              child: Text(
                "Initiate a game to access your stats",
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color:
                      secondaryTextColor, // Use secondaryTextColor dynamically
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
                      userCred == null
                          ? context.push(Routes.loginScreen)
                          : null;
                    },
                    child: Text(
                      userCred == null ? "Login to Sync Data" : userName!,
                      style: userCred == null
                          ? textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.normal,
                              color:
                                  secondaryTextColor, // Use secondaryTextColor dynamically
                            )
                          : textTheme.headlineLarge!.copyWith(
                              fontWeight: FontWeight.normal,
                              color: buttonColor, // Use buttonColor dynamically
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Wrap the TabBar in a Builder
                  TabBar(
                    isScrollable: true,
                    labelColor: buttonColor, // Use buttonColor dynamically
                    unselectedLabelColor:
                        secondaryTextColor, // Use secondaryTextColor dynamically
                    indicatorColor:
                        highlightColor, // Use highlightColor dynamically
                    labelStyle: textTheme.headlineSmall!.copyWith(),
                    tabAlignment: TabAlignment.start,
                    tabs: const [
                      Tab(text: 'Overall'),
                      Tab(text: 'Easy'),
                      Tab(text: 'Medium'),
                      Tab(text: 'Hard'),
                      Tab(text: 'Nightmare'),
                    ],
                  ),
                  Expanded(
                    // Wrap the TabBarView in a Builder
                    child: TabBarView(
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

    String overAllBestTime(UserStats currentStats) {
      final List<int?> bestTimes = [
        currentStats.bestTime,
        currentStats.easyBestTime,
        currentStats.mediumBestTime,
        currentStats.hardBestTime,
        currentStats.nightmareBestTime,
      ];
      final validTimes =
          bestTimes.where((time) => time != null && time > 0).toList();

      if (validTimes.isEmpty) {
        return "0";
      }

      final int? minTime = validTimes.reduce((a, b) => a! < b! ? a : b);
      final int totalSeconds = minTime! ~/ 1000;
      final int minutes = (totalSeconds % 3600) ~/ 60;
      final int seconds = totalSeconds % 60;

      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }

    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final iconColor = isLightTheme ? LColor.iconDefault : TColors.iconDefault;
    final buttonColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault;
    final highlightColor =
        isLightTheme ? LColor.majorHighlight : TColors.majorHighlight;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

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
                      "Games Started",
                      style: textTheme.headlineMedium,
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
                      style: textTheme.headlineMedium,
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
                                  buttonColor, // Use buttonColor dynamically
                                  () {}),
                              seperator(),
                              tiles(
                                  "Overall Best Time",
                                  overAllBestTime(currentStats),
                                  HugeIcons.strokeRoundedCrown,
                                  highlightColor, // Use highlightColor dynamically
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
                      style: textTheme.headlineMedium,
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
                      style: textTheme.headlineMedium,
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
                                  iconColor, // Use iconColor dynamically
                                  () {}),
                              seperator(),
                              tiles(
                                  "Current Winning Streak",
                                  currentStats.currentWinStreak.toString(),
                                  HugeIcons.strokeRoundedTickDouble02,
                                  highlightColor, // Use highlightColor dynamically
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
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final secondaryTextColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: secondaryTextColor.withValues(
            alpha: 0.3), // Use secondaryTextColor dynamically
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

    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final buttonColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
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
                      style: textTheme.headlineMedium,
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
                      style: textTheme.headlineMedium,
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
                                buttonColor,
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
                      style: textTheme.headlineMedium,
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
                      style: textTheme.headlineMedium,
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

  Widget tiles(String title, String value, IconData icon, Color iconColor,
      Function? nav) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textColor = isLightTheme ? LColor.textDefault : TColors.textDefault;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
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
                      style: textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        letterSpacing: 1.5,
                        color: textColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: textColor.withValues(alpha: 0.8),
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
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: isLightTheme ? LColor.primaryDefault : TColors.primaryDefault,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
