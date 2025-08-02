import 'package:flutter/cupertino.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

/// Provider class for managing the state and validation of the profile form.
class ProfileFormProvider extends ChangeNotifier {
  /// Controller for the name input field.
  final nameController = TextEditingController();

  /// Controller for the biography input field.
  final bioController = TextEditingController();

  /// Controller for the date of birth input field.
  final dateOfBirthController = TextEditingController();

  /// Controller for the gender input field.
  final genderController = TextEditingController();

  /// Controller for the job title input field.
  final jobTitleController = TextEditingController();

  /// Selected gender value.
  String? _gender;

  /// Gets the selected gender.
  String? get gender => _gender;

  /// Sets the gender property with the provided [value].
  set gender(String? value) {
    _gender = value;
    notifyListeners();
  }


  /// Disposes all text controllers to free up resources.
  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  /// Converts the form data into a [Profile] entity.
  Profile toEntity() {
    return Profile(
      name: nameController.text.trim(),
      biography: bioController.text.trim(),
      birthDate: dateOfBirthController.text.trim(),
      gender: _gender ?? '',
      jobTitle: jobTitleController.text.trim(),
    );
  }

  /// Validates all form fields using the given [formKey].
  bool validateAll(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  /// Checks if the [Profile.name] matches the required rules:
  /// cannot be empty / min length of 3 chars
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.nameRequired;
    }
    if (value.length < 3) {
      return S.current.nameTooShort;
    }
    return null;
  }

  /// Checks if the [Profile.biography] matches the required rules:
  /// cannot be empty / min length of 10 chars
  String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.bioRequired;
    }
    if (value.length < 10) {
      return S.current.bioTooShort;
    }
    return null;
  }

  /// Checks if the [Profile.birthDate] matches the required rules:
  /// cannot be empty
  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.dateOfBirthRequired;
    }
    return null;
  }

  /// Checks if the [Profile.gender] matches the required rules:
  /// cannot be empty
  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.genderRequired;
    }
    return null;
  }

  /// Checks if the [Profile.jobTitle] matches the required rules:
  /// cannot be empty
  String? validateJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.jobTitleRequired;
    }
    return null;
  }
}
