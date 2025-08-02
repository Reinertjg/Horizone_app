import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic color [lightPrimaryColor] for light theme.
const Color lightPrimaryColor = Color(0xFFF6F1EB);
/// Semantic color [lightSecondaryColor] for light theme.
const Color lightSecondaryColor = Color(0xFF0087FF);
/// Semantic color [lightTertiaryColor] for light theme.
const Color lightTertiaryColor = Color(0xFFFF914D);
/// Semantic color [lightQuaternaryColor] for light theme.
const Color lightQuaternaryColor = Color(0xFF292929);
/// Semantic color [lightQuinaryColor] for light theme.
const Color lightQuinaryColor = Color(0xFFFFFFFF);

/// Semantic color [darkPrimaryColor] for dark theme.
const Color darkPrimaryColor = Color(0xFF292929);
/// Semantic color [darkSecondaryColor] for dark theme.
const Color darkSecondaryColor = Color(0xFF6DB7FD);
/// Semantic color [darkTertiaryColor] for dark theme.
const Color darkTertiaryColor = Color(0xFFFF914D);
/// Semantic color [darkQuaternaryColor] for dark theme.
const Color darkQuaternaryColor = Color(0xFFF6F1EB);
/// Semantic color [darkQuinaryColor] for dark theme.
const Color darkQuinaryColor = Color(0xFF494949);

/// Returns the [ThemeData] for the light theme configuration.
///
/// Includes semantic colors extended through [AppColors].
ThemeData lightTheme() {
  return ThemeData(
    extensions: [
      const AppColors(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        tertiary: lightTertiaryColor,
        quaternary: lightQuaternaryColor,
        quinary: lightQuinaryColor,
      ),
    ],
  );
}

/// Returns the [ThemeData] for the dark theme configuration.
///
/// Includes semantic colors extended through [AppColors].
ThemeData darkTheme() {
  return ThemeData(
    extensions: [
      const AppColors(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        tertiary: darkTertiaryColor,
        quaternary: darkQuaternaryColor,
        quinary: darkQuinaryColor,
      ),
    ],
  );
}
