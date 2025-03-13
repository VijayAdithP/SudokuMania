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
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/router/routes.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
    ref.read(dailyChallengeProvider.notifier).loadProgress();
    super.initState();
  }

  SudokuDifficulty getRandomDifficulty() {
    final difficulties = SudokuDifficulty.values;
    final random = Random();
    return difficulties[random.nextInt(difficulties.length)];
  }

  void _startGame(DateTime selectedDate) {
    final today = DateTime.now();
    final isPastOrToday =
        selectedDate.isBefore(today) || selectedDate.isAtSameMomentAs(today);
    ref.read(gameSourceProvider.notifier).state = GameSource.calendar;

    if (isPastOrToday) {
      SudokuDifficulty easy = SudokuDifficulty.easy;
      // final randomDifficulty = getRandomDifficulty();
      ref.read(difficultyProvider.notifier).setDifficulty(easy);

      context.push(Routes.gameScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(
            milliseconds: 700,
          ),
          dismissDirection: DismissDirection.up,
          shape: StadiumBorder(),
          content: Text("Play challenges for today or past dates."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String returnMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  bool _isReloading = false;
  int _currIndex = 0;
  @override
  Widget build(BuildContext context) {
    // dev.log("Is the ui being built?");
    final progress = ref.watch(dailyChallengeProvider);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    // dev.log("Progress: ${progress.completedDays}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        title: Text(
          "Daily Challenges",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        actions: [
          // IconButton(
          //   onPressed: () {
          // ref.watch(dailyChallengeProvider);
          // setState(() {});
          //   },
          //   icon: HugeIcon(
          //     icon: HugeIcons.strokeRoundedReload,
          //     color: TColors.iconDefault,
          //   ),
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
              ref.watch(dailyChallengeProvider);
              setState(() {
                _currIndex = _currIndex == 0 ? 1 : 0;
                _isReloading = false;
              });
            },
          ),
        ],
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
                child:
                    // SfDateRangePicker(
                    //   view: DateRangePickerView.month,
                    //   initialSelectedDate: _focusedDay,
                    //   onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    //     if (args.value is DateTime) {
                    //       final selectedDate = args.value as DateTime;
                    //       setState(() {
                    //         _focusedDay = selectedDate;
                    //       });
                    //       _startGame(selectedDate);
                    //     }
                    //   },
                    //   selectionMode: DateRangePickerSelectionMode.single,
                    //   initialDisplayDate: _focusedDay,
                    //   showActionButtons: true,
                    //   confirmText: "Start",
                    //   cancelText: "Cancel",
                    //   cellBuilder: (BuildContext context, details) {
                    //     final date = details.date;
                    //     final isCompleted = progress.completedDays.containsKey(date);

                    //     return Container(
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: isCompleted
                    //             ? Colors.green.withOpacity(0.2)
                    //             : Colors.transparent,
                    //       ),
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               details.date.day.toString(),
                    //               style: TextStyle(
                    //                 color: isCompleted ? Colors.green : Colors.black,
                    //               ),
                    //             ),
                    //             if (isCompleted)
                    //               Icon(Icons.check, size: 12, color: Colors.green),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    //     TableCalendar(
                    //   daysOfWeekVisible: false,
                    //   weekNumbersVisible: false,
                    //   headerVisible: false,
                    //   firstDay: DateTime.utc(2020, 1, 1),
                    //   lastDay: DateTime.utc(2030, 12, 31),
                    //   focusedDay: _focusedDay,
                    //   onDaySelected: (selectedDay, focusedDay) {
                    //     final normalizedDate = DateTime(
                    //         selectedDay.year, selectedDay.month, selectedDay.day);

                    //     if (progress.completedDays.containsKey(normalizedDate)) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           duration: Duration(
                    //             milliseconds: 700,
                    //           ),
                    //           dismissDirection: DismissDirection.up,
                    //           backgroundColor: TColors.buttonDefault,
                    //           shape: StadiumBorder(),
                    //           content: Text(
                    //             textAlign: TextAlign.center,
                    //             "This day's challenge is already completed.",
                    //             style: TTextThemes.defaultTextTheme.titleMedium,
                    //           ),
                    //           behavior: SnackBarBehavior.floating,
                    //         ),
                    //       );
                    //       return;
                    //     }

                    //     // Update the focused day and start the game
                    //     setState(() {
                    //       _focusedDay = focusedDay;
                    //     });
                    //     _startGame(selectedDay);
                    //   },
                    //   availableGestures: AvailableGestures.none,
                    //   calendarStyle: CalendarStyle(
                    //     isTodayHighlighted: true,
                    //     todayTextStyle: TTextThemes.defaultTextTheme.headlineSmall!,
                    //     todayDecoration: BoxDecoration(
                    //       color: TColors.buttonDefault,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    //   calendarBuilders: CalendarBuilders(
                    //     markerBuilder: (context, date, events) {
                    //       // Normalize the date to remove the time component
                    //       final normalizedDate =
                    //           DateTime(date.year, date.month, date.day);

                    //       // Check if the normalized date is in the completedDays map
                    //       if (progress.completedDays.containsKey(normalizedDate)) {
                    //         dev.log("normalized date: $normalizedDate");
                    //         return Icon(
                    //           Icons.check,
                    //           size: 30,
                    //           color: Colors.green,
                    //         );
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    TableCalendar(
                  daysOfWeekVisible: false,
                  weekNumbersVisible: false,
                  headerVisible: false,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    final normalizedDate = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);

                    if (progress.completedDays.containsKey(normalizedDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(milliseconds: 700),
                          dismissDirection: DismissDirection.up,
                          backgroundColor: TColors.buttonDefault,
                          shape: StadiumBorder(),
                          content: Text(
                            textAlign: TextAlign.center,
                            "This day's challenge is already completed.",
                            style: TTextThemes.defaultTextTheme.titleMedium,
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    // Update the focused day and start the game
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    _startGame(selectedDay);
                  },
                  availableGestures: AvailableGestures.none,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    todayTextStyle: TTextThemes.defaultTextTheme.headlineSmall!,
                    todayDecoration: BoxDecoration(
                      color: TColors.buttonDefault,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      final normalizedDate =
                          DateTime(date.year, date.month, date.day);

                      if (progress.completedDays.containsKey(normalizedDate)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check_circle,
                              size: 40,
                              color: TColors.textDefault,
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                )),
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
                      color: isCompleted
                          ? TColors.textDefault
                          : TColors.textSecondary,
                    ),
                  ),
                  startChild: Text(
                    'Day ${index + 1}',
                    style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: isCompleted ? Colors.green : TColors.textDefault,
                    ),
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
