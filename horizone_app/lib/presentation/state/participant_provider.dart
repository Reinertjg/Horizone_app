import 'package:flutter/cupertino.dart';

import '../../domain/entities/participant.dart';
import '../../generated/l10n.dart';

///
class ParticipantProvider extends ChangeNotifier {
  final List<Participant> _participants = [];
  /// Controller for the name input field.
  final nameController = TextEditingController();

  /// Controller for the email input field.
  final emailController = TextEditingController();

  List<Participant> get participants => List.unmodifiable(_participants);

  /// Adds a new [Participant] to the list of participants.
  void addParticipant(Participant participant) {
   _participants.add(participant);
   notifyListeners();
  }

  void updateParcipant(int index, Participant participant) {
    _participants[index] = participant;
    notifyListeners();
  }

  void delteParticipant(int index, Participant participantr){
    _participants.removeAt(index);
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
