// import 'package:flutter/material.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// class DailyChallenges extends StatefulWidget {
//   const DailyChallenges({super.key});

//   @override
//   State<DailyChallenges> createState() => _DailyChallengesState();
// }

// class _DailyChallengesState extends State<DailyChallenges> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Daily Challenges",
//           style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: TColors.primaryDefault,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TableCalendar(
//                 daysOfWeekVisible: false,
//                 weekNumbersVisible: false,
//                 headerVisible: false,
//                 firstDay: DateTime.utc(2010, 10, 16),
//                 lastDay: DateTime.utc(2030, 3, 14),
//                 focusedDay: DateTime.now(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               child: Center(
//                 child: TimelineTile(
//                   axis: TimelineAxis.horizontal,
//                   alignment: TimelineAlign.center,
//                   hasIndicator: true,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/providers/daily_challenges_privider.dart';
import 'package:sudokumania/providers/newGameProviders/game_generation.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DailyChallenges extends ConsumerStatefulWidget {
  const DailyChallenges({super.key});

  @override
  ConsumerState<DailyChallenges> createState() => _DailyChallengesState();
}

class _DailyChallengesState extends ConsumerState<DailyChallenges> {
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    ref.read(dailyChallengeProvider.notifier).loadProgress();
  }

  SudokuDifficulty getRandomDifficulty() {
    final difficulties = SudokuDifficulty.values;
    final random = Random();
    return difficulties[random.nextInt(difficulties.length)];
  }

  // Function to start the game
  void _startGame(DateTime selectedDate) {
    final today = DateTime.now();
    final isPastOrToday =
        selectedDate.isBefore(today) || selectedDate.isAtSameMomentAs(today);

    if (isPastOrToday) {
      final randomDifficulty = getRandomDifficulty();
      ref.read(difficultyProvider.notifier).setDifficulty(randomDifficulty);

      // Navigate to the game screen
      context.push(Routes.gameScreen);
    } else {
      // Show a message if the selected date is in the future
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 500),
          content:
              Text("You can only play challenges for today or past dates."),
        ),
      );
    }
  }

  String returnMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(dailyChallengeProvider);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Daily Challenges",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: TColors.primaryDefault,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TableCalendar(
                daysOfWeekVisible: false,
                weekNumbersVisible: false,
                headerVisible: false,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });

                  _startGame(selectedDay);
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (progress.completedDays.containsKey(date)) {
                      return Icon(Icons.check, color: Colors.green);
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: TColors.majorHighlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Daily Progress",
                  textAlign: TextAlign.center,
                  style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: TColors.textDefault,
                  ),
                ),
              ),
            ),
          ),
          // Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              returnMonth(_focusedDay),
              textAlign: TextAlign.center,
              style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                fontSize: 18,
                letterSpacing: 1.5,
                color: TColors.textDefault,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final day =
                    DateTime(_focusedDay.year, _focusedDay.month, index + 1);
                final isCompleted = progress.completedDays.containsKey(day);

                return TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.center,
                  isFirst: index == 0,
                  isLast: index == daysInMonth - 1,
                  beforeLineStyle: LineStyle(
                    color: isCompleted ? Colors.green : TColors.textSecondary,
                    thickness: 10,
                  ),
                  afterLineStyle: LineStyle(
                    color: isCompleted ? Colors.green : TColors.textSecondary,
                    thickness: 10,
                  ),
                  indicatorStyle: IndicatorStyle(
                    height: 50,
                    width: 20,
                    color: isCompleted ? Colors.green : TColors.textDefault,
                    iconStyle: IconStyle(
                      fontSize: 25,
                      iconData: Icons.check,
                      color: TColors.textSecondary,
                    ),
                  ),
                  startChild: Text(
                    'Day ${index + 1}',
                    style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: isCompleted ? Colors.green : TColors.textDefault,
                    ),
                    // style: TextStyle(
                    //   color: isCompleted ? Colors.green : Colors.grey,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
