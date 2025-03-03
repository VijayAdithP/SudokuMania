import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DailyChallenges extends StatefulWidget {
  const DailyChallenges({super.key});

  @override
  State<DailyChallenges> createState() => _DailyChallengesState();
}

class _DailyChallengesState extends State<DailyChallenges> {
  @override
  Widget build(BuildContext context) {
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: TColors.primaryDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                daysOfWeekVisible: false,
                weekNumbersVisible: false,
                headerVisible: false,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: TColors.accentDefault,
              child: Center(  
                child: TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.center,
                  hasIndicator: true,
                ),
                // Text(
                //   "dayly",
                //   style: TTextThemes.lightTextTheme.headlineLarge!,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
