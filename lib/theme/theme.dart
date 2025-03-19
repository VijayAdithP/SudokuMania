import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: TColors.backgroundPrimary,
    fontFamily: 'Poppins',
    textTheme: TTextThemes.defaultTextTheme,
  );
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: HexColor("#F2F8FC"),
    textTheme: TTextThemes.lightTextTheme,
  );
}
