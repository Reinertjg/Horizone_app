import 'package:flutter/material.dart';

/// A custom theme extension that defines a set of color properties
/// used throughout the app for consistent styling.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Primary color used for backgrounds or main elements.
  final Color primary;

  /// Secondary color used for text or accent elements.
  final Color secondary;

  /// Tertiary color used for complementary accents.
  final Color tertiary;

  /// Quaternary color used for borders, highlights, etc.
  final Color quaternary;

  /// Quinary color used for cards, containers, or custom surfaces.
  final Color quinary;

  /// Creates an immutable [AppColors] instance with required colors.
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.quaternary,
    required this.quinary,
  });

  /// Returns a copy of this [AppColors] with the given fields replaced.
  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? quaternary,
    Color? quinary,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      quaternary: quaternary ?? this.quaternary,
      quinary: quinary ?? this.quinary,
    );
  }

  /// Interpolates between two [AppColors] instances based on the value [t].
  ///
  /// Used for animating between light and dark themes or other dynamic changes.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      quaternary: Color.lerp(quaternary, other.quaternary, t)!,
      quinary: Color.lerp(quinary, other.quinary, t)!,
    );
  }
}
