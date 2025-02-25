import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TColors {
  // App basic colors
  static Color primaryDefault = HexColor("#2E335A");
  static Color secondaryDefault = HexColor("#3D9AFD");
  static Color accentDefault = HexColor("#FBC02D");

  // Background Colors
  static Color backgroundPrimary = HexColor("#1C1B33");
  static Color backgroundSecondary = HexColor("#252A48");
  static Color backgroundAccent = HexColor("#3D9AFD").withValues(alpha: 0.5);

  // Text Colors
  static Color textDefault = HexColor("#FFFFFF");
  static Color textSecondary = HexColor("#8A8FA5");

  // Icon Colors
  static Color iconDefault = HexColor("#FFFFFF");
  static Color iconSecondary = HexColor("#B0B3C0");

  //Button Colors
  static Color buttonDefault = HexColor("#56beff");
  static Color darkContrast = HexColor("#000243");
  static Color dullBackground = const Color.fromARGB(255, 51, 46, 72);
  static Color majorHighlight = HexColor("#4f42ef");
}
