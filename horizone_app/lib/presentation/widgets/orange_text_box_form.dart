import 'package:flutter/material.dart';

import '../../AppColors.dart';

class OrangeTextBoxForm extends StatelessWidget {
  const OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    required this.icon,
    required this.controller,
    this.validator,
    super.key,
  });

  final String nameButton;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
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
