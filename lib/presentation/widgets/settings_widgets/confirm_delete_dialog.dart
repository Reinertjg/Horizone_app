import 'package:flutter/material.dart';
import '../../../domain/usecases/profile_usecase.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/profile_repository_impl.dart';
import '../../pages/getstarted_screen.dart';
import '../../theme_color/app_colors.dart';

/// A confirmation dialog
/// That asks the user if they really want to delete their profile.
///
/// When confirmed, the profile is deleted from the local database and the user
/// is redirected to the get started screen.
class ConfirmDeleteDialog extends StatelessWidget {
  /// Creates a custom [ConfirmDeleteDialog].
  const ConfirmDeleteDialog({super.key});

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
