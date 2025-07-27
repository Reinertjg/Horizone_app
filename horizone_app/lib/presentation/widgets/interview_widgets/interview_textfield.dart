import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../AppColors.dart';

class InterviewTextField extends StatefulWidget {
  const InterviewTextField({
    required this.nameButton,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.validator,
    required this.keyboardType,
    super.key,
  });

  final String nameButton;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  State<InterviewTextField> createState() => _InterviewTextFieldState();
}

class _InterviewTextFieldState extends State<InterviewTextField> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.nameButton,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.secondary,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.raleway(color: colors.secondary, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hint: Text(
              widget.hintText,
              style: TextStyle(
                color: colors.secondary.withValues(alpha: 0.3),
                fontSize: 16,
              ),
            ),
            prefixIcon: Icon(widget.icon, color: colors.tertiary, size: 28),
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
            errorStyle: const TextStyle(backgroundColor: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
