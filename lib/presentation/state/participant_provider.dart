import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/participant.dart';
import '../../generated/l10n.dart';

///
class ParticipantProvider extends ChangeNotifier {
  final List<Participant> _participants = [];
  int _nextId = 1;
  File? _selectedImage;

  /// Controller for the name input field.
  final nameController = TextEditingController();

  /// Controller for the email input field.
  final emailController = TextEditingController();

  /// Gets the list of participants.
  List<Participant> get participants => List.unmodifiable(_participants);

  /// Gets the selected image.
  File? get selectedImage => _selectedImage;

  int _generateId() => _nextId++;


  /// Converts the form data to a list of [Participant] entities.
  List<Participant> toEntity(int travelId) {
    return _participants.map((participant) {
      return participant.copyWith(travelId: travelId);
    }).toList();
  }

  /// Sets the selected image and notifies listeners.
  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  /// Adds a new [Participant] to the list of participants.
  void addParticipant(Participant participant) {
    _participants.add(participant);

    for (var participant in _participants) {
      print(participant.name);
      print(participant.email);
      print(participant.photo);
    }

    notifyListeners();
  }

  void updateParcipant(Participant oldParticipant, Participant participant) {
    final index = _participants.indexOf(oldParticipant);
    _participants[index] = participant;
    notifyListeners();
  }

  void delteParticipant(Participant participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    _selectedImage = null;
  }

  /// Validates all form fields using the given [formKey].
  bool validateAll(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  /// Checks if the [Participant.name] matches the required rules:
  /// cannot be empty
  /// min length of 3 chars
  /// cannot contain special characters
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.nameRequired;
    }
    if (value.length < 3) {
      return S.current.nameTooShort;
    }
    if (value.contains(RegExp(r'[0-9!@#<>?":_`~;\[\]\\|=+)(*&^%\-]'))) {
      return 'Nome Inválido (!@#<>?&^%123...)';
    }
    return null;
  }

  /// Checks if the [Participant.email] matches the required rules:
  /// cannot be empty
  /// must contain @
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.emailRequired;
    }
    if (!value.contains('@')) {
      return S.current.emailInvalid;
    }
    return null;
  }
}
