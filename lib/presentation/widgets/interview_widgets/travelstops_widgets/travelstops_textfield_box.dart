import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../theme_color/app_colors.dart';

/// A text field widget for travel stops with a collapsible description.
class TravelStopsTextFieldBox extends StatefulWidget {
  /// Creates a custom [TravelStopsTextFieldBox].
  const TravelStopsTextFieldBox({
    required this.nameButton,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.validator,
    required this.keyboardType,
    this.description,
    super.key,
  });

  /// The text displayed above the text field.
  final String nameButton;

  /// The hint text to display in the text field.
  final String hintText;

  /// The icon to display inside the text field.
  final IconData icon;

  /// The controller for the text field.
  final TextEditingController controller;

  /// The validator function for the text field.
  final String? Function(String?)? validator;

  /// The keyboard type for the text field.
  final TextInputType keyboardType;

  /// Additional text that will be displayed when the eye icon is clicked.
  final String? description;

  @override
  State<TravelStopsTextFieldBox> createState() =>
      _TravelStopsTextFieldBoxState();
}

class _TravelStopsTextFieldBoxState extends State<TravelStopsTextFieldBox> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.nameButton,
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.quaternary,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                _showDescription
                    ? HugeIcons.strokeRoundedView
                    : HugeIcons.strokeRoundedViewOffSlash,
                size: 25,
                color: colors.tertiary,
              ),
              onPressed: () {
                setState(() {
                  _showDescription = !_showDescription;
                });
              },
            ),
          ],
        ),
        if (_showDescription) ...[
          TextFormField(
            maxLines: 2,
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            style: GoogleFonts.raleway(color: colors.secondary, fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              hint: Text(
                widget.hintText,
                style: TextStyle(
                  color: colors.secondary.withValues(alpha: 0.3),
                  fontSize: 16,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Icon(widget.icon, color: colors.tertiary, size: 20),
              ),
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
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorStyle: const TextStyle(backgroundColor: Colors.transparent),
            ),
          ),
        ],
      ],
    );
  }
}
