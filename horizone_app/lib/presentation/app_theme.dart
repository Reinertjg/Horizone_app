import 'package:flutter/material.dart';

import '../AppColors.dart';

/// Semantic color variables for light theme
const Color lightPrimaryColor = Color(0xFFF6F1EB);
const Color lightSecondaryColor = Color(0xFF0087FF);
const Color lightTertiaryColor = Color(0xFFFF914D);
const Color lightQuaternaryColor = Color(0xFF292929);
const Color lightquinaryColor = Color(0xFFFFFFFF);

/// Semantic color variables for dark theme
const Color darkPrimaryColor = Color(0xFF292929);
const Color darkSecondaryColor = Color(0xFF6DB7FD);
const Color darkTertiaryColor = Color(0xFFFF914D);
const Color darkQuaternaryColor = Color(0xFFF6F1EB);
const Color darkquinaryColor = Color(0xFF494949);


/// Theme data for light theme
ThemeData lightTheme() {
  return ThemeData(
    extensions: [
      const AppColors(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        tertiary: lightTertiaryColor,
        quaternary: lightQuaternaryColor,
        quinary: lightquinaryColor,
      ),
    ],
  );
}

/// Theme data for dark theme
ThemeData darkTheme() {
  return ThemeData(
    extensions: [
      const AppColors(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        tertiary: darkTertiaryColor,
        quaternary: darkQuaternaryColor,
        quinary: darkquinaryColor,
      ),
    ],
    // Card background
  );
}
