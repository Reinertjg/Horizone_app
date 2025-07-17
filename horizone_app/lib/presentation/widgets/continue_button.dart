  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

  import '../../database/daos/profile_dao.dart';
import '../state/profileform_provider.dart';

  class ContinueButton extends StatelessWidget {
    ContinueButton({
      required this.title,
      required this.pathRoute,
      required this.formKey,
      super.key,
    });

    final String title;
    final String pathRoute;
    final profileDao = ProfileDao();
    final GlobalKey<FormState> formKey;

    @override
    Widget build(BuildContext context) {
      final formProvider = Provider.of<ProfileFormProvider>(context);

      return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await profileDao.insertPorfile(
                {
                  'name': formProvider.nameController.text,
                  'biography': formProvider.bioController.text,
                  'birthDate': formProvider.dateOfBirthController.text,
                  'gender': formProvider.genderController.text,
                  'jobTitle': formProvider.jobTitleController.text
                }
            );
            Navigator.pushReplacementNamed(context, pathRoute);
          }

          print(formProvider.nameController.text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
