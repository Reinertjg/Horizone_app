import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 125,
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          labelText: nameButton,
          hintText: hintText,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          hintStyle: TextStyle(color: Theme.of(context).primaryColor.withAlpha(128)),
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
      ),
    );
  }
}
