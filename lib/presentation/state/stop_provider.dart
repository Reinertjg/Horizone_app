// lib/presentation/state/travel_stops_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../api/place_details_api.dart';
import '../../domain/entities/stop.dart';
import '../pages/google_map_screen.dart';

/// Provider responsible for managing travel stops and trip date rules,
/// as well as building route arguments for the map.
class StopProvider extends ChangeNotifier {
  /// Creates a [StopProvider] instance.
  StopProvider();

  final List<Stop> _stops = [];

  DateTime? _tripStart = DateTime.now();
  DateTime? _tripEnd;

  /// Current list of travel stops.
  List<Stop> get stops => List.unmodifiable(_stops);

  /// Number of travel stops.
  int get length => _stops.length;

  /// Planned start date of the trip.
  DateTime? get tripStart => _tripStart;

  /// Planned end date of the trip.
  DateTime? get tripEnd => _tripEnd;

  /// Converts the list of stops to a list of [Stop] entities.
  List<Stop> toEntity(int travelId) {
    return _stops.map((stop) {
      return stop.copyWith(travelId: travelId);
    }).toList();
  }

  /// Sets the trip start date.
  void setTripStart(DateTime date) {
    _tripStart = _normalize(date);
    if (_tripEnd != null && _tripEnd!.isBefore(_tripStart!)) {
      _tripEnd = _tripStart;
    }
    notifyListeners();
  }

  /// Sets the trip end date.
  void setTripEnd(DateTime date) {
    _tripEnd = _normalize(date);
    if (_tripStart != null && _tripEnd!.isBefore(_tripStart!)) {
      _tripStart = _tripEnd;
    }
    notifyListeners();
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
    final index = _stops.indexOf(stop);
    if (index == -1) return;
    _stops[index] = _stops[index].copyWith(
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

  /// Validates the stop label input.
  String? validateStopStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start date is required';
    }
    return null;
  }

  /// Validates the stop label input.
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
    for (final s in _stops) {
      if (_isValid(s.place)) {
        waypoints.add(LatLng(s.place.latitude, s.place.longitude));
      }
    }

    return TravelRouteArgs(
      origin: LatLng(origin!.latitude, origin.longitude),
      destination: LatLng(destination!.latitude, destination.longitude),
      waypoints: waypoints,
      title:
          '${_beforeComma(originLabel ?? '')} → '
                  '${_beforeComma(destinationLabel ?? '')}'
              .trim(),
    );
  }

  /// Sets the start date of a stop, clamping it between valid boundaries.
  void setStopStartDate(int order, DateTime value) {
    final index = _indexByOrder(order);
    if (index == -1) return;

    final minD = minStartFor(order);
    final maxD = maxStartFor(order);
    final safe = _clamp(_normalize(value), minD, maxD);

    _stops[index] = _stops[index].copyWith(startDate: safe);

    final end = _stops[index].endDate;
    if (end != null && end.isBefore(safe)) {
      _stops[index] = _stops[index].copyWith(endDate: safe);
    }
    notifyListeners();
  }

  /// Sets the end date of a stop, clamping it between valid boundaries.
  void setStopEndDate(int order, DateTime value) {
    final index = _indexByOrder(order);
    if (index == -1) return;

    final minD = minEndFor(order);
    final maxD = maxEndFor(order);
    final safe = _clamp(_normalize(value), minD, maxD);

    _stops[index] = _stops[index].copyWith(endDate: safe);

    final start = _stops[index].startDate;
    if (start != null && start.isAfter(safe)) {
      _stops[index] = _stops[index].copyWith(startDate: safe);
    }
    notifyListeners();
  }

  /// Minimum valid start date for a stop with the given order.
  DateTime minStartFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return _now();

    if (index == 0) return _tripStart ?? _now();

    final prevEnd = _stops[index - 1].endDate;
    return _normalize(prevEnd ?? (_tripStart ?? _now()));
  }

  /// Maximum valid start date for a stop with the given order.
  DateTime maxStartFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return DateTime(2100);

    if (index == _stops.length - 1) {
      return _normalize(_tripEnd ?? DateTime(2100));
    }

    final nextStart = _stops[index + 1].startDate;
    return _normalize(nextStart ?? (_tripEnd ?? DateTime(2100)));
  }

  /// Suggested initial start date for a stop with the given order.
  DateTime initialStartFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return _now();

    final base = _normalize(_stops[index].startDate ?? minStartFor(order));
    return _clamp(base, minStartFor(order), maxStartFor(order));
  }

  /// Minimum valid end date for a stop with the given order.
  DateTime minEndFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return _now();

    final start = _stops[index].startDate ?? minStartFor(order);
    return _normalize(start);
  }

  /// Maximum valid end date for a stop with the given order.
  DateTime maxEndFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return DateTime(2100);

    if (index == _stops.length - 1) {
      return _normalize(_tripEnd ?? DateTime(2100));
    }

    final nextStart = _stops[index + 1].startDate;
    return _normalize(nextStart ?? (_tripEnd ?? DateTime(2100)));
  }

  /// Suggested initial end date for a stop with the given order.
  DateTime initialEndFor(int order) {
    final index = _indexByOrder(order);
    if (index == -1) return _now();

    final base = _normalize(_stops[index].endDate ?? minEndFor(order));
    return _clamp(base, minEndFor(order), maxEndFor(order));
  }

  bool _isValid(PlacePoint? place) {
    return place != null && place.latitude != 0 && place.longitude != 0;
  }

  int _indexByOrder(int order) {
    return _stops.indexWhere((s) => s.order == order);
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

/// Returns the text before the first separator (comma, hyphen, or slash), if
/// present.
String _beforeComma(String text) {
  final i = text.indexOf(RegExp(r'[,/-]'));
  return (i == -1) ? text : text.substring(0, i);
}

