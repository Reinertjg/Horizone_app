import 'package:flutter/material.dart';

class DatePickerTextFormField extends StatefulWidget {
  const DatePickerTextFormField({required this.nameButton, super.key});

  final String nameButton;

  @override
  State<DatePickerTextFormField> createState() => _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Theme.of(context).hintColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).hintColor),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range_outlined, color: Theme.of(context).hintColor, size: 20),
            const SizedBox(width: 10),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : widget.nameButton,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
