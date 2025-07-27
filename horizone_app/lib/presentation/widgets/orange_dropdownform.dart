import 'package:flutter/material.dart';

import '../../AppColors.dart';

class OrangeDropdownform extends StatefulWidget {
  const OrangeDropdownform({
    super.key,
    required this.label,
    required this.items,
    required this.icon,
    this.validator,
    this.onChanged,
  });

  final String label;
  final List<String> items;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  @override
  State<OrangeDropdownform> createState() => _OrangeDropdownformState();
}

class _OrangeDropdownformState extends State<OrangeDropdownform> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    String? selectedValue;

    void onChanged(String? newValue) {
      setState(() {
        selectedValue = newValue;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(newValue);
      }
    }

    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: colors.secondary)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: colors.secondary),
        prefixIcon: Icon(widget.icon, color: colors.tertiary, size: 25),
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
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      iconEnabledColor: colors.tertiary,
    );
  }
}
