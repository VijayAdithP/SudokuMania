//

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/dailyChallenges%20Models/daily_challenge_progress.dart';
import 'package:sudokumania/models/gameProgress%20Models/game_progress.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/authProviders/auth_provider.dart';
import 'package:sudokumania/providers/dailyChallengesProviders/daily_challenges_provider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/screens/settingsScreen/max_mistakes_screen.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/auth/auth.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class AccountDetails extends ConsumerStatefulWidget {
  const AccountDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends ConsumerState<AccountDetails> {
  UserCred? userCred;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    final cred = await HiveService.getUserCred();
    setState(() {
      userCred = cred;
      isLoading = false;
    });
    if (userCred != null) {
      log("User Display Name: ${userCred!.displayName}");
    } else {
      log("No user credentials found in Hive.");
    }
  }

  final AuthService authService = AuthService();

  void _signOut() async {
    await authService.googleSignIn.disconnect();
    if (mounted) {
      ref.read(authProvider.notifier).signOut();
    }

    await authService.signOut();

    // Update the auth state using the provider
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          radius: 50,
          onTap: () => Navigator.pop(context),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: isLightTheme ? LColor.iconDefault : TColors.iconDefault,
          ),
        ),
        title: Text(
          "Account",
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: userCred != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20,
                                      spreadRadius: -10,
                                      color: isLightTheme
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userCred!.photoURL!,
                                    ),
                                  )),
                            )
                            // CircleAvatar(
                            //   radius: 35,
                            //   backgroundImage: userCred!.photoURL != null
                            //       ? NetworkImage(userCred!.photoURL!)
                            //       : null,
                            //   child: userCred!.photoURL == null
                            //       ? const Icon(Icons.person, size: 40)
                            //       : null,
                            // ),
                            ),
                        Text(
                          userCred!.displayName ?? "No Display Name",
                          style: textTheme.headlineLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: isLightTheme
                                ? LColor.buttonDefault
                                : TColors.buttonDefault,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              dullContainer(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      tiles(
                                        userCred!.email ?? "No Email",
                                        HugeIcons.strokeRoundedMail01,
                                        Colors.green,
                                        () {},
                                      ),
                                      seperator(),
                                      tiles(
                                        "Sync Offline Data",
                                        HugeIcons.strokeRoundedFolderSync,
                                        isLightTheme
                                            ? LColor.accentDefault
                                            : TColors.accentDefault,
                                        () async {
                                          if (userCred != null) {
                                            await HiveService.saveUsername(
                                                userCred!.displayName!);
                                            UserStats? userdata =
                                                await HiveService
                                                    .loadUserStats();
                                            if (userdata != null) {
                                              await FirebaseService
                                                  .updatePlayerStats(
                                                userCred!.email!,
                                                userCred!.displayName!,
                                                userdata,
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              dullContainer(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      tiles(
                                        "Logout",
                                        HugeIcons.strokeRoundedLogout04,
                                        Colors.red,
                                        resetData,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "Login to Sync Data",
                        style: TTextThemes.defaultTextTheme.headlineLarge!
                            .copyWith(
                          fontWeight: FontWeight.normal,
                          color: isLightTheme
                              ? LColor.textSecondary
                              : TColors.textSecondary,
                        ),
                      ),
                    ),
            ),
    );
  }

  void resetData() {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
    showDialog(
      context: context,
      builder: (context) {
        const String gameBox = 'sudokuGame';
        const String historyBox = 'gameHistory';
        const String statsBox = 'userStats';
        const String userBox = 'userData';
        const String userCredBox = 'userCred';
        const String offlineSyncBox = 'offlineSync';
        const String dailyChallengeBox = 'dailyChallengeBox';
        return Dialog(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.6,
            decoration: BoxDecoration(
              color:
                  isLightTheme ? LColor.dullBackground : TColors.dullBackground,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log Out",
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Are you sure you want to log out of your account?",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      _signOut();
                      ref.invalidate(dailyChallengeProvider);
                      ref.invalidate(maxMistakesProvider);
                      ref.invalidate(switchStateProvider);
                      await Hive.initFlutter();
                      await Hive.openBox<GameProgress>(gameBox);
                      await Hive.openBox<GameProgress>(historyBox);
                      await Hive.openBox<UserStats>(statsBox);
                      await Hive.openBox<String>(userBox);
                      await Hive.openBox<UserCred>(userCredBox);
                      await Hive.openBox<UserStats>(offlineSyncBox);
                      await Hive.openBox<DailyChallengeProgress>(
                          dailyChallengeBox);
                      setState(() {
                        userCred = null;
                      });
                      Hive.deleteFromDisk();
                      Navigator.pop(context);
                      context.go(Routes.homePage);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: isLightTheme
                            ? const Color.fromARGB(255, 250, 132, 126)
                            : const Color.fromARGB(255, 127, 74, 70),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Proceed",
                            style: textTheme.headlineSmall!.copyWith(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget seperator() {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: isLightTheme
            ? LColor.textSecondary.withValues(alpha: 0.3)
            : TColors.textSecondary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget tiles(String value, IconData icon, Color iconColor, Function()? nav) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
    return GestureDetector(
      onTap: nav,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HugeIcon(
                            size: 24,
                            icon: icon,
                            color: iconColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge!.copyWith(
                      letterSpacing: 1.5,
                      color: isLightTheme
                          ? LColor.textDefault
                          : TColors.textDefault,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dullContainer(Widget child) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: isLightTheme ? LColor.primaryDefault : TColors.primaryDefault,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
