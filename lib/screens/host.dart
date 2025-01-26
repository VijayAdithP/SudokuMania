// import 'package:flutter/material.dart';
// import './history.dart';
// import './selectionPage.dart';
// import './statistics.dart';

// class HostPage extends StatefulWidget {
//   const HostPage({super.key});

//   @override
//   State<HostPage> createState() => _HostPageState();
// }

// class _HostPageState extends State<HostPage> {
//   int _selectedIndex = 0;

//   void onTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<Widget> screens = [
//     SelectionPage(),
//     HistoryPage(),
//     StatisticsPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           indicatorColor: Colors.transparent,
//           labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
//           labelTextStyle: WidgetStatePropertyAll(
//             TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           iconTheme: WidgetStatePropertyAll(
//             IconThemeData(
//               color: Colors.black,
//               size: 25,
//             ),
//           ),
//           height: 65,
//         ),
//         child: NavigationBar(
//           backgroundColor: Colors.white,
//           selectedIndex: _selectedIndex,
//           onDestinationSelected: onTap,
//           destinations: [
//             NavigationDestination(
//               icon: Icon(
//                 Icons.home_outlined,
//                 size: 30,
//               ),
//               selectedIcon: Icon(
//                 Icons.home,
//               ),
//               label: "Home",
//             ),
//             NavigationDestination(
//                 icon: Icon(
//                   Icons.history,
//                   size: 30,
//                 ),
//                 selectedIcon: Icon(
//                   Icons.history,
//                 ),
//                 label: "History"),
//             NavigationDestination(
//                 icon: Icon(
//                   Icons.bar_chart_rounded,
//                   size: 30,
//                 ),
//                 selectedIcon: Icon(
//                   Icons.bar_chart_rounded,
//                 ),
//                 label: "Stats"),
//           ],
//         ),
//       ),
//     );
//   }
// }
