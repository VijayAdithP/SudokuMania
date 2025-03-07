import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/user_cred.dart';
import 'package:sudokumania/models/user_stats.dart';
import 'package:sudokumania/providers/auth_provider.dart';
import 'package:sudokumania/service/firebase_service.dart';
import 'package:sudokumania/service/hive_service.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';
import 'package:sudokumania/utlis/auth/auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthService authService = AuthService();
  bool isLoading = false;

  void _signIn() async {
    setState(() {
      isLoading = true;
    });

    User? user = await authService.signInWithGoogle();

    if (user != null) {
      // Update the auth state using the provider
      ref.read(authProvider.notifier).signIn(user);
    }

    setState(() {
      isLoading = false;
    });
    final authState = ref.watch(authProvider);
    await HiveService.saveUserId(authState.user!.email!);
    await HiveService.saveUserCredentials(UserCred(
      uid: authState.user!.uid,
      emailVerified: authState.user!.emailVerified,
      displayName: authState.user!.displayName,
      email: authState.user!.email,
      phoneNumber: authState.user!.phoneNumber,
      photoURL: authState.user!.photoURL,
    ));
    UserStats? firebaseStats =
        await FirebaseService.fetchUserStats(authState.user!.email!);
    UserStats? localStats = await HiveService.loadUserStats();
    await HiveService.saveUserStats(UserStats(
      currentWinStreak:
          localStats!.currentWinStreak + firebaseStats!.currentWinStreak,
      gamesStarted: localStats.gamesStarted + firebaseStats.gamesStarted,
      gamesWon: localStats.gamesWon + firebaseStats.gamesWon,
      longestWinStreak:
          localStats.longestWinStreak + firebaseStats.longestWinStreak,
      totalPoints: localStats.totalPoints + firebaseStats.totalPoints,
      easyPoints: localStats.easyPoints + firebaseStats.easyPoints,
      mediumPoints: localStats.mediumPoints + firebaseStats.mediumPoints,
      hardPoints: localStats.hardPoints + firebaseStats.hardPoints,
      expertPoints: localStats.expertPoints + firebaseStats.expertPoints,
      nightmarePoints:
          localStats.nightmarePoints + firebaseStats.nightmarePoints,
      easyAvgTime: localStats.easyAvgTime + firebaseStats.easyAvgTime,
      easyBestTime: localStats.easyBestTime + firebaseStats.easyBestTime,
      easyGamesStarted:
          localStats.easyGamesStarted + firebaseStats.easyGamesStarted,
      easyGamesWon: localStats.easyGamesWon + firebaseStats.easyGamesWon,
      easyTotalTime: localStats.easyTotalTime + firebaseStats.easyTotalTime,
      easyWinRate: localStats.easyWinRate + firebaseStats.easyWinRate,
      mediumAvgTime: localStats.mediumAvgTime + firebaseStats.mediumAvgTime,
      mediumBestTime: localStats.mediumBestTime + firebaseStats.mediumBestTime,
      mediumGamesStarted:
          localStats.mediumGamesStarted + firebaseStats.mediumGamesStarted,
      mediumGamesWon: localStats.mediumGamesWon + firebaseStats.mediumGamesWon,
      mediumTotalTime:
          localStats.mediumTotalTime + firebaseStats.mediumTotalTime,
      mediumWinRate: localStats.mediumWinRate + firebaseStats.mediumWinRate,
      hardAvgTime: localStats.hardAvgTime + firebaseStats.hardAvgTime,
      hardBestTime: localStats.hardBestTime + firebaseStats.hardBestTime,
      hardGamesStarted:
          localStats.hardGamesStarted + firebaseStats.hardGamesStarted,
      hardGamesWon: localStats.hardGamesWon + firebaseStats.hardGamesWon,
      hardTotalTime: localStats.hardTotalTime + firebaseStats.hardTotalTime,
      hardWinRate: localStats.hardWinRate + firebaseStats.hardWinRate,
      expertAvgTime: localStats.expertAvgTime + firebaseStats.expertAvgTime,
      expertBestTime: localStats.expertBestTime + firebaseStats.expertBestTime,
      expertGamesStarted:
          localStats.expertGamesStarted + firebaseStats.expertGamesStarted,
      expertGamesWon: localStats.expertGamesWon + firebaseStats.expertGamesWon,
      expertTotalTime:
          localStats.expertTotalTime + firebaseStats.expertTotalTime,
      expertWinRate: localStats.expertWinRate + firebaseStats.expertWinRate,
      nightmareAvgTime:
          localStats.nightmareAvgTime + firebaseStats.nightmareAvgTime,
      nightmareBestTime:
          localStats.nightmareBestTime + firebaseStats.nightmareBestTime,
      nightmareGamesStarted: localStats.nightmareGamesStarted +
          firebaseStats.nightmareGamesStarted,
      nightmareGamesWon:
          localStats.nightmareGamesWon + firebaseStats.nightmareGamesWon,
      nightmareTotalTime:
          localStats.nightmareTotalTime + firebaseStats.nightmareTotalTime,
      nightmareWinRate:
          localStats.nightmareWinRate + firebaseStats.nightmareWinRate,
      avgTime: localStats.avgTime + firebaseStats.avgTime,
      bestTime: localStats.bestTime + firebaseStats.bestTime,
      totalTime: localStats.totalTime + firebaseStats.totalTime,
      winRate: localStats.winRate + firebaseStats.winRate,
    ));
  }

  void _signOut() async {
    await authService.googleSignIn.disconnect();
    await authService.signOut();

    // Update the auth state using the provider
    ref.read(authProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to update the UI
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          splashColor: Colors.transparent,
          radius: 50,
          onTap: () async {
            Navigator.pop(context);
            if (authState.user != null) {
              await HiveService.saveUsername(authState.user!.displayName!);
              // UserStats? userdata = await HiveService.loadUserStats();
              // await FirebaseService.updatePlayerStats(authState.user!.email!,
              //     authState.user!.displayName!, userdata!);
            }
          },
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: TColors.iconDefault,
          ),
        ),
        title: Text(
          "Google SignIn",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            "assets/images/sudoku.png",
            height: 300,
            width: 300,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "SUDOKU MANIA",
                style: TTextThemes.defaultTextTheme.headlineLarge!.copyWith(
                  color: TColors.textDefault,
                  fontSize: 40,
                ),
              ),
              Text(
                textAlign: TextAlign.end,
                "By Vijay Adith P",
                style: TTextThemes.defaultTextTheme.bodySmall!.copyWith(
                  color: TColors.textDefault,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sync you current Offline Data to the Firebase cloud',
                  style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: TColors.textDefault.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (authState.isSignedIn)
                  Text(
                    'Welcome, ${authState.user!.displayName}!',
                    style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: TColors.textDefault,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (!authState.isSignedIn)
                  InkWell(
                    splashColor: TColors.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    onTap: _signIn,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: TColors.buttonDefault,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              height: 30,
                              width: 30,
                              "assets/images/google.svg",
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'SignIn with Google',
                              style: TTextThemes.defaultTextTheme.bodyLarge!
                                  .copyWith(
                                fontSize: 18,
                                letterSpacing: 1.5,
                                color: TColors.textDefault,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (authState.isSignedIn)
                  InkWell(
                    splashColor: TColors.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    onTap: _signOut,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: TColors.buttonDefault,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign Out',
                              style: TTextThemes.defaultTextTheme.bodyLarge!
                                  .copyWith(
                                fontSize: 18,
                                letterSpacing: 1.5,
                                color: TColors.textDefault,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
