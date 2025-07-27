import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../AppColors.dart';

class BuildDropdownform extends StatefulWidget {
  const BuildDropdownform({
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
  State<BuildDropdownform> createState() => _BuildDropdownformState();
}

class _BuildDropdownformState extends State<BuildDropdownform> {
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
            color: colors.secondary,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: widget.items.map((String value) {
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
          dropdownColor: colors.primary,
        ),
      ],
    );
  }
}
