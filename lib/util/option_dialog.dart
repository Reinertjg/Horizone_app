import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../generated/l10n.dart';
import '../presentation/theme_color/app_colors.dart';
import '../presentation/widgets/interview_widgets/interview_fab.dart';

/// Dialog for selecting an option.
class OptionDialog extends StatefulWidget {
  /// The title of the dialog.
  final String title;

  /// The message content of the dialog.
  final String message;

  /// The text for the confirmation button.
  final String buttonText;

  /// Creates an [OptionDialog].
  const OptionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
  });

  @override
  State<OptionDialog> createState() => _OptionDialogState();
}

class _OptionDialogState extends State<OptionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.raleway(color: colors.quaternary),
        ),
        titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        content: Text(
          widget.message,
          style: GoogleFonts.raleway(color: colors.quaternary),
        ),

        actions: [
          Row(
            children: <Widget>[
              Expanded(
                child: InterviewFab(
                  nameButton: S.of(context).cancel,
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InterviewFab(
                  nameButton: widget.buttonText,
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
