import 'package:flutter/material.dart';
import '../../../domain/usecases/profile_usecase.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/profile_repository_impl.dart';
import '../../pages/getstarted_screen.dart';
import '../../theme_color/app_colors.dart';

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
            _ConfirmDeleteDialog()
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

/// A confirmation dialog
/// That asks the user if they really want to delete their profile.
class _ConfirmDeleteDialog extends StatelessWidget {
  /// Creates a custom [_ConfirmDeleteDialog].
  const _ConfirmDeleteDialog();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AlertDialog(
      backgroundColor: colors.primary,
      title: Text(S.of(context).deleteAccountAsk),
      content: Text(S.of(context).deleteMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: colors.secondary),
          ),
        ),
        TextButton(
          onPressed: () async {
            final repository = ProfileRepositoryImpl();
            final useCase = ProfileUseCase(repository);

            await useCase.delete();
            if (!context.mounted) return;
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => GetStartedScreen()),
                  (route) => false,
            );
          },
          child: Text(
            S.of(context).delete,
            style: TextStyle(color: colors.secondary),
          ),
        ),
      ],
    );
  }
}
