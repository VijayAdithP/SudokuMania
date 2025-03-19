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

  //gradient
  static Color g1Color = const Color(0xff4338CA);
  static Color g2Color = const Color(0xff6D28D9);
}

// class LColor {
//   // App basic colors
//   static Color primaryDefault = HexColor("#87CEEB"); // Sky blue
//   static Color secondaryDefault = HexColor("#6CB4EE"); // Lighter blue
//   static Color accentDefault = HexColor("#FFD700"); // Gold

//   // Background Colors
//   static Color backgroundPrimary = HexColor("#F2F8FC"); // Alice blue
//   static Color backgroundSecondary = HexColor("#E6F0FF"); // Lighter alice blue
//   static Color backgroundAccent =
//       HexColor("#6CB4EE").withValues(alpha: 0.5); // Semi-transparent lighter blue

//   // Text Colors
//   static Color textDefault = HexColor("#000000"); // Black
//   static Color textSecondary = HexColor("#4A4A4A"); // Dark gray

//   // Icon Colors
//   static Color iconDefault = HexColor("#000000"); // Black
//   static Color iconSecondary = HexColor("#666666"); // Gray

//   // Button Colors
//   static Color buttonDefault = HexColor("#87CEEB"); // Sky blue
//   static Color darkContrast = HexColor("#000080"); // Navy blue
//   static Color dullBackground = HexColor("#E0E0E0"); // Light gray
//   static Color majorHighlight = HexColor("#1E90FF"); // Dodger blue

//   // Gradient
//   static Color g1Color = const Color(0xff87CEEB); // Sky blue
//   static Color g2Color = const Color(0xff6CB4EE); // Lighter blue
// }
class LColor {
  // App basic colors
  static Color primaryDefault = HexColor("#87CEEB"); // Sky blue (light blue)
  static Color secondaryDefault = HexColor("#6CB4EE"); // Lighter blue
  static Color accentDefault =
      HexColor("#FFD700"); // Gold (contrast for #FBC02D)

  // Background Colors
  static Color backgroundPrimary =
      HexColor("#F0F8FF"); // Alice blue (light background)
  static Color backgroundSecondary = HexColor("#E6F0FF"); // Lighter alice blue
  static Color backgroundAccent = HexColor("#6CB4EE")
      .withValues(alpha: 0.5); // Semi-transparent lighter blue

  // Text Colors
  static Color textDefault =
      HexColor("#000000"); // Black (contrast for #FFFFFF)
  static Color textSecondary =
      HexColor("#4A4A4A"); // Dark gray (contrast for #8A8FA5)

  // Icon Colors
  static Color iconDefault =
      HexColor("#000000"); // Black (contrast for #FFFFFF)
  static Color iconSecondary =
      HexColor("#666666"); // Gray (contrast for #B0B3C0)

  // Button Colors
  static Color buttonDefault = HexColor("#1E90FF"); // Dodger blue (bright blue)
  static Color darkContrast =
      HexColor("#000080"); // Navy blue (dark contrast for #000243)
  static Color dullBackground =
      HexColor("#E0E0E0"); // Light gray (contrast for #332E48)
  static Color majorHighlight =
      HexColor("#4169E1"); // Royal blue (contrast for #4F42EF)

  // Gradient
  static Color g1Color = const Color(0xff87CEEB); // Sky blue
  static Color g2Color = const Color(0xff1E90FF); // Dodger blue
}
