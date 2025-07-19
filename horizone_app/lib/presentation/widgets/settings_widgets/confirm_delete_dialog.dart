import 'package:flutter/material.dart';
import '../../../database/daos/profile_dao.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key, required this.profileDao});

  final ProfileDao profileDao;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Excluir conta ?'),
      content: const Text('Todos os dados seram apagados permanentemente.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await profileDao.deleteProfile();
            if (context.mounted) {
              Navigator.pushNamed(context, '/getStarted');
            }
          },
          child: const Text('Deletar'),
        ),
      ],
    );
  }
}
