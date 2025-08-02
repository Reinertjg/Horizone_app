import 'package:flutter/material.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../domain/usecases/profile_usecase.dart';
import '../../../generated/l10n.dart';

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
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(S.of(context).deleteAccountAsk),
      content: Text(S.of(context).deleteMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            final repository = ProfileRepositoryImpl();
            final useCase = ProfileUseCase(repository);

            await useCase.delete();
            if (!context.mounted) return;
            await Navigator.pushNamed(context, '/getStarted');
          },
          child: Text(
            S.of(context).delete,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
