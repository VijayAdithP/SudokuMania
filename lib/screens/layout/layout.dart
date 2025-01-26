import 'package:flutter/material.dart';
import './destinations.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
              color: Colors.black,
              size: 25,
            ),
          ),
          height: 65,
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          destinations: destinations
              .map((destination) => NavigationDestination(
                    icon: Icon(
                      destination.icon,
                    ),
                    label: destination.label,
                    selectedIcon: Icon(destination.selectedIcon),
                  ))
              .toList(),
        ),
      ));
}
