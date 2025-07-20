import 'package:flutter/material.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../database/daos/profile_dao.dart';
import '../../../domain/usecases/profile_usecase.dart';

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

            final dao = ProfileDao();
            final repository = ProfileRepositoryImpl(dao);
            final useCase = ProfileUseCase(repository);

            await useCase.delete();
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
