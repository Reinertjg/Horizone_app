import 'package:flutter/material.dart';

/// Enum representing the modes of the snackbar.
enum SnackbarMode {
  /// Success mode.
  success,

  /// Error mode.
  error
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

  final backgroundColor = snackbarMode == SnackbarMode.success
      ? Colors.green[600]!
      : Colors.red[600]!;

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(iconData, color: Colors.white, size: 25),
        const SizedBox(width: 12),
        Text(message),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
