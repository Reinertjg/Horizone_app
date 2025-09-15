import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/place_details_api.dart';
import '../../domain/entities/stop.dart';
import '../../domain/entities/travel.dart';
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

  /// The number of participants.
  int? participants;

  /// The selected means of transportation.
  String? meansOfTransportation;

  /// The selected experience type.
  String? experienceType;
  File? _image;

  /// The selected Place (latitude and longitude).
  PlacePoint? originPlace;

  /// The selected Place (latitude and longitude).
  PlacePoint? destinationPlace;

  /// The selected Place Label (name).
  String? originLabel;

  /// The selected Place Label (name).
  String? destinationLabel;

  /// Gets the trip title.
  String get getTitle => titleController.text.trim();

  /// Gets the selected image.
  File? get getImage => _image;

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
    participants = null;
    meansOfTransportation = null;
    experienceType = null;
  }

  /// Converts the form data to a [Travel] entity.
  Travel toEntity(int participants, int stops) {
    return Travel(
      image: getImage,
      title: titleController.text.trim(),
      startDate: startDateController.text.trim(),
      endDate: endDateController.text.trim(),
      meansOfTransportation: meansOfTransportation ?? '',
      numberOfParticipants: participants,
      experienceType: experienceType ?? '',
      numberOfStops: stops,
      originPlace: originPlace!,
      originLabel: originLabel!,
      destinationPlace: destinationPlace!,
      destinationLabel: destinationLabel!,
      rating: null,
      status: 'active',
    );
  }

  /// Sets the number of participants and notifies listeners.
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

  /// Sets the number of participants and notifies listeners.
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

  /// Validates the form data and returns a list of errors.
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

/// A class to represent a point with latitude and longitude.
class LatLngPoint {
  /// The latitude of the point.
  final double latitude;

  /// The longitude of the point.
  final double longitude;

  /// Creates a [LatLngPoint].
  LatLngPoint({required this.latitude, required this.longitude});
}
