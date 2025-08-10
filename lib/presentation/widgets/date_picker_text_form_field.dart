import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// Enum that defines the behavior mode of the date picker.
enum DatePickerMode {
  /// Used for selecting a birthdate (Subtract 18 years from the current date).
  birthdate,

  /// Used for selecting future dates only.
  futureOnly,
}

/// A custom [TextFormField] widget
/// Cupertino-style date picker popup
class CupertinoDatePickerField extends StatefulWidget {
  /// Creates a [CupertinoDatePickerField] with the given parameters.
  const CupertinoDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.mode,
    this.fontSize = 16,
    this.validator,
  });

  /// Controller for the date field.
  final TextEditingController controller;

  /// Label text displayed inside the field.
  final String label;

  /// Icon displayed at the beginning of the field.
  final IconData icon;

  /// Font size for the label.
  final double fontSize;

  /// Determines the behavior of the date picker.
  final DatePickerMode mode;

  /// Optional validator for the form field.
  final String? Function(String?)? validator;

  @override
  State<CupertinoDatePickerField> createState() =>
      _CupertinoDatePickerFieldState();
}

class _CupertinoDatePickerFieldState extends State<CupertinoDatePickerField> {
  late DateTime initialDate;
  late DateTime minDate;
  late DateTime maxDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    switch (widget.mode) {
      case DatePickerMode.birthdate:
        maxDate = DateTime(now.year - 18, now.month, now.day);
        minDate = DateTime(1900);
        initialDate = maxDate;
        break;
      case DatePickerMode.futureOnly:
        minDate = now;
        maxDate = DateTime(2100);
        initialDate = now;
        break;
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: Theme.of(context).extension<AppColors>()!.primary,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate,
          minimumDate: minDate,
          maximumDate: maxDate,
          onDateTimeChanged: (/*DateTime*/ value) {
            setState(() {
              widget.controller.text =
                  '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      readOnly: true,
      onTap: _showDatePicker,
      style: TextStyle(color: colors.secondary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        label: Text(widget.label),
        labelStyle: TextStyle(
          color: colors.secondary,
          fontSize: widget.fontSize,
        ),
        prefixIcon: Icon(widget.icon, color: colors.tertiary, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
