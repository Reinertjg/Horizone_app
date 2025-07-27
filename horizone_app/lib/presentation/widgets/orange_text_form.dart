import 'package:flutter/material.dart';

import '../theme_color/AppColors.dart';

class OrangeTextForm extends StatelessWidget {
  const OrangeTextForm({
    required this.nameButton,
    required this.icon,
    required this.controller,
    this.validator,
    super.key,
  });

  final String nameButton;
  final IconData icon;
  final TextEditingController controller;
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
