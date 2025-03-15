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
import 'package:sudokumania/providers/notifProviders/notif_provider.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/screens/settingsScreen/max_mistakes_screen.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/auth/auth.dart';
import 'package:sudokumania/utlis/router/routes.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final Map<String, bool> _switchStates = {
    "Sounds": false,
    "Vibration": false,
    "Mistakes Limit": false,
    "Clear Data": false,
    "account": false,
    "theme": false,
    "Notifications": true,
  };
  @override
  void initState() {
    super.initState();
    // Initialize the notification switch state from Hive
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final isEnabled =
        await ref.read(notificationProvider.notifier).areNotificationsEnabled();
    setState(() {
      _switchStates["Notifications"] = isEnabled;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    // Update the local state
    setState(() {
      _switchStates["Notifications"] = value;
    });

    // Update the Riverpod state and Hive
    await ref.read(notificationProvider.notifier).toggleNotifications(value);
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
          "Settings",
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                        "Themes",
                        "on",
                        HugeIcons.strokeRoundedPaintBoard,
                        isLightTheme ? LColor.iconDefault : TColors.iconDefault,
                        true,
                        true,
                        () => {
                          context.push(Routes.themeSelection),
                        },
                        ref,
                        _switchStates["theme"]!,
                        (value) {
                          setState(() {
                            _switchStates["theme"] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                          "Sounds",
                          "on",
                          HugeIcons.strokeRoundedMusicNote01,
                          isLightTheme
                              ? LColor.buttonDefault
                              : TColors.buttonDefault,
                          true,
                          false,
                          null,
                          ref,
                          _switchStates["Sounds"]!, (value) {
                        setState(() {
                          _switchStates["Sounds"] = value;
                        });
                      }),
                      seperator(),
                      tiles(
                        "Vibtation",
                        "on",
                        HugeIcons.strokeRoundedVoice,
                        Colors.green,
                        true,
                        false,
                        null,
                        ref,
                        _switchStates["Vibration"]!,
                        (value) {
                          setState(() {
                            _switchStates["Vibration"] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                        "Mistakes Limit",
                        "on",
                        HugeIcons.strokeRoundedCancel01,
                        const Color.fromARGB(255, 230, 123, 116),
                        !ref.read(switchStateProvider),
                        false,
                        push,
                        ref,
                        ref.watch(switchStateProvider),
                        (value) {
                          setState(() {
                            ref.read(switchStateProvider.notifier).state =
                                value;
                            if (value) {
                              ref.read(maxMistakesProvider.notifier).state = 3;
                            } else {
                              ref.read(maxMistakesProvider.notifier).state =
                                  1000000;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                        "Notifications",
                        "on",
                        HugeIcons.strokeRoundedNotification01,
                        Colors.lime,
                        true,
                        false,
                        null,
                        ref,
                        _switchStates["Notifications"]!,
                        _toggleNotifications,
                      ),
                    ],
                  ),
                ),
              ),
              dullContainer(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      tiles(
                        "Account",
                        "on",
                        HugeIcons.strokeRoundedUser,
                        isLightTheme
                            ? LColor.accentDefault
                            : TColors.accentDefault,
                        true,
                        true,
                        () => {
                          context.push(Routes.accountDetails),
                        },
                        ref,
                        _switchStates["account"]!,
                        (value) {
                          setState(() {
                            _switchStates["account"] = value;
                          });
                        },
                      ),
                      seperator(),
                      tiles(
                        "Clear Data",
                        "on",
                        HugeIcons.strokeRoundedDelete04,
                        Colors.red,
                        true,
                        true,
                        () => {
                          resetData(),
                        },
                        ref,
                        _switchStates["Clear Data"]!,
                        (value) {
                          setState(() {
                            _switchStates["Clear Data"] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void push() {
    context.push(Routes.maxMistakesScreen);
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

  final AuthService authService = AuthService();

  void _signOut() async {
    UserCred? userCred = await HiveService.getUserCred();
    if (userCred != null) {
      await authService.googleSignIn.disconnect();
      await authService.signOut();
    }

    // Update the auth state using the provider
    ref.read(authProvider.notifier).signOut();
  }

  resetData() {
    const String gameBox = 'sudokuGame';
    const String historyBox = 'gameHistory';
    const String statsBox = 'userStats';
    const String userBox = 'userData';
    const String userCredBox = 'userCred';
    const String offlineSyncBox = 'offlineSync';
    const String dailyChallengeBox = 'dailyChallengeBox';
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.8,
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
                    "Reset Data",
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Are you sure you want to reset your data?",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium!.copyWith(),
                    ),
                  ),
                  Expanded(
                    child: const SizedBox(height: 15),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _signOut();
                      ref.invalidate(dailyChallengeProvider);
                      ref.invalidate(maxMistakesProvider);
                      ref.invalidate(switchStateProvider);
                      await Hive.initFlutter(); // Re-initialize Hive
                      await Hive.openBox<GameProgress>(gameBox);
                      await Hive.openBox<GameProgress>(historyBox);
                      await Hive.openBox<UserStats>(statsBox);
                      await Hive.openBox<String>(userBox);
                      await Hive.openBox<UserCred>(userCredBox);
                      await Hive.openBox<UserStats>(offlineSyncBox);
                      await Hive.openBox<DailyChallengeProgress>(
                          dailyChallengeBox);

                      Hive.deleteFromDisk();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 127, 74, 70),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Reset",
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

  bool test = false;

  Widget tiles(
      String title,
      String value,
      IconData icon,
      Color iconColor,
      bool isChangable,
      bool isTappable,
      Function()? nav,
      WidgetRef ref,
      bool switchState,
      Function(bool) onSwitchChanged) {
    final selectedMistakes = ref.watch(maxMistakesProvider);
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final textTheme = isLightTheme
        ? TTextThemes.lightTextTheme
        : TTextThemes.defaultTextTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: nav,
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        title,
                        style: textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          letterSpacing: 1.5,
                          color: isLightTheme
                              ? LColor.textDefault.withValues(alpha: 0.8)
                              : TColors.textDefault.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  if (isTappable)
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      size: 24,
                      color: isLightTheme
                          ? LColor.iconDefault
                          : TColors.iconDefault,
                    ),
                  if (!isTappable)
                    Switch(
                      activeTrackColor: isLightTheme
                          ? LColor.iconDefault
                          : TColors.iconDefault,
                      inactiveThumbColor: isLightTheme
                          ? LColor.backgroundSecondary
                          : TColors.backgroundSecondary,
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      trackColor: WidgetStatePropertyAll(
                        isLightTheme
                            ? LColor.majorHighlight
                            : TColors.majorHighlight,
                      ),
                      value: switchState,
                      onChanged: onSwitchChanged,
                    ),
                ],
              ),
              if (!isChangable)
                GestureDetector(
                  onTap: nav,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$selectedMistakes Mistakes limit number",
                          style: textTheme.labelLarge!.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          size: 24,
                          color: isLightTheme
                              ? LColor.iconDefault
                              : TColors.iconDefault,
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget seperator() {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Divider(
        color: isLightTheme
            ? LColor.textSecondary.withValues(
                alpha: 0.3,
              )
            : TColors.textSecondary.withValues(
                alpha: 0.3,
              ),
        // TColors.textSecondary.withValues(
        //   alpha: 0.3,
        // ),
      ),
    );
  }
}
