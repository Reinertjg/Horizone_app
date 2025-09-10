import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../presentation/theme_color/app_colors.dart';

/// Dialog for selecting an option.
class OptionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  /// Creates an [OptionDialog] widget.
  const OptionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return AlertDialog(
      backgroundColor: colors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(title, style: TextStyle(color: colors.quaternary)),
      titlePadding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      content: Text(message,  style: TextStyle(color: colors.quaternary)),
      actions: [
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // Typically cancel returns false
                },
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(color: colors.quaternary),
                ),
              ),
            ),
            const SizedBox(width: 8), // Adds space between buttons
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  buttonText,
                  style: TextStyle(color: colors.quaternary),
                ),
              ),
            ),
          ],
        )
      ],
      actionsPadding: const EdgeInsets.all(16.0),
    );
  }
}
