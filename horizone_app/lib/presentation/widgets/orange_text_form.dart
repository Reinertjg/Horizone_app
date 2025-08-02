import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// A customized single-line text input used throughout the app.
///
/// Applies consistent orange-themed styling.
class OrangeTextForm extends StatelessWidget {
  /// Creates a custom [OrangeTextForm] with the given parameters.
  const OrangeTextForm({
    required this.nameButton,
    required this.icon,
    required this.controller,
    this.validator,
    super.key,
  });

  /// Label text displayed above the input.
  final String nameButton;

  /// Icon shown on the left of the input field.
  final IconData icon;

  /// Text controller that handles the input value.
  final TextEditingController controller;

  /// Optional validator for form validation.
  final String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: colors.secondary, fontSize: 16),
      decoration: InputDecoration(
        labelText: nameButton,
        labelStyle: TextStyle(color: colors.secondary, fontSize: 16),
        prefixIcon: Icon(icon, color: colors.tertiary, size: 28),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.tertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.tertiary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.tertiary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.tertiary),
        ),
      ),
    );
  }
}
