import 'package:flutter/cupertino.dart';

import '../../domain/entities/trip.dart';

class InterviewProvider extends ChangeNotifier {
  /// List of trips
  final titleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final numberOfParticipantsController = TextEditingController();

  int? _participants;
  String? _meansOfTransportation;
  String? _experienceType;

  int? get participants => _participants;

  String? get meansOfTransportation => _meansOfTransportation;

  String? get experienceType => _experienceType;

  /// Setters
  ///
  /// @param value The new value for the participants
  /// @param value The new value for the means of transportation
  /// @param value The new value for the experience type
  void setParticipants(int? value) {
    _participants = value;
    notifyListeners();
  }

  void setMeansOfTransportation(String? value) {
    _meansOfTransportation = value;
    notifyListeners();
  }

  void setExperienceType(String? value) {
    _experienceType = value;
    notifyListeners();
  }

  /// Dispose the controllers
  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    numberOfParticipantsController.dispose();
    super.dispose();
  }

  /// Convert the form data to an entity
  Trip toEntity() {
    return Trip(
      id: 0,
      title: titleController.text.trim(),
      startDate: startDateController.text.trim(),
      endDate: endDateController.text.trim(),
      meansOfTransportation: _meansOfTransportation ?? '',
      numberOfParticipants: int.parse(numberOfParticipantsController.text),
      experienceType: _experienceType ?? '',
    );
  }

  /// Validators
  ///
  /// @param value The value to validate
  /// @param value The value to validate start date
  /// @param value The value to validate end date
  /// @param value The value to validate means of transportation
  /// @param value The value to validate number of participants
  /// @param value The value to validate experience type
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start date is required';
    }
    return null;
  }

  String? validateEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'End date is required';
    }
    return null;
  }

  String? validateMeansOfTransportation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Means of transportation is required';
    }
    return null;
  }

  String? validateNumberOfParticipants(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of participants is required';
    }
    return null;
  }

  String? validateExperienceType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Experience type is required';
    }
    return null;
  }
}
