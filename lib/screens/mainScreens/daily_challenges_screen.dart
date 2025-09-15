// import 'dart:developer' as dev;
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:intl/intl.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
// import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
// import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
// import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
// import 'package:sudokumania/utlis/router/routes.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:timeline_tile/timeline_tile.dart';

// class DailyChallenges extends ConsumerStatefulWidget {
//   const DailyChallenges({super.key});

//   @override
//   ConsumerState<DailyChallenges> createState() => _DailyChallengesState();
// }

// class _DailyChallengesState extends ConsumerState<DailyChallenges> {
//   DateTime _focusedDay = DateTime.now();

//   @override
//   void initState() {
//     ref.read(dailyChallengeProvider.notifier).loadProgress();
//     super.initState();
//   }

//   SudokuDifficulty getRandomDifficulty() {
//     final difficulties = SudokuDifficulty.values;
//     final random = Random();
//     return difficulties[random.nextInt(difficulties.length)];
//   }

//   void _startGame(DateTime selectedDate) {
//     final today = DateTime.now();
//     final isPastOrToday =
//         selectedDate.isBefore(today) || selectedDate.isAtSameMomentAs(today);
//     ref.read(gameSourceProvider.notifier).state = GameSource.calendar;

//     if (isPastOrToday) {
//       SudokuDifficulty easy = SudokuDifficulty.easy;

//       // for testing
//       const int SometingToGetMyAttentionHere = 0;
//       // final randomDifficulty = getRandomDifficulty();
//       ref.read(difficultyProvider.notifier).setDifficulty(easy);

//       context.push(Routes.gameScreen);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: Duration(
//             milliseconds: 700,
//           ),
//           dismissDirection: DismissDirection.up,
//           shape: StadiumBorder(),
//           content: Text("Play challenges for today or past dates."),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   String returnMonth(DateTime date) {
//     return DateFormat.MMMM().format(date);
//   }

//   DateTime normalizeDate(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//   }

//   bool _isReloading = false;
//   int _currIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     // dev.log("Is the ui being built?");
//     final progress = ref.watch(dailyChallengeProvider);
//     final daysInMonth =
//         DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
//     // dev.log("Progress: ${progress.completedDays}");
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         toolbarHeight: 75,
//         title: Text(
//           "Daily Challenges",
//           style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         actionsPadding: EdgeInsets.symmetric(horizontal: 16),
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
//               ref.watch(dailyChallengeProvider);
//               setState(() {
//                 _currIndex = _currIndex == 0 ? 1 : 0;
//                 _isReloading = false;
//               });
//             },
//           ),
//         ],
//         backgroundColor: Colors.transparent,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 16,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Container(
//                 decoration: BoxDecoration(
//                   color: TColors.primaryDefault,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TableCalendar(
//                   daysOfWeekVisible: false,
//                   weekNumbersVisible: false,
//                   headerVisible: false,
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.utc(2030, 12, 31),
//                   focusedDay: _focusedDay,
//                   onDaySelected: (selectedDay, focusedDay) {
//                     final normalizedDate = normalizeDate(selectedDay);

//                     if (progress.completedDays.containsKey(normalizedDate)) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           duration: Duration(milliseconds: 700),
//                           dismissDirection: DismissDirection.up,
//                           backgroundColor: TColors.buttonDefault,
//                           shape: StadiumBorder(),
//                           content: Text(
//                             textAlign: TextAlign.center,
//                             "This day's challenge is already completed.",
//                             style: TTextThemes.defaultTextTheme.titleMedium,
//                           ),
//                           behavior: SnackBarBehavior.floating,
//                         ),
//                       );
//                       return;
//                     }
//                     ref.read(selectedDateProvider.notifier).state = selectedDay;
//                     // Update the focused day and start the game
//                     setState(() {
//                       _focusedDay = focusedDay;
//                       dev.log("This is the selected day: $selectedDay");
//                     });
//                     _startGame(selectedDay);
//                   },
//                   availableGestures: AvailableGestures.none,
//                   calendarStyle: CalendarStyle(
//                     isTodayHighlighted: true,
//                     todayTextStyle: TTextThemes.defaultTextTheme.headlineSmall!,
//                     todayDecoration: BoxDecoration(
//                       color: TColors.buttonDefault,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   calendarBuilders: CalendarBuilders(
//                     markerBuilder: (context, date, events) {
//                       final normalizedDate =
//                           DateTime(date.year, date.month, date.day);

//                       if (progress.completedDays.containsKey(normalizedDate)) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.check_circle,
//                               size: 40,
//                               color: TColors.textDefault,
//                             ),
//                           ),
//                         );
//                       }

//                       return Center(
//                         child: Text(
//                           '${date.day}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: TColors.majorHighlight,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   "Daily Progress",
//                   textAlign: TextAlign.center,
//                   style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                     fontSize: 18,
//                     letterSpacing: 1.5,
//                     color: TColors.textDefault,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               returnMonth(_focusedDay),
//               textAlign: TextAlign.center,
//               style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                 fontSize: 18,
//                 letterSpacing: 1.5,
//                 color: TColors.textDefault,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               scrollDirection: Axis.horizontal,
//               itemCount: daysInMonth,
//               itemBuilder: (context, index) {
//                 final day =
//                     DateTime(_focusedDay.year, _focusedDay.month, index + 1);
//                 final normalizedDate = normalizeDate(day);
//                 final isCompleted =
//                     progress.completedDays.containsKey(normalizedDate);

//                 return TimelineTile(
//                   axis: TimelineAxis.horizontal,
//                   alignment: TimelineAlign.center,
//                   isFirst: index == 0,
//                   isLast: index == daysInMonth - 1,
//                   beforeLineStyle: LineStyle(
//                     color: isCompleted ? Colors.green : TColors.textSecondary,
//                     thickness: 10,
//                   ),
//                   afterLineStyle: LineStyle(
//                     color: isCompleted ? Colors.green : TColors.textSecondary,
//                     thickness: 10,
//                   ),
//                   indicatorStyle: IndicatorStyle(
//                     height: 50,
//                     width: 20,
//                     color: isCompleted ? Colors.green : TColors.textDefault,
//                     iconStyle: IconStyle(
//                       fontSize: 25,
//                       iconData: Icons.check,
//                       color: isCompleted
//                           ? TColors.textDefault
//                           : TColors.textSecondary,
//                     ),
//                   ),
//                   startChild: Text(
//                     'Day ${index + 1}',
//                     style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
//                       fontSize: 18,
//                       color: isCompleted ? Colors.green : TColors.textDefault,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/type_game_provider.dart';
import 'package:sudokumania/providers/enum/type_of_game_enum.dart';
import 'package:sudokumania/providers/gameStateProviders/gameDifficultyProvider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
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
    ref.read(dailyChallengeProvider.notifier).loadProgress();
    super.initState();
  }

  SudokuDifficulty getRandomDifficulty() {
    final difficulties = [
      SudokuDifficulty.easy,
      SudokuDifficulty.medium,
      SudokuDifficulty.hard,
    ];
    final random = Random();
    return difficulties[random.nextInt(difficulties.length)];
  }

  void _startGame(DateTime selectedDate) {
    final today = DateTime.now();
    final isPastOrToday =
        selectedDate.isBefore(today) || selectedDate.isAtSameMomentAs(today);
    ref.read(gameSourceProvider.notifier).state = GameSource.calendar;

    if (isPastOrToday) {
      // SudokuDifficulty easy = SudokuDifficulty.easy;

      // for testing
      // const int SometingToGetMyAttentionHere = 0;
      final randomDifficulty = getRandomDifficulty();
      ref.read(difficultyProvider.notifier).setDifficulty(randomDifficulty);

      context.push(Routes.gameScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 700),
          dismissDirection: DismissDirection.up,
          shape: const StadiumBorder(),
          content: const Text("Play challenges for today or past dates."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String returnMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isReloading = false;
  int _currIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    // Define colors based on the theme
    final primaryColor =
        isLightTheme ? LColor.primaryDefault : TColors.primaryDefault;
    final iconColor = isLightTheme ? LColor.iconDefault : TColors.iconDefault;
    final textColor = isLightTheme ? LColor.textDefault : TColors.textDefault;
    final buttonColor =
        isLightTheme ? LColor.buttonDefault : TColors.buttonDefault;
    final highlightColor =
        isLightTheme ? LColor.majorHighlight : TColors.majorHighlight;
    final secondaryTextColor =
        isLightTheme ? LColor.textSecondary : TColors.textSecondary;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    final progressColor =
        isLightTheme ? LColor.primaryDefault : TColors.iconDefault;
    final progressIconColor =
        isLightTheme ? LColor.majorHighlight : TColors.textSecondary;

    final progress = ref.watch(dailyChallengeProvider);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        title: Text(
          "Daily Challenges",
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
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
                color: primaryColor, // Use primaryColor dynamically
                borderRadius: BorderRadius.circular(10),
              ),
              child: TableCalendar(
                // sixWeekMonthsEnforced: true,
                // shouldFillViewport: true,

                daysOfWeekVisible: false,
                weekNumbersVisible: false,
                headerVisible: false,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  final normalizedDate = normalizeDate(selectedDay);

                  if (progress.completedDays.containsKey(normalizedDate)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 700),
                        dismissDirection: DismissDirection.up,
                        backgroundColor:
                            buttonColor, // Use buttonColor dynamically
                        shape: const StadiumBorder(),
                        content: Text(
                          textAlign: TextAlign.center,
                          "This day's challenge is already completed.",
                          style: textTheme.titleMedium,
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  ref.read(selectedDateProvider.notifier).state = selectedDay;
                  // Update the focused day and start the game
                  setState(() {
                    _focusedDay = focusedDay;
                    dev.log("This is the selected day: $selectedDay");
                  });
                  _startGame(selectedDay);
                },
                availableGestures: AvailableGestures.none,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  isTodayHighlighted: true,
                  todayTextStyle: textTheme.headlineSmall!,
                  todayDecoration: BoxDecoration(
                    color: buttonColor, // Use buttonColor dynamically
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final normalizedDate =
                        DateTime(date.year, date.month, date.day);

                    if (progress.completedDays.containsKey(normalizedDate)) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check_circle,
                              size: 35,
                              color: textColor, // Use textColor dynamically
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor, // Use textColor dynamically
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //       color: highlightColor, // Use highlightColor dynamically
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Text(
          //         "Daily Progress",
          //         textAlign: TextAlign.center,
          //         style: textTheme.bodyLarge!.copyWith(
          //           fontSize: 18,
          //           letterSpacing: 1.5,
          //           color: textColor, // Use textColor dynamically
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              returnMonth(_focusedDay),
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                letterSpacing: 1.5,
                color: textColor, // Use textColor dynamically
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final day =
                    DateTime(_focusedDay.year, _focusedDay.month, index + 1);
                final normalizedDate = normalizeDate(day);
                final isCompleted =
                    progress.completedDays.containsKey(normalizedDate);

                return TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.center,
                  isFirst: index == 0,
                  isLast: index == daysInMonth - 1,
                  beforeLineStyle: LineStyle(
                    color: isCompleted
                        ? Colors.green
                        : progressColor.withOpacity(0.5),
                    thickness: 6, // thinner line for a sleeker look
                  ),
                  afterLineStyle: LineStyle(
                    color: isCompleted
                        ? Colors.green
                        : progressColor.withOpacity(0.5),
                    thickness: 6,
                  ),
                  indicatorStyle: IndicatorStyle(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.all(4),
                    color: isCompleted ? Colors.green : Colors.white,
                    iconStyle: IconStyle(
                      iconData: isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isCompleted
                          ? Colors.green
                          : progressIconColor.withOpacity(0.7),
                      fontSize: 20,
                    ),
                  ),
                  startChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Day ${index + 1}',
                      style: textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight:
                            isCompleted ? FontWeight.bold : FontWeight.w500,
                        color: isCompleted
                            ? Colors.green
                            : textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                );

                // TimelineTile(
                //   axis: TimelineAxis.horizontal,
                //   alignment: TimelineAlign.center,
                //   isFirst: index == 0,
                //   isLast: index == daysInMonth - 1,
                //   beforeLineStyle: LineStyle(
                //     color: isCompleted
                //         ? Colors.green
                //         : progressColor, // Use secondaryTextColor dynamically
                //     thickness: 10,
                //   ),
                //   afterLineStyle: LineStyle(
                //     color: isCompleted
                //         ? Colors.green
                //         : progressColor, // Use secondaryTextColor dynamically
                //     thickness: 10,
                //   ),
                //   indicatorStyle: IndicatorStyle(
                //     height: 50,
                //     width: 20,
                //     color: isCompleted
                //         ? Colors.green
                //         : progressColor, // Use textColor dynamically
                //     iconStyle: IconStyle(
                //       fontSize: 25,
                //       iconData: Icons.check,
                //       color: isCompleted
                //           ? textColor // Use textColor dynamically
                //           : progressIconColor, // Use secondaryTextColor dynamically
                //     ),
                //   ),
                //   startChild: Text(
                //     'Day ${index + 1}',
                //     style: textTheme.bodyLarge!.copyWith(
                //       fontSize: 18,
                //       color: isCompleted
                //           ? Colors.green
                //           : textColor, // Use textColor dynamically
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
