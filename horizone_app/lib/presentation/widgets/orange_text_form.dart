import 'package:flutter/material.dart';

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
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        labelText: nameButton,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: Icon(icon, color: Theme.of(context).hintColor, size: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),

      ),
    );
  }
}
