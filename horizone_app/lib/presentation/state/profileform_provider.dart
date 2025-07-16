
import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

class ProfileFormProvider extends ChangeNotifier {

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  final jobTitleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }


  bool validateAll(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty){
      return S.current.nameRequired;
    }
    if (value.length < 3) {
      return S.current.nameTooShort;
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.isEmpty){
      return S.current.bioRequired;
    }
    if (value.length < 10) {
      return S.current.bioTooShort;
    }
    return null;
  }

  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.dateOfBirthRequired;
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.genderRequired;
    }
    return null;
  }

  String? validateJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.jobTitleRequired;
    }
    return null;
  }
}