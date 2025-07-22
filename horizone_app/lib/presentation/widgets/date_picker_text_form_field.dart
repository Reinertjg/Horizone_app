import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DatePickerMode { birthdate, futureOnly }

class CupertinoDatePickerField extends StatefulWidget {
  const CupertinoDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.mode,
    this.fontSize = 16,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final double fontSize;
  final DatePickerMode mode;
  final String? Function(String?)? validator;

  @override
  State<CupertinoDatePickerField> createState() => _CupertinoDatePickerFieldState();
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
        color: Theme.of(context).highlightColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate,
          minimumDate: minDate,
          maximumDate: maxDate,
          onDateTimeChanged: (DateTime value) {
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
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      readOnly: true,
      onTap: _showDatePicker,
      style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        label: Text(widget.label),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: widget.fontSize,
        ),
        prefixIcon: Icon(widget.icon, color: Theme.of(context).hintColor, size: 25),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
