import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../../generated/l10n.dart';
import '../../repositories/profile_repository_impl.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';

/// Provider class for managing the state and validation of the profile form.
class ProfileProvider extends ChangeNotifier {
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

  /// Date of birth value.
  DateTime? dateOfBirth;

  /// Selected image file.
  File? photo;

  /// Selected gender value.
  String? gender;

  /// Sets the selected image and notifies listeners.
  void setSelectedImage(File? image) {
    photo = image;
    notifyListeners();
  }

  /// Sets the date of birth and notifies listeners.
  void setDateOfBirth(DateTime date) {
    dateOfBirth = date;
    notifyListeners();
  }

  /// Picks an image from the camera or gallery based on the provided [mode].
  Future<void> pickImage(OptionPhotoMode mode) async {
    final picker = ImagePicker();
    final source = mode == OptionPhotoMode.cameraMode
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setSelectedImage(file);
    }
  }

  /// Updates the profile picture based on the provided [mode] and [id].
  Future<bool> pickImageData(OptionPhotoMode mode, int id) async {
    final repository = ProfileRepositoryImpl();
    final picker = ImagePicker();
    final source = mode == OptionPhotoMode.cameraMode
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await repository.updateProfilePicture(id, file);
      return true;
    } else {
      return false;
    }
  }

  /// Loads the profile data from the repository.
  Future<void> loadProfileData() async {
    final repository = ProfileRepositoryImpl();
    final useCase = ProfileUseCase(repository);
    final profiles = await useCase.getAll();
    if (profiles.isNotEmpty) {
      final profile = profiles.first;
      nameController.text = profile.name;
      bioController.text = profile.biography;
      dateOfBirthController.text = profile.birthDate;
      gender = profile.gender;
      jobTitleController.text = profile.jobTitle;
      photo = profile.photo;
    }
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
      id: 1,
      name: nameController.text.trim(),
      biography: bioController.text.trim(),
      birthDate: dateOfBirthController.text.trim(),
      gender: gender ?? '',
      jobTitle: jobTitleController.text.trim(),
      photo: photo,
    );
  }

  /// Submits the profile form data to the server.
  Future<void> submitProfile(BuildContext context) async {
    final profile = toEntity();
    final repository = ProfileRepositoryImpl();
    final useCase = ProfileUseCase(repository);

    await useCase.insert(profile);
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
