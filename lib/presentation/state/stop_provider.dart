// lib/presentation/state/travel_stops_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../api/place_details_api.dart';
import '../../domain/entities/stop.dart';
import '../../util/string_utils.dart';
import '../pages/google_map_screen.dart';

/// Provider responsible for managing travel stops and trip date rules,
/// as well as building route arguments for the map.
class StopProvider extends ChangeNotifier {
  /// Creates a [StopProvider] instance.
  StopProvider();

  final List<Stop> _stops = [];

  DateTime? _tripStart;
  DateTime? _tripEnd;

  /// Current list of travel stops.
  List<Stop> get stops => List.unmodifiable(_stops);

  /// Number of travel stops.
  int get length => _stops.length;

  /// Planned start date of the trip.
  DateTime? get tripStart => _tripStart;

  /// Planned end date of the trip.
  DateTime? get tripEnd => _tripEnd;

  /// Reset the provider's state.
  void reset() {
    _stops.clear();
    _tripStart = null;
    _tripEnd = null;
    notifyListeners();
  }

  /// Clears all stop dates.
  void clearAllStopsDates(DateTime dateStartTravel, DateTime dateEndTravel) {
    for (var stopIndex = 0; stopIndex < _stops.length; stopIndex++) {
      _stops[stopIndex] = _stops[stopIndex].copyWith(
        startDate: dateStartTravel,
        endDate: dateEndTravel,
      );
    }
    notifyListeners();
  }

  /// Converts the list of stops to a list of [Stop] entities.
  List<Stop> toEntity(int travelId) {
    return _stops.map((stop) => stop.copyWith(travelId: travelId)).toList();
  }

  /// Sets the trip start date and shifts/clamps existing stops accordingly.
  void setTripStart(DateTime date) {
    final previousTripStart = _tripStart;
    _tripStart = _normalize(date);

    // Ensure end is not before start.
    if (_tripEnd != null && _tripEnd!.isBefore(_tripStart!)) {
      _tripEnd = _tripStart;
    }

    // If there was a previous start, shift all stops by the difference.
    if (previousTripStart != null) {
      final shiftSincePreviousStart = _tripStart!.difference(previousTripStart);
      if (shiftSincePreviousStart.inMinutes != 0) {
        _shiftStopsBy(shiftSincePreviousStart);
      }
    }

    _clampAndChainStops();
    notifyListeners();
  }

  /// Sets the trip end date and clamps existing stops to the new window.
  void setTripEnd(DateTime date) {
    _tripEnd = _normalize(date);

    // Ensure start is not after end.
    if (_tripStart != null && _tripEnd!.isBefore(_tripStart!)) {
      _tripStart = _tripEnd;
    }

    _clampAndChainStops();
    notifyListeners();
  }

  /// Shifts all stop dates (start/end) by a delta.
  void _shiftStopsBy(Duration delta) {
    if (delta.inMinutes == 0) return;

    for (var stopIndex = 0; stopIndex < _stops.length; stopIndex++) {
      final stop = _stops[stopIndex];

      final shiftedStart = stop.startDate != null
          ? _normalize(stop.startDate!.add(delta))
          : null;
      final shiftedEnd = stop.endDate != null
          ? _normalize(stop.endDate!.add(delta))
          : null;

      _stops[stopIndex] = stop.copyWith(
        startDate: shiftedStart,
        endDate: shiftedEnd,
      );
    }
  }

  /// Fits all stops inside [tripStart, tripEnd], ensures start ≤ end,
  /// and keeps sequence (each start ≥ previous end when both exist).
  void _clampAndChainStops() {
    var previousEndDate = _tripStart;

    for (var stopIndex = 0; stopIndex < _stops.length; stopIndex++) {
      final stop = _stops[stopIndex];
      var startDate = stop.startDate;
      var endDate = stop.endDate;

      if (startDate != null) {
        startDate = _clampToTripWindow(startDate);
        if (previousEndDate != null && startDate.isBefore(previousEndDate)) {
          startDate = previousEndDate;
        }
      }

      if (endDate != null) {
        endDate = _clampToTripWindow(endDate);
      }

      // Guarantee start ≤ end when both exist.
      if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
        endDate = startDate;
      }

      _stops[stopIndex] = stop.copyWith(startDate: startDate, endDate: endDate);

      // Chain: if this stop has an end, it becomes the new previousEndDate.
      if (endDate != null) {
        previousEndDate = endDate;
      }
    }
  }

  /// Clamp a DateTime to the trip window.
  DateTime _clampToTripWindow(DateTime date) {
    var clampedDate = date;
    if (_tripStart != null && clampedDate.isBefore(_tripStart!)) {
      clampedDate = _tripStart!;
    }
    if (_tripEnd != null && clampedDate.isAfter(_tripEnd!)) {
      clampedDate = _tripEnd!;
    }
    return _normalize(clampedDate);
  }

  /// Adds a new stop at the end of the list with sequential order.
  void addStop() {
    final lastOrder = _stops.isEmpty ? 0 : _stops.last.order;
    _stops.add(
      Stop(
        order: lastOrder + 1,
        place: const PlacePoint(latitude: 0, longitude: 0),
        label: '',
        startDate: null,
        endDate: null,
        description: '',
      ),
    );
    notifyListeners();
  }

  /// Removes a stop from the list.
  void removeStop(Stop stop) {
    _stops.remove(stop);
    notifyListeners();
  }

  /// Updates the coordinates and label of an existing stop.
  void updateStop(Stop stop, LatLng coords, String label) {
    final stopIndex = _stops.indexOf(stop);
    if (stopIndex == -1) return;

    _stops[stopIndex] = _stops[stopIndex].copyWith(
      label: label,
      place: PlacePoint(latitude: coords.latitude, longitude: coords.longitude),
    );
    notifyListeners();
  }

  /// Validates the stop place input.
  String? validateStopPlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Place is required';
    }
    return null;
  }

  /// Validates the stop start date input.
  String? validateStopStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start date is required';
    }
    return null;
  }

  /// Validates the stop end date input.
  String? validateStopEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'End date is required';
    }
    return null;
  }

  /// Resolves a placeId into coordinates and updates the stop.
  Future<void> resolveAndSetPlace({
    required Stop stop,
    required String placeId,
    required String label,
  }) async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;

    final details = PlaceDetailsApi(apiKey);
    final latLng = await details.getLatLngFromPlaceId(placeId);
    if (latLng == null) return;

    updateStop(stop, latLng, label);
  }

  /// Builds map route arguments from valid stops.
  TravelRouteArgs? buildRouteArgs({
    required PlacePoint? origin,
    required PlacePoint? destination,
    String? originLabel,
    String? destinationLabel,
  }) {
    if (!_isValid(origin) || !_isValid(destination)) return null;

    final waypoints = <LatLng>[];
    for (final stop in _stops) {
      if (_isValid(stop.place)) {
        waypoints.add(LatLng(stop.place.latitude, stop.place.longitude));
      }
    }

    return TravelRouteArgs(
      origin: LatLng(origin!.latitude, origin.longitude),
      destination: LatLng(destination!.latitude, destination.longitude),
      waypoints: waypoints,
      title:
          '${beforeComma(originLabel ?? '')} → '
                  '${beforeComma(destinationLabel ?? '')}'
              .trim(),
    );
  }

  /// Sets the start date of a stop, clamping it between valid boundaries.
  void setStopStartDate(int order, DateTime newDate) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return;

    final minStartAllowed = minStartFor(order);
    final maxStartAllowed = maxStartFor(order);
    final clampedStart = _clamp(
      _normalize(newDate),
      minStartAllowed,
      maxStartAllowed,
    );

    _stops[stopIndex] = _stops[stopIndex].copyWith(startDate: clampedStart);

    final existingEndDate = _stops[stopIndex].endDate;
    if (existingEndDate != null && existingEndDate.isBefore(clampedStart)) {
      _stops[stopIndex] = _stops[stopIndex].copyWith(endDate: clampedStart);
    }
    notifyListeners();
  }

  /// Sets the end date of a stop, clamping it between valid boundaries.
  void setStopEndDate(int order, DateTime newDate) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return;

    final minEndAllowed = minEndFor(order);
    final maxEndAllowed = maxEndFor(order);
    final clampedEnd = _clamp(
      _normalize(newDate),
      minEndAllowed,
      maxEndAllowed,
    );

    _stops[stopIndex] = _stops[stopIndex].copyWith(endDate: clampedEnd);

    final existingStartDate = _stops[stopIndex].startDate;
    if (existingStartDate != null && existingStartDate.isAfter(clampedEnd)) {
      _stops[stopIndex] = _stops[stopIndex].copyWith(startDate: clampedEnd);
    }
    notifyListeners();
  }

  /// Minimum valid start date for a stop with the given order.
  DateTime minStartFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == 0) return _tripStart ?? _now();
    if (stopIndex > 0) {
      return _stops[stopIndex - 1].endDate ?? _tripStart ?? _now();
    }
    return _tripStart ?? _now();
  }

  /// Maximum valid start date for a stop with the given order.
  DateTime maxStartFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return DateTime(2100);

    if (stopIndex == _stops.length - 1) {
      return _normalize(_tripEnd ?? DateTime(2100));
    }

    final nextStart = _stops[stopIndex + 1].startDate;
    return _normalize(nextStart ?? (_tripEnd ?? DateTime(2100)));
  }

  /// Suggested initial start date for a stop with the given order.
  DateTime? initialStartFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return null;
    return _stops[stopIndex].startDate;
  }

  /// Minimum valid end date for a stop with the given order.
  DateTime minEndFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return _now();

    final startOrMin = _stops[stopIndex].startDate ?? minStartFor(order);
    return _normalize(startOrMin);
  }

  /// Maximum valid end date for a stop with the given order.
  DateTime maxEndFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return DateTime(2100);

    if (stopIndex == _stops.length - 1) {
      return _normalize(_tripEnd ?? DateTime(2100));
    }

    final nextStart = _stops[stopIndex + 1].startDate;
    return _normalize(nextStart ?? (_tripEnd ?? DateTime(2100)));
  }

  /// Suggested initial end date for a stop with the given order.
  DateTime? initialEndFor(int order) {
    final stopIndex = _indexByOrder(order);
    if (stopIndex == -1) return null;
    return _stops[stopIndex].endDate;
  }

  bool _isValid(PlacePoint? place) {
    return place != null && place.latitude != 0 && place.longitude != 0;
  }

  int _indexByOrder(int order) {
    return _stops.indexWhere((stop) => stop.order == order);
  }

  DateTime _normalize(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      0,
      0,
      0,
    );
  }

  DateTime _clamp(DateTime date, DateTime min, DateTime max) {
    if (date.isBefore(min)) return min;
    if (date.isAfter(max)) return max;
    return date;
  }

  DateTime _now() {
    return _normalize(DateTime.now());
  }

  /// Formats a date to the "dd/MM/yyyy" format.
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
