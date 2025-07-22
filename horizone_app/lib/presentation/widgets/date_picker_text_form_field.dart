import 'package:flutter/material.dart';

enum DatePickerMode { birthdate, futureOnly }

class CupertinoDatePickerField extends StatefulWidget {
  const CupertinoDatePickerField({
    super.key,
    required this.controller,
    required this.validator,
    required this.nameButton,
  });

  final String nameButton;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  State<DatePickerTextFormField> createState() =>
      _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime? selectedDate;

  // This method is called when the user taps on the date picker.
  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),

      builder: (context, child) {
        final currentTheme = Theme.of(context);
        return Theme(
          data: currentTheme.copyWith(
            colorScheme: currentTheme.colorScheme.copyWith(
              primary: currentTheme.primaryColor,
              onPrimary: currentTheme.colorScheme.onPrimary,
              surface: currentTheme.scaffoldBackgroundColor,
              onSurface: currentTheme.textTheme.bodyLarge?.color,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      validator: widget.validator,
        onTap: () async {
          final pickedDate = await _selectDate(context);

          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate;
              widget.controller.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            });
          }
        },
        style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        hintText: widget.nameButton,
        hintStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: Icon(
          Icons.calendar_month,
          color: Theme.of(context).hintColor,
          size: 20,
        ),
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
    );
  }
}


