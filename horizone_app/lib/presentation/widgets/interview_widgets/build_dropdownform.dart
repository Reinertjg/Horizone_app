import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme_color/app_colors.dart';

/// A customizable dropdown form field widget.
///
/// Useful for collecting single-selection input in forms with validation
/// and theming support.
class BuildDropdownform extends StatefulWidget {
  /// Creates a [BuildDropdownform] with a label, list of items, and icon.
  ///
  /// Optionally accepts a validator and an `onChanged` callback.
  const BuildDropdownform({
    super.key,
    required this.label,
    required this.items,
    required this.icon,
    this.validator,
    this.onChanged,
  });

  /// The label displayed above the dropdown field.
  final String label;

  /// The list of selectable items.
  final List<String> items;

  /// The icon displayed as a prefix inside the input.
  final IconData icon;

  /// Optional validation logic.
  final String? Function(String?)? validator;

  /// Optional callback triggered when the selection changes.
  final void Function(String?)? onChanged;

  @override
  State<BuildDropdownform> createState() => _BuildDropdownformState();
}

/// State class for [BuildDropdownform]
/// responsible for managing selection state.
class _BuildDropdownformState extends State<BuildDropdownform> {
  /// The currently selected value.
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    void onChanged(String? newValue) {
      setState(() {
        selectedValue = newValue;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(newValue);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.quaternary,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: widget.items.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.raleway(color: colors.secondary),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: widget.validator,
          hint: Text(
            'Selecione',
            style: TextStyle(color: colors.secondary.withValues(alpha: 0.3)),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(widget.icon, color: colors.tertiary, size: 20),
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
          dropdownColor: colors.primary,
        ),
      ],
    );
  }
}
