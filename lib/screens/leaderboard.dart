// import 'package:flutter/material.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// class LeaderboardPage extends StatefulWidget {
//   const LeaderboardPage({super.key});

//   @override
//   State<LeaderboardPage> createState() => _LeaderboardPageState();
// }

// class _LeaderboardPageState extends State<LeaderboardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           "Leaderboard",
//           style: TTextThemes.lightTextTheme.headlineLarge,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/leaderboard_provider.dart';

// class LeaderboardScreen extends ConsumerWidget {
//   const LeaderboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final leaderboard = ref.watch(leaderboardProvider("easy")); // FIXED

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Leaderboard'),
//       ),
//       body: leaderboard.when(
//         data: (players) {
//           if (players.isEmpty) {
//             return Center(child: Text("No players yet"));
//           }
//           return Column(
//             children: [
//               if (players.isNotEmpty) _buildTopPlayer(players[0], context),
//               if (players.length > 1)
//                 _buildMedalist(players[1], 2, Icons.emoji_events, Colors.grey),
//               if (players.length > 2)
//                 _buildMedalist(players[2], 3, Icons.emoji_events, Colors.brown),
//               Expanded(
//                 child: players.length > 3
//                     ? ListView.builder(
//                         itemCount: players.length - 3,
//                         itemBuilder: (context, index) {
//                           return _buildListPlayer(
//                               players[index + 3], index + 4);
//                         },
//                       )
//                     : SizedBox(), // Empty container if there are less than 4 players
//               ),
//             ],
//           );
//         },
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error loading leaderboard")),
//       ),
//     );
//   }

//   Widget _buildTopPlayer(Map<String, dynamic> player, BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.yellow,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.star, size: 40, color: Colors.white),
//           Text(
//             player['username'],
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           Text("${player['points']} pts"),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedalist(
//       Map<String, dynamic> player, int rank, IconData icon, Color color) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//     );
//   }

//   Widget _buildListPlayer(Map<String, dynamic> player, int rank) {
//     return ListTile(
//       leading: Text("#$rank"),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LeaderboardScreen extends StatefulWidget {
//   @override
//   _LeaderboardScreenState createState() => _LeaderboardScreenState();
// }

// class _LeaderboardScreenState extends State<LeaderboardScreen> {
//   String selectedDifficulty = 'easy';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Leaderboard")),
//       body: Column(
//         children: [
//           DropdownButton<String>(
//             value: selectedDifficulty,
//             items: ['easy', 'medium', 'hard', 'expert', 'nightmare']
//                 .map((difficulty) => DropdownMenuItem(
//                       value: difficulty,
//                       child: Text(
//                         difficulty.toUpperCase(),
// style: TextStyle(
//   color: Colors.black,
// ),
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedDifficulty = value!;
//               });
//             },
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('leaderboards')
//                   .doc(selectedDifficulty)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var data = snapshot.data!.data() as Map<String, dynamic>?;
//                 if (data == null || !data.containsKey('players')) {
//                   return Center(child: Text("No leaderboard data available"));
//                 }

//                 List players = List.from(data['players']);
//                 players.sort((a, b) => b['points'].compareTo(a['points']));

//                 return Column(
//                   children: [
//                     if (players.isNotEmpty) _buildTopPlayer(players[0]),
//                     if (players.length > 1)
//                       _buildMedalist(
//                           players[1], 2, Icons.emoji_events, Colors.grey),
//                     if (players.length > 2)
//                       _buildMedalist(
//                           players[2], 3, Icons.emoji_events, Colors.brown),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: players.length > 3 ? players.length - 3 : 0,
//                         itemBuilder: (context, index) {
//                           return _buildListPlayer(
//                               players[index + 3], index + 4);
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopPlayer(Map<String, dynamic> player) {
//     return Container(
//       margin: EdgeInsets.all(8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.yellow,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.star, size: 40, color: Colors.white),
//           Text(
//             player['username'],
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           Text("${player['points']} pts"),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedalist(
//       Map<String, dynamic> player, int rank, IconData icon, Color color) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//     );
//   }

//   Widget _buildListPlayer(Map<String, dynamic> player, int rank) {
//     return ListTile(
//       leading: Text("#$rank"),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LeaderboardPage extends StatefulWidget {
//   @override
//   _LeaderboardPageState createState() => _LeaderboardPageState();
// }

// class _LeaderboardPageState extends State<LeaderboardPage> {
//   String selectedDifficulty = 'easy';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Leaderboard")),
//       body: Column(
//         children: [
//           DropdownButton<String>(
//             value: selectedDifficulty,
//             items: ['easy', 'medium', 'hard', 'expert', 'nightmare']
//                 .map((difficulty) => DropdownMenuItem(
//                       value: difficulty,
//                       child: Text(
//                         difficulty.toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedDifficulty = value!;
//               });
//             },
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('leaderboards')
//                   .doc(selectedDifficulty)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var data = snapshot.data!.data() as Map<String, dynamic>?;
//                 if (data == null || !data.containsKey('players')) {
//                   return Center(child: Text("No leaderboard data available"));
//                 }

//                 List players = List.from(data['players']);
//                 players.sort((a, b) => b['points'].compareTo(a['points']));

//                 return Column(
//                   children: [
//                     if (players.isNotEmpty)
//                       _buildTopPlayer(players[0], context),
//                     if (players.length > 1)
//                       _buildMedalist(players[1], 2, Icons.emoji_events,
//                           Colors.grey, context),
//                     if (players.length > 2)
//                       _buildMedalist(players[2], 3, Icons.emoji_events,
//                           Colors.brown, context),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: players.length > 3 ? players.length - 3 : 0,
//                         itemBuilder: (context, index) {
//                           return _buildListPlayer(
//                               players[index + 3], index + 4, context);
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopPlayer(Map<String, dynamic> player, BuildContext context) {
//     return GestureDetector(
//       onTap: () => _navigateToPlayerStats(context, player),
//       child: Container(
//         margin: EdgeInsets.all(8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.yellow,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Icon(Icons.star, size: 40, color: Colors.white),
//             Text(
//               player['username'],
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text("${player['points']} pts"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMedalist(Map<String, dynamic> player, int rank, IconData icon,
//       Color color, BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//       onTap: () => _navigateToPlayerStats(context, player),
//     );
//   }

//   Widget _buildListPlayer(
//       Map<String, dynamic> player, int rank, BuildContext context) {
//     return ListTile(
//       leading: Text("#$rank"),
//       title: Text(player['username']),
//       trailing: Text("${player['points']} pts"),
//       onTap: () => _navigateToPlayerStats(context, player),
//     );
//   }

//   void _navigateToPlayerStats(
//       BuildContext context, Map<String, dynamic> player) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => PlayerStatsScreen(player: player)),
//     );
//   }
// }

// class PlayerStatsScreen extends StatelessWidget {
//   final Map<String, dynamic> player;
//   PlayerStatsScreen({required this.player});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Player Stats")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "${player['username']}",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Total Points: ${player['points']}",
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               "Games Played: ${player['gamesPlayed'] ?? 'N/A'}",
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               "Win Percentage: ${player['winPercentage'] ?? 'N/A'}%",
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String selectedDifficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedDifficulty,
            items: ['easy', 'medium', 'hard', 'expert', 'nightmare']
                .map((difficulty) => DropdownMenuItem(
                      value: difficulty,
                      child: Text(difficulty.toUpperCase(),
                          style: TextStyle(color: Colors.black)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedDifficulty = value!;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('leaderboards')
                  .doc(selectedDifficulty)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.data() as Map<String, dynamic>?;
                if (data == null || !data.containsKey('players')) {
                  return Center(child: Text("No leaderboard data available"));
                }

                List players = List.from(data['players']);
                players.sort((a, b) => b['points'].compareTo(a['points']));

                return Column(
                  children: [
                    if (players.isNotEmpty) _buildTopPlayer(players[0]),
                    if (players.length > 1)
                      _buildMedalist(
                          players[1], 2, Icons.emoji_events, Colors.grey),
                    if (players.length > 2)
                      _buildMedalist(
                          players[2], 3, Icons.emoji_events, Colors.brown),
                    Expanded(
                      child: ListView.builder(
                        itemCount: players.length > 3 ? players.length - 3 : 0,
                        itemBuilder: (context, index) {
                          return _buildListPlayer(
                              players[index + 3], index + 4);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlayer(Map<String, dynamic> player) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.star, size: 40, color: Colors.white),
          Text(
            player['username'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("${player['points']} pts"),
        ],
      ),
    );
  }

  Widget _buildMedalist(
      Map<String, dynamic> player, int rank, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(player['username']),
      trailing: Text("${player['points']} pts"),
    );
  }

  Widget _buildListPlayer(Map<String, dynamic> player, int rank) {
    return ListTile(
      leading: Text("#$rank"),
      title: Text(player['username']),
      trailing: Text("${player['points']} pts"),
    );
  }
}
