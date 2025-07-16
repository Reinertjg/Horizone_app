  import 'package:flutter/material.dart';

  import '../../database/daos/profile_dao.dart';

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
      return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            Navigator.pushReplacementNamed(context, pathRoute);
          }
          // await profileDao.insertPorfile(
          //   {
          //     'name': 'John Doe',
          //     'biography': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          //     'birthDate': '1990-01-01',
          //     'gender': 'Male',
          //     'jobTitle': 'Software Engineer'
          //   }
          // );
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
