import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// A custom multiline text input field with a styled orange theme.
///
/// Useful for large text inputs such as descriptions or comments.
class OrangeTextBoxForm extends StatelessWidget {
  /// Creates an [OrangeTextBoxForm] with the given parameters.
  const OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    required this.icon,
    required this.controller,
    this.validator,
    super.key,
  });

  /// The label that appears above the field.
  final String nameButton;

  /// The hint shown inside the input.
  final String hintText;

  /// The icon shown at the beginning of the field.
  final IconData icon;

  /// Controller that manages the text being edited.
  final TextEditingController controller;

  /// Optional validation logic.
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: 125,
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: colors.secondary),
        decoration: InputDecoration(
          labelText: nameButton,
          hintText: hintText,
          labelStyle: TextStyle(color: colors.secondary),
          hintStyle: TextStyle(color: colors.secondary.withAlpha(128)),
          prefixIcon: Icon(icon, color: colors.tertiary, size: 25),
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
      ),
    );
  }
}
