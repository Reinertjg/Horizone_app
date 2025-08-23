import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../state/theme_provider.dart';
import '../../theme_color/app_colors.dart';

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
  CupertinoDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.maxDate,
    required this.minDate,
    required this.initialDate,
    this.fontSize = 16,
    this.validator,
    this.onDateChanged,
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

  /// Optional validator for the form field.
  final String? Function(String?)? validator;

  /// The starting date for the date picker.
  final DateTime initialDate;

  /// The minimum date that can be selected.
  final DateTime minDate;

  /// The maximum date that can be selected.
  final DateTime maxDate;

  /// Callback function when a date is selected.
  final void Function(DateTime date)? onDateChanged;

  @override
  State<CupertinoDatePickerField> createState() =>
      _CupertinoDatePickerFieldState();
}

class _CupertinoDatePickerFieldState extends State<CupertinoDatePickerField> {

  void _showDatePicker() {
    final colors = Theme.of(context).extension<AppColors>()!;
    if (widget.controller.text.isEmpty) {
      // Set initial date in the controller when the widget initializes
      widget.controller.text =
          '${widget.initialDate.day.toString().padLeft(2, '0')}/${widget.initialDate.month.toString().padLeft(2, '0')}/${widget.initialDate.year}';
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        color: colors.primary,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Provider.of<ThemeProvider>(context).themeMode ==
                    ThemeMode.light
                ? Brightness.light
                : Brightness.dark,
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: widget.initialDate,
            minimumDate: widget.minDate,
            maximumDate: widget.maxDate,
            onDateTimeChanged: (value) {
              setState(() {
                widget.controller.text =
                    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
              });

              if (widget.onDateChanged != null) {
                widget.onDateChanged!(value);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
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
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          readOnly: true,
          onTap: _showDatePicker,
          style: TextStyle(color: colors.secondary),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hint: Text(
              'Selecione',
              style: TextStyle(
                color: colors.secondary.withValues(alpha: 0.3),
                fontSize: 16,
              ),
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
        ),
      ],
    );
  }
}
