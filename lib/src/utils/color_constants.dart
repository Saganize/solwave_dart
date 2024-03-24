import 'package:flutter/material.dart';

class ColorConstants {
  static Color defaultScaffoldBackground = '#111218'.toColor();
  static Color secondaryTextColor = '#F9F9F9'.toColor();
  static Color buttonColor = '#171820'.toColor();
  static Color primaryButtonCTA = '#2380EA'.toColor();
  static Color tileBackground = '#15171E'.toColor();
  static Color borderColor = '#9E9EA166'.toColor();

  static Color yellow = '#FFC107'.toColor();
  static Color red = '#FF6363'.toColor();
  static Color green = '#63FF8A'.toColor();

  static List<Color> addFundsIcon = [
    Colors.grey[700]!,
    Colors.grey[800]!,
    Colors.grey[900]!
  ];

  static List<Color> authBackgroundColors = [
    '#2380EA'.toColor().withOpacity(0.5),
    '#0E101480'.toColor()
  ];
}

extension HexColor on String {
  Color toColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }
}
