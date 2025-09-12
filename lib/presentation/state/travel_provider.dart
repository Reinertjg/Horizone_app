import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/place_details_api.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/stop.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';

/// Provider class responsible for managing the form state and logic
/// related to a trip interview process.
class TravelProvider extends ChangeNotifier {
  /// Controller for the trip title input field.
  final titleController = TextEditingController();

  /// Controller for the trip start date input field.
  final startDateController = TextEditingController();

  /// Controller for the trip end date input field.
  final endDateController = TextEditingController();

  // /// Controller for the number of participants input field.
  // final numberOfParticipantsController = 0;

  int? _participants;
  String? _meansOfTransportation;
  String? _experienceType;
  File? _image;
  PlacePoint? _originPlace;
  PlacePoint? _destinationPlace;
  String? _originLabel;
  String? _destinationLabel;

  /// Gets the trip title.
  String? get getTitle => titleController.text.trim();

  /// Gets the number of participants.
  int? get participants => _participants;

  /// Gets the selected means of transportation.
  String? get meansOfTransportation => _meansOfTransportation;

  /// Gets the selected experience type.
  String? get experienceType => _experienceType;

  /// Gets the selected Place (latitude and longitude).
  PlacePoint? get originPlace => _originPlace;

  /// Gets the selected Place (latitude and longitude).
  PlacePoint? get destinationPlace => _destinationPlace;

  /// Gets the selected Place Label (name).
  String? get originLabel => _originLabel;

  /// Gets the selected Place Label (name).
  String? get destinationLabel => _destinationLabel;

  /// Gets the selected image.
  File? get getImage => _image;

  /// Sets the number of participants and notifies listeners.
  set participants(int? value) {
    _participants = value;
  }

  /// Sets the means of transportation and notifies listeners.
  set meansOfTransportation(String? value) {
    _meansOfTransportation = value;
  }

  /// Sets the experience type and notifies listeners.
  set experienceType(String? value) {
    _experienceType = value;
  }

  /// Sets the origin place and notifies listeners.
  set originPlace(PlacePoint? value) {
    _originPlace = value;
  }

  /// Sets the destination place and notifies listeners.
  set destinationPlace(PlacePoint? value) {
    _destinationPlace = value;
  }

  /// Sets the origin label and notifies listeners.
  set originLabel(String? value) {
    _originLabel = value;
  }

  /// Sets the destination label and notifies listeners.
  set destinationLabel(String? value) {
    _destinationLabel = value;
  }

  /// Sets the image and notifies listeners.
  void setImage(File? value) {
    _image = value;
    notifyListeners();
  }

  /// Disposes all controllers when the provider is destroyed.
  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  /// Resets all form fields to their initial state.
  void reset() {
    titleController.clear();
    startDateController.clear();
    endDateController.clear();
    _participants = null;
    _meansOfTransportation = null;
    _experienceType = null;
  }

  /// Converts the form data to a [Travel] entity.
  Travel toEntity(int participants, int stops) {
    return Travel(
      image: getImage,
      title: titleController.text.trim(),
      startDate: startDateController.text.trim(),
      endDate: endDateController.text.trim(),
      meansOfTransportation: _meansOfTransportation ?? '',
      numberOfParticipants: participants,
      experienceType: _experienceType ?? '',
      numberOfStops: stops,
      originPlace: _originPlace.toString(),
      originLabel: _originLabel!,
      destinationPlace: _destinationPlace.toString(),
      destinationLabel: _destinationLabel!,
      rating: 0.0,
      status: 'active',
    );
  }

  Future<void> resolveAndSetOrigin({
    required String placeId,
    required String label,
  }) async {
    final latLng = await _fetchLatLng(placeId);
    if (latLng == null) return;
    originLabel = label;
    originPlace = PlacePoint(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }

  Future<void> resolveAndSetDestination({
    required String placeId,
    required String label,
  }) async {
    final latLng = await _fetchLatLng(placeId);
    if (latLng == null) return;
    destinationLabel = label;
    destinationPlace = PlacePoint(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }

  Future<LatLngPoint?> _fetchLatLng(String placeId) async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return null;
    final details = PlaceDetailsApi(apiKey);
    final ll = await details.getLatLngFromPlaceId(placeId);
    if (ll == null) return null;
    return LatLngPoint(latitude: ll.latitude, longitude: ll.longitude);
  }

  bool validateOverlap(List<Travel> travels, DateTime start, DateTime end) {
    for (final t in travels) {
      final travelStartDate = DateTime.parse(t.startDate);
      final travelEndDate = DateTime.parse(t.endDate);
      final overlap =
          start.isBefore(travelEndDate) && travelStartDate.isBefore(end);
      if (overlap) return true;
    }
    return false;
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
      setImage(file);
    }
  }

  /// Validates the title field.
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  /// Validates the start date field.
  String? validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start date is required';
    }
    return null;
  }

  /// Validates the end date field.
  String? validateEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'End date is required';
    }
    return null;
  }

  /// Validates the means of transportation field.
  String? validateMeansOfTransportation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Means of transportation is required';
    }
    return null;
  }

  /// Validates the number of participants field.
  String? validateNumberOfParticipants(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of participants is required';
    }
    return null;
  }

  /// Validates the experience type field.
  String? validateExperienceType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Experience type is required';
    }
    return null;
  }

  /// Validates the origin place field.
  String? validateOriginPlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Origin place is required';
    }
    return null;
  }

  /// Validates the destination place field.
  String? validateDestinationPlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Destination place is required';
    }
    return null;
  }
}

class LatLngPoint {
  final double latitude;
  final double longitude;

  LatLngPoint({required this.latitude, required this.longitude});
}
