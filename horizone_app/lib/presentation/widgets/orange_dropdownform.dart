import 'package:flutter/material.dart';

class OrangeDropdownform extends StatefulWidget {
  const OrangeDropdownform ({super.key, required this.label, required this.items, required this.icon, this.validator});

  final String label;
  final List<String> items;
  final IconData icon; // exemplo
  final String? Function(String?)? validator;

  @override
  State<OrangeDropdownform> createState() => _OrangeDropdownformState();
}

class _OrangeDropdownformState extends State<OrangeDropdownform> {
  @override
  Widget build(BuildContext context) {
    String? selectedValue;

    void onChanged(String? newValue) {
      setState(() {
        selectedValue = newValue;
      });
    }

    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: Icon(widget.icon, color: Theme.of(context).hintColor, size: 20),
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
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      iconEnabledColor: Theme.of(context).hintColor,
    );

  }
}

