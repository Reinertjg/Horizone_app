import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/experience.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';

/// The provider for the experience screen.
class ExperienceProvider extends ChangeNotifier {
  /// The controller for the description field.
  final descriptionController = TextEditingController();

  /// The list of images for the experience.
  final List<File?> _images = List.generate(3, (_) => null);

  /// Returns the list of images for the experience.
  List<File?> get images => _images;

  /// Sets the selected image at the given index.
  void setSelectedImage(int index, File? image) {
    if (index >= 0 && index < _images.length) {
      _images[index] = image;
      notifyListeners();
    }
  }

  /// Adds a photo to the experience.
  void addPhoto(File image) {
    _images.add(image);
    notifyListeners();
  }

  /// Removes a photo from the experience.
  void removePhoto(int index) {
    if (index >= 1 && index <= 3) {
      _images[index] = null;
    }
    notifyListeners();
  }

  void clean() {
    descriptionController.clear();
    _images.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  /// Validates the experience form.
  bool validateAll(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  /// Validates the description field.
  String? validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma descrição.';
    }
    if (value.length < 20) {
      return 'A descrição deve ter no mínimo 20 caracteres.';
    }
    return null;
  }

  /// Returns true if at least one image is selected, false otherwise.
  bool imagesNotEmpty() {
    return _images.any((image) => image != null);
  }

  /// Picks an image from the camera or gallery.
  Future<void> pickImage(OptionPhotoMode mode, int photoNumber) async {
    final picker = ImagePicker();
    final source = mode == OptionPhotoMode.cameraMode
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setSelectedImage(photoNumber - 1, file);
    }
  }

  /// Converts the experience data to an [Experience] entity.
  Experience toEntity(int stopId) {
    return Experience(
      description: descriptionController.text.trim(),
      photo1: _images[0],
      photo2: _images[1],
      photo3: _images[2],
      stopId: stopId,
    );
  }
}
