import 'package:flutter/material.dart';

class Destination {
  const Destination(
      {required this.label, required this.icon, required this.selectedIcon});

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const destinations = [
  Destination(
      label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
  Destination(
      label: 'Leaderboard',
      icon: Icons.emoji_events_outlined,
      selectedIcon: Icons.emoji_events),
  Destination(
      label: 'History', icon: Icons.timeline, selectedIcon: Icons.timeline),
  Destination(
      label: 'Stats',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics),
];
