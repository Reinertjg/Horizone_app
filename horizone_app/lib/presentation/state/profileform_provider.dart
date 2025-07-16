
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
      return 'Nome e obrigatorio';
    }
    if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.isEmpty){
      return 'Biografia e obrigatorio';
    }
    if (value.length < 10) {
      return 'A biografia deve ter pelo menos 10 caracteres.';
    }
    return null;
  }

  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'A data de nascimento é obrigatória.';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'O gênero é obrigatório.';
    }
    return null;
  }

  String? validateJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'O título de trabalho é obrigatório.';
    }
    return null;
  }
}