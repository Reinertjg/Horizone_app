import 'package:flutter/material.dart';

class OrangeTextBoxForm extends StatelessWidget {
  const OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    required this.icon,
    super.key,
  });

  final String nameButton;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: TextFormField(
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
        ),
      ),
    );
  }
}
