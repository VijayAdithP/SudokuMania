//

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/userCredential%20Models/user_cred.dart';
import 'package:sudokumania/models/userStats%20Models/user_stats.dart';
import 'package:sudokumania/providers/authProviders/auth_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          radius: 50,
          onTap: () => Navigator.pop(context),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 30,
            color: TColors.iconDefault,
          ),
        ),
        title: Text(
          "Account",
          style: TTextThemes.defaultTextTheme.headlineMedium!.copyWith(
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
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: userCred!.photoURL != null
                                ? NetworkImage(userCred!.photoURL!)
                                : null,
                            child: userCred!.photoURL == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),
                        Text(
                          userCred!.displayName ?? "No Display Name",
                          style: TTextThemes.defaultTextTheme.headlineLarge!
                              .copyWith(
                            fontWeight: FontWeight.normal,
                            color: TColors.buttonDefault,
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
                                        TColors.accentDefault,
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
                          color: TColors.textSecondary,
                        ),
                      ),
                    ),
            ),
    );
  }

  void resetData() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.6,
            decoration: BoxDecoration(
              color: TColors.dullBackground,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log Out",
                    style: TTextThemes.defaultTextTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Are you sure you want to log out of your account?",
                      textAlign: TextAlign.center,
                      style:
                          TTextThemes.defaultTextTheme.bodyMedium!.copyWith(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      _signOut();
                      context.go(Routes.homePage);
                      setState(() {
                        userCred = null; // Clear the user credentials
                      });
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
                            "Proceed",
                            style: TTextThemes.defaultTextTheme.headlineSmall!
                                .copyWith(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: TColors.textSecondary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget tiles(String value, IconData icon, Color iconColor, Function()? nav) {
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
                    style: TTextThemes.defaultTextTheme.bodyLarge!.copyWith(
                      letterSpacing: 1.5,
                      color: TColors.textDefault,
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
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: TColors.primaryDefault,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
