import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// A customizable dropdown form field styled with the orange theme.
///
/// Displays a list of string items with a label and icon.
class OrangeDropdownform extends StatefulWidget {
  /// Creates an [OrangeDropdownform] with the given parameters.
  const OrangeDropdownform({
    super.key,
    required this.label,
    required this.items,
    required this.icon,
    this.validator,
    this.onChanged,
  });

  /// The label shown above the dropdown.
  final String label;

  /// The list of string items to display in the dropdown.
  final List<String> items;

  /// The icon displayed before the dropdown.
  final IconData icon;

  /// Optional form validator function.
  final String? Function(String?)? validator;

  /// Callback triggered when an item is selected.
  final void Function(String?)? onChanged;

  @override
  State<OrangeDropdownform> createState() => _OrangeDropdownformState();
}

class _OrangeDropdownformState extends State<OrangeDropdownform> {
  String? selectedValue;

  void onChanged(String? newValue) {
    setState(() {
      selectedValue = newValue;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: widget.items.map((value) {
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
