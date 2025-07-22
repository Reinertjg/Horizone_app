import 'package:flutter/material.dart';
import '../../../database/daos/profile_dao.dart';
import '../../../generated/l10n.dart';
import 'confirm_delete_dialog.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key, required this.profileDao});

  final ProfileDao profileDao;

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
            ConfirmDeleteDialog(profileDao: profileDao)
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
