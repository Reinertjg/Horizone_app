import 'package:flutter/material.dart';

class OrangeTextForm extends StatelessWidget {
  const OrangeTextForm({required this.nameButton, required this.icon, super.key});

  final String nameButton;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      ),
    );
  }
}
