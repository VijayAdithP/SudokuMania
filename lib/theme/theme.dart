import 'package:flutter/material.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins',
    textTheme: TTextThemes.defaultTextTheme,
  );
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextThemes.lightTextTheme,
  );
}
