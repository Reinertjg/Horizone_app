import 'package:flutter/material.dart';

import '../../../database/daos/profile_dao.dart';
import 'confirm_delete_dialog.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    final profileDao = ProfileDao();

    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
            ConfirmDeleteDialog(profileDao: profileDao,)
        );
      },
      child: Text(
        'Deletar Conta',
        style: TextStyle(
          color: Color(0xFFA50101),
        ),
      ),
    );
  }
}
