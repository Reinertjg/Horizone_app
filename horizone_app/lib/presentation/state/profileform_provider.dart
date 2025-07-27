import 'package:flutter/cupertino.dart';

import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

class ProfileFormProvider extends ChangeNotifier {
  /// Controllers for the form fields.
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  final jobTitleController = TextEditingController();

  /// Gender options.
  String? _gender;

  String? get gender => _gender;

  void setGender(String? value) {
    _gender = value;
  }

  /// Dispose the controller when the widget is disposed.
  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  /// Convert the form data to a [Profile] entity.
  Profile toEntity() {
    return Profile(
      name: nameController.text.trim(),
      biography: bioController.text.trim(),
      birthDate: dateOfBirthController.text.trim(),
      gender: _gender ?? '',
      jobTitle: jobTitleController.text.trim(),
    );
  }

  bool validateAll(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  /// Validators
  ///
  /// @param value The value to validate name
  /// @param value The value to validate bio
  /// @param value The value to validate date of birth
  /// @param value The value to validate gender
  /// @param value The value to validate job title
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.nameRequired;
    }
    if (value.length < 3) {
      return S.current.nameTooShort;
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
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
