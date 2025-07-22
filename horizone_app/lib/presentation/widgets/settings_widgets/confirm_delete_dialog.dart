import 'package:flutter/material.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../database/daos/profile_dao.dart';
import '../../../domain/usecases/profile_usecase.dart';
import '../../../generated/l10n.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key, required this.profileDao});

  final ProfileDao profileDao;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(S.of(context).deleteAccountAsk),
        content: Text(S.of(context).deleteMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(S.of(context).cancel, style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
        TextButton(
          onPressed: () async {

            final dao = ProfileDao();
            final repository = ProfileRepositoryImpl(dao);
            final useCase = ProfileUseCase(repository);

            await useCase.delete();
            if (context.mounted) {
              Navigator.pushNamed(context, '/getStarted');
            }
          },
          child: Text(S.of(context).delete, style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ],
    );
  }
}
