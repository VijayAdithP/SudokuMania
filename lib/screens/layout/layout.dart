import 'package:flutter/material.dart';
import 'package:sudokumania/constants/colors.dart';
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
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: TColors.textSecondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 1,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    backgroundColor: TColors.primaryDefault,
                    indicatorColor: Colors.transparent,
                    iconTheme: WidgetStatePropertyAll(
                      IconThemeData(
                        color: TColors.iconDefault,
                        size: 30,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: NavigationBar(
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
                    labelTextStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: TColors.buttonDefault.withRed(0),
                      ),
                    ),
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: navigationShell.goBranch,
                    destinations: destinations
                        .map((destination) => NavigationDestination(
                              icon: Icon(
                                destination.icon,
                                color: TColors.textSecondary,
                              ),
                              label: destination.label,
                              selectedIcon: Icon(
                                destination.selectedIcon,
                                color: TColors.buttonDefault.withRed(0),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
