import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Destination {
  const Destination(
      {required this.label, required this.icon, required this.selectedIcon});

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const destinations = [
  Destination(
    label: 'Home',
    icon: HugeIcons.strokeRoundedHome07,
    selectedIcon: HugeIcons.strokeRoundedHome07,
  ),
  Destination(
    label: 'Daily',
    icon: HugeIcons.strokeRoundedCalendar04,
    selectedIcon: HugeIcons.strokeRoundedCalendar04,
  ),
  Destination(
    label: 'Leaderboard',
    icon: HugeIcons.strokeRoundedChampion,
    selectedIcon: HugeIcons.strokeRoundedChampion,
  ),
  Destination(
    label: 'Stats',
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics,
  ),
];
