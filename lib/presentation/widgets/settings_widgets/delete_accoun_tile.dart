import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import 'confirm_delete_dialog.dart';

/// A widget that displays a red "Delete Account" text button.
///
/// Confirmation dialog before deleting the user's profile.
class DeleteAccountTile extends StatelessWidget {
  /// Creates a custom [DeleteAccountTile].
  const DeleteAccountTile({super.key});

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) =>
            ConfirmDeleteDialog()
        );
      },
      child: Text(
        S.of(context).deleteAccount,
        style: TextStyle(
          color: Color(0xFFA50101),
        ),
      ),
    );
  }
}
