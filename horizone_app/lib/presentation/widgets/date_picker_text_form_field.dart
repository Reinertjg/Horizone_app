import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class DatePickerTextFormField extends StatefulWidget {
  const DatePickerTextFormField({
    super.key,
    required this.validator,
    required this.nameButton,
  });

  final String nameButton;
  final String? Function(String?) validator;

  @override
  State<DatePickerTextFormField> createState() =>
      _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime? selectedDate;

  // This method is called when the user taps on the date picker.
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
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
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme
                      .of(context)
                      .hintColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: Theme
                          .of(context)
                          .hintColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!
                          .month}/${selectedDate!.year}'
                          : widget.nameButton,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 13),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}