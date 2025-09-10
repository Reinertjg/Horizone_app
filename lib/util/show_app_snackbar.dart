import 'package:flutter/material.dart';

/// Enum representing the modes of the snackbar.
enum SnackbarMode {
  /// Success mode.
  success,

  /// Error mode.
  error,

  /// Info mode.
  info,
}

/// Displays a custom snackbar.
void showAppSnackbar({
  required BuildContext context,
  required SnackbarMode snackbarMode,
  required IconData iconData,
  required String message,
}) {
  // Remove any existing snackbar before showing a new one.
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  late final Color backgroundColor;
  late final Color textColor;

  switch (snackbarMode) {
    case SnackbarMode.success:
      backgroundColor = Colors.green[600]!;
      textColor = Colors.white;
      break;
    case SnackbarMode.error:
      backgroundColor = Colors.red[600]!;
      textColor = Colors.white;
      break;
    case SnackbarMode.info:
      backgroundColor = Colors.yellow[600]!;
      textColor = Colors.black;
      break;
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(iconData, color: textColor, size: 25),
        const SizedBox(width: 12),
        Text(message, style: TextStyle(color: textColor)),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
