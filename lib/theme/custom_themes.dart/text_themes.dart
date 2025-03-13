import 'package:flutter/material.dart';

class TTextThemes {
  TTextThemes._();

  /// The default text theme
  static TextTheme defaultTextTheme = TextTheme(
    // Head Text
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle().copyWith(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),

    //Title Text
    titleLarge: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium: TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),

    //Body Text
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.5)),

    //Lable Text
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.5)),
  );

  /// The light text theme
  static TextTheme lightTextTheme = TextTheme(
    // Head Text
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle().copyWith(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),

    //Title Text
    titleLarge: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    titleMedium: TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),

    //Body Text
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black.withValues(alpha: 0.5)),

    //Lable Text
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
    labelSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black.withValues(alpha: 0.5)),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black.withValues(alpha: 0.5)),
  );
}
