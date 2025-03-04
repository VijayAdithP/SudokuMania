// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// class LeaderboardPage extends StatefulWidget {
//   @override
//   _LeaderboardPageState createState() => _LeaderboardPageState();
// }

// class _LeaderboardPageState extends State<LeaderboardPage>
//     with SingleTickerProviderStateMixin {
//   String selectedDifficulty = 'easy';
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Leaderboard",
//             style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//           centerTitle: true,
//           toolbarHeight: 100,
//           backgroundColor: Colors.transparent,
//           bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(40),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Container(
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                     color: TColors.primaryDefault,
//                   ),
//                   child: TabBar(
//                     isScrollable: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     controller: _tabController,
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     dividerColor: Colors.transparent,
//                     indicator: BoxDecoration(
//                       color: TColors.backgroundAccent,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     // labelPadding: EdgeInsets.all(8),
//                     labelColor: Colors.white,
//                     labelStyle: TTextThemes.defaultTextTheme.titleMedium,
//                     unselectedLabelStyle:
//                         TTextThemes.defaultTextTheme.titleSmall,
//                     unselectedLabelColor: TColors.textSecondary,
//                     tabAlignment: TabAlignment.start,
//                     tabs: [
//                       Tab(
//                         text: 'Overall',
//                       ),
//                       Tab(
//                         text: 'Easy',
//                       ),
//                       Tab(
//                         text: 'Medium',
//                       ),
//                       Tab(
//                         text: 'Hard',
//                       ),
//                       Tab(
//                         text: 'Nightmare',
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//         ),
//         body: TabBarView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: _tabController,
//           children: [
//             _buildContent("overall"),
//             _buildContent("easy"),
//             _buildContent("medium"),
//             _buildContent("hard"),
//             _buildContent("nightmare"),
//           ],
//         ));
//   }

//   Widget _buildContent(String diffuculty) {
//     return Column(
//       spacing: 16,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: SizedBox(
//             height: 300,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 _podiumStands(
//                   colorTheme: TColors.buttonDefault,
//                   flex: 1,
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   bottomRight: 0,
//                   bottomLeft: 10,
//                   topRight: 10,
//                   topLeft: 10,
//                   bottomPos: 140,
//                   backGroundColor:
//                       TColors.primaryDefault.withValues(alpha: 0.7),
//                 ),
//                 _podiumStands(
//                   colorTheme: TColors.accentDefault,
//                   flex: 2,
//                   height: MediaQuery.of(context).size.height * 0.26,
//                   bottomRight: 0,
//                   bottomLeft: 0,
//                   topRight: 10,
//                   topLeft: 10,
//                   bottomPos: 200,
//                   backGroundColor: TColors.primaryDefault,
//                 ),
//                 _podiumStands(
//                   colorTheme: TColors.iconSecondary,
//                   flex: 1,
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   bottomRight: 10,
//                   bottomLeft: 0,
//                   topRight: 10,
//                   topLeft: 10,
//                   bottomPos: 140,
//                   backGroundColor:
//                       TColors.primaryDefault.withValues(alpha: 0.7),
//                 ),
//               ],
//             ),
//           ),
//         ),

// Expanded(
//   child: Container(
//     decoration: BoxDecoration(
//       color: TColors.primaryDefault.withValues(alpha: 0.7),
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(
//           20,
//         ),
//         topRight: Radius.circular(
//           20,
//         ),
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Container(
//               color: Colors.red,
//               child: Text("user $index"),
//             ),
//           );
//         },
//       ),
//     ),
//   ),
// )
//         // Expanded(
//         //   child: StreamBuilder<DocumentSnapshot>(
//         //     stream: FirebaseFirestore.instance
//         //         .collection('leaderboards')
//         //         .doc(diffuculty)
//         //         .snapshots(),
//         //     builder: (context, snapshot) {
//         //       if (!snapshot.hasData || snapshot.data == null) {
//         //         return Center(child: CircularProgressIndicator());
//         //       }

//         //       var data = snapshot.data!.data() as Map<String, dynamic>?;
//         //       if (data == null || !data.containsKey('players')) {
//         //         return Center(child: Text("No leaderboard data available"));
//         //       }

//         //       List players = List.from(data['players']);
//         //       players.sort((a, b) => b['points'].compareTo(a['points']));

//         //       return Column(
//         //         children: [
//         //           if (players.isNotEmpty) _buildTopPlayer(players[0]),
//         //           if (players.length > 1)
//         //             _buildMedalist(
//         //                 players[1], 2, Icons.emoji_events, Colors.grey),
//         //           if (players.length > 2)
//         //             _buildMedalist(
//         //                 players[2], 3, Icons.emoji_events, Colors.brown),
//         //           Expanded(
//         //             child: ListView.builder(
//         //               itemCount: players.length > 3 ? players.length - 3 : 0,
//         //               itemBuilder: (context, index) {
//         //                 return _buildListPlayer(players[index + 3], index + 4);
//         //               },
//         //             ),
//         //           ),
//         //         ],
//         //       );
//         //     },
//         //   ),
//         // ),
//       ],
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
//             style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//           ),
//           Text("${player['points']} pts"),
//         ],
//       ),
//     );
//   }

//   Widget _podiumStands({
//     required double bottomRight,
//     required double bottomLeft,
//     required double topRight,
//     required double topLeft,
//     required double bottomPos,
//     required double height,
//     required int flex,
//     required Color backGroundColor,
//     required Color colorTheme,
//   }) {
//     return Expanded(
//       flex: flex,
//       child: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(topLeft),
//                       topRight: Radius.circular(topRight),
//                       bottomRight: Radius.circular(bottomRight),
//                       bottomLeft: Radius.circular(bottomLeft)),
//                   color: backGroundColor,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Player Name",
//                       textAlign: TextAlign.center,
//                       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                         fontSize: 18,
//                         letterSpacing: 1.5,
//                         color: TColors.textDefault.withValues(alpha: 0.8),
//                       ),
//                     ),
//                     Text(
//                       "Score",
//                       style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                         color: colorTheme,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             right: 20,
//             left: 20,
//             bottom: bottomPos,
//             child: Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: TColors.iconDefault,
//                 border: Border.all(
//                   width: 5,
//                   color: colorTheme,
//                 ),
//               ),
//               child: Center(
//                   child: Text(
//                 "#1",
//                 style: TextStyle(
//                     fontSize: flex == 1 ? 20 : 40,
//                     fontWeight: FontWeight.bold,
//                     color: colorTheme),
//               )),
//             ),
//           )
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/providers/auth_provider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// class LeaderboardPage extends StatefulWidget {
//   @override
//   _LeaderboardPageState createState() => _LeaderboardPageState();
// }

// class _LeaderboardPageState extends State<LeaderboardPage>
//     with SingleTickerProviderStateMixin {
//   String selectedDifficulty = 'easy';
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Leaderboard",
//           style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         centerTitle: true,
//         toolbarHeight: 100,
//         backgroundColor: Colors.transparent,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(40),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 color: TColors.primaryDefault,
//               ),
//               child: TabBar(
//                 isScrollable: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 controller: _tabController,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 dividerColor: Colors.transparent,
//                 indicator: BoxDecoration(
//                   color: TColors.backgroundAccent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 labelColor: Colors.white,
//                 labelStyle: TTextThemes.defaultTextTheme.titleMedium,
//                 unselectedLabelStyle: TTextThemes.defaultTextTheme.titleSmall,
//                 unselectedLabelColor: TColors.textSecondary,
//                 tabAlignment: TabAlignment.start,
//                 tabs: [
//                   Tab(text: 'Overall'),
//                   Tab(text: 'Easy'),
//                   Tab(text: 'Medium'),
//                   Tab(text: 'Hard'),
//                   Tab(text: 'Nightmare'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         physics: const NeverScrollableScrollPhysics(),
//         controller: _tabController,
//         children: [
//           _buildContent("overall"),
//           _buildContent("easy"),
//           _buildContent("medium"),
//           _buildContent("hard"),
//           _buildContent("nightmare"),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent(String difficulty) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('leaderboards')
//           .doc(difficulty)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         var data = snapshot.data!.data() as Map<String, dynamic>?;
//         if (data == null || !data.containsKey('players')) {
//           return Center(child: Text("No leaderboard data available"));
//         }

//         List players = List.from(data['players']);
//         players.sort((a, b) => b['points'].compareTo(a['points']));

//         return Column(
//           children: [
//             SvgPicture.asset(
//               height: 40,
//               "assets/images/crown.svg",
//               colorFilter: ColorFilter.mode(
//                 TColors.accentDefault,
//                 BlendMode.srcIn,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: SizedBox(
//                 height: 300,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _podiumStands(
//                       colorTheme: TColors.buttonDefault,
//                       flex: 1,
//                       height: MediaQuery.of(context).size.height * 0.2,
//                       bottomRight: 0,
//                       bottomLeft: 10,
//                       topRight: 10,
//                       topLeft: 10,
//                       bottomPos: 140,
//                       backGroundColor:
//                           TColors.primaryDefault.withValues(alpha: 0.7),
//                       player: players.length > 1 ? players[1] : null,
//                       rank: 2,
//                     ),
//                     _podiumStands(
//                       colorTheme: TColors.accentDefault,
//                       flex: 2,
//                       height: MediaQuery.of(context).size.height * 0.26,
//                       bottomRight: 0,
//                       bottomLeft: 0,
//                       topRight: 10,
//                       topLeft: 10,
//                       bottomPos: 200,
//                       backGroundColor: TColors.primaryDefault,
//                       player: players.isNotEmpty ? players[0] : null,
//                       rank: 1,
//                     ),
//                     _podiumStands(
//                       colorTheme: TColors.iconSecondary,
//                       flex: 1,
//                       height: MediaQuery.of(context).size.height * 0.2,
//                       bottomRight: 10,
//                       bottomLeft: 0,
//                       topRight: 10,
//                       topLeft: 10,
//                       bottomPos: 140,
//                       backGroundColor:
//                           TColors.primaryDefault.withValues(alpha: 0.7),
//                       player: players.length > 2 ? players[2] : null,
//                       rank: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: TColors.primaryDefault.withValues(alpha: 0.7),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: players.length > 3
//                       ? ListView.builder(
//                           itemCount: players.length - 3,
//                           itemBuilder: (context, index) {
//                             return _buildListPlayer(
//                                 players[index + 3], index + 4);
//                           },
//                         )
//                       : Center(
//                           child: Text(
//                             "No more players to display",
//                             style: TTextThemes.defaultTextTheme.bodyLarge,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _podiumStands({
//     required double bottomRight,
//     required double bottomLeft,
//     required double topRight,
//     required double topLeft,
//     required double bottomPos,
//     required double height,
//     required int flex,
//     required Color backGroundColor,
//     required Color colorTheme,
//     required Map<String, dynamic>? player,
//     required int rank,
//   }) {
//     return Expanded(
//       flex: flex,
//       child: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(topLeft),
//                       topRight: Radius.circular(topRight),
//                       bottomRight: Radius.circular(bottomRight),
//                       bottomLeft: Radius.circular(bottomLeft)),
//                   color: backGroundColor,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     (player != null)
//                         ? Text(
//                             player['username'],
//                             textAlign: TextAlign.center,
//                             style: TTextThemes.defaultTextTheme.bodyLarge!
//                                 .copyWith(
//                               fontSize: 18,
//                               letterSpacing: 1.5,
//                               color: TColors.textDefault.withValues(alpha: 0.8),
//                             ),
//                           )
//                         : Text(
//                             "no ones here yet",
//                             textAlign: TextAlign.center,
//                             style: TTextThemes.defaultTextTheme.bodyLarge!
//                                 .copyWith(
//                               letterSpacing: 1.5,
//                               color: TColors.textDefault.withValues(alpha: 0.8),
//                             ),
//                           ),
//                     if (player != null)
//                       Text(
//                         "${player['points']} pts",
//                         style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.5,
//                           color: colorTheme,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             right: 20,
//             left: 20,
//             bottom: bottomPos,
//             child: Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: TColors.iconDefault,
//                 border: Border.all(
//                   width: 5,
//                   color: colorTheme,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "#$rank",
//                   style: TextStyle(
//                       fontSize: flex == 1 ? 20 : 40,
//                       fontWeight: FontWeight.bold,
//                       color: colorTheme),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListPlayer(Map<String, dynamic> player, int rank) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: TColors.backgroundAccent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ListTile(
//           leading: Text("#$rank"),
//           title: Text(player['username']),
//           trailing: Text("${player['points']} pts"),
//         ),
//       ),
//     );
//   }
// }

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  String selectedDifficulty = 'easy';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Leaderboard",
            style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          bottom: authState.isSignedIn
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: TColors.primaryDefault,
                      ),
                      child: TabBar(
                        isScrollable: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: TColors.backgroundAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: Colors.white,
                        labelStyle: TTextThemes.defaultTextTheme.titleMedium,
                        unselectedLabelStyle:
                            TTextThemes.defaultTextTheme.titleSmall,
                        unselectedLabelColor: TColors.textSecondary,
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          Tab(text: 'Overall'),
                          Tab(text: 'Easy'),
                          Tab(text: 'Medium'),
                          Tab(text: 'Hard'),
                          Tab(text: 'Nightmare'),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        ),
        body: authState.isSignedIn
            ? TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  _buildContent("overall"),
                  _buildContent("easy"),
                  _buildContent("medium"),
                  _buildContent("hard"),
                  _buildContent("nightmare"),
                ],
              )
            : Center(
                child: Text(
                  "Login to see the leaderboards",
                  style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: TColors.textSecondary,
                  ),
                ),
              ));
  }

  Widget _buildContent(String difficulty) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('leaderboards')
          .doc(difficulty)
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
            SvgPicture.asset(
              height: 40,
              "assets/images/crown.svg",
              colorFilter: ColorFilter.mode(
                TColors.accentDefault,
                BlendMode.srcIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _podiumStands(
                      colorTheme: TColors.buttonDefault,
                      flex: 1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      bottomRight: 0,
                      bottomLeft: 10,
                      topRight: 10,
                      topLeft: 10,
                      bottomPos: 140,
                      backGroundColor:
                          TColors.primaryDefault.withValues(alpha: 0.7),
                      player: players.length > 1 ? players[1] : null,
                      rank: 2,
                    ),
                    _podiumStands(
                      colorTheme: TColors.accentDefault,
                      flex: 2,
                      height: MediaQuery.of(context).size.height * 0.26,
                      bottomRight: 0,
                      bottomLeft: 0,
                      topRight: 10,
                      topLeft: 10,
                      bottomPos: 200,
                      backGroundColor: TColors.primaryDefault,
                      player: players.isNotEmpty ? players[0] : null,
                      rank: 1,
                    ),
                    _podiumStands(
                      colorTheme: TColors.iconSecondary,
                      flex: 1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      bottomRight: 10,
                      bottomLeft: 0,
                      topRight: 10,
                      topLeft: 10,
                      bottomPos: 140,
                      backGroundColor:
                          TColors.primaryDefault.withValues(alpha: 0.7),
                      player: players.length > 2 ? players[2] : null,
                      rank: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TColors.primaryDefault.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: players.length > 3
                      ? ListView.builder(
                          itemCount: players.length - 3,
                          itemBuilder: (context, index) {
                            return _buildListPlayer(
                                players[index + 3], index + 4);
                          },
                        )
                      : Center(
                          child: Text(
                            "No more players to display",
                            style: TTextThemes.defaultTextTheme.bodyLarge,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _podiumStands({
    required double bottomRight,
    required double bottomLeft,
    required double topRight,
    required double topLeft,
    required double bottomPos,
    required double height,
    required int flex,
    required Color backGroundColor,
    required Color colorTheme,
    required Map<String, dynamic>? player,
    required int rank,
  }) {
    return Expanded(
      flex: flex,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topLeft),
                      topRight: Radius.circular(topRight),
                      bottomRight: Radius.circular(bottomRight),
                      bottomLeft: Radius.circular(bottomLeft)),
                  color: backGroundColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (player != null)
                        ? Text(
                            player['username'],
                            textAlign: TextAlign.center,
                            style: TTextThemes.defaultTextTheme.bodyLarge!
                                .copyWith(
                              fontSize: 18,
                              letterSpacing: 1.5,
                              color: TColors.textDefault.withValues(alpha: 0.8),
                            ),
                          )
                        : Text(
                            "no ones here yet",
                            textAlign: TextAlign.center,
                            style: TTextThemes.defaultTextTheme.bodyLarge!
                                .copyWith(
                              letterSpacing: 1.5,
                              color: TColors.textDefault.withValues(alpha: 0.8),
                            ),
                          ),
                    if (player != null)
                      Text(
                        "${player['points']} pts",
                        style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: colorTheme,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            left: 20,
            bottom: bottomPos,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.iconDefault,
                border: Border.all(
                  width: 5,
                  color: colorTheme,
                ),
              ),
              child: Center(
                child: Text(
                  "#$rank",
                  style: TextStyle(
                      fontSize: flex == 1 ? 20 : 40,
                      fontWeight: FontWeight.bold,
                      color: colorTheme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListPlayer(Map<String, dynamic> player, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: TColors.backgroundAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Text("#$rank"),
          title: Text(player['username']),
          trailing: Text("${player['points']} pts"),
        ),
      ),
    );
  }
}
