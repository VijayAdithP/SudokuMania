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
import 'package:hive_ce/hive.dart';
import 'package:sudokumania/service/hive_service.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, dynamic>? playerStats;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    var box = await Hive.openBox('user_data');
    userId = box.get('user_id');
    if (userId != null) {
      _fetchPlayerStats();
    }
  }

  void _fetchPlayerStats() async {
    var localStats = await HiveService.loadUserStats();

    setState(() {
      playerStats = localStats != null
          ? {
              'points': localStats.totalPoints,
              'gamesPlayed': localStats.gamesStarted,
              'winPercentage': localStats.winRate,
              'username': userId // Assuming username is stored elsewhere
            }
          : null;
    });

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        setState(() {
          playerStats = snapshot.data() as Map<String, dynamic>?;
        });
        var box = await Hive.openBox('player_stats');
        box.put(userId, playerStats);
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Stats")),
      body: playerStats == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username: ${playerStats!['username'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Total Points: ${playerStats!['points'] ?? 0}"),
                  Text("Games Played: ${playerStats!['gamesPlayed'] ?? 0}"),
                  Text(
                      "Win Percentage: ${playerStats!['winPercentage'] ?? 0}%"),
                ],
              ),
            ),
    );
  }
}
