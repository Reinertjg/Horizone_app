// lib/presentation/state/travel_stops_provider.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../api/place_details_api.dart';
import '../../domain/entities/travelstop.dart';
import '../pages/google_map_screen.dart';
import '../pages/interview_screen.dart';

class TravelStopsProvider extends ChangeNotifier {
  /// Ordered list: index 0 = origin, last = destination, middle = waypoints.
  final List<TravelStop> _stops = [
    TravelStop(
      place: const PlacePoint(latitude: 0, longitude: 0),
      label: '',
      startDate: '',
      endDate: '',
      description: '',
    ),
    TravelStop(
      place: const PlacePoint(latitude: 0, longitude: 0),
      label: '',
      startDate: '',
      endDate: '',
      description: '',
    ),
  ];

  List<TravelStop> get stops => List.unmodifiable(_stops);

  int get length => _stops.length;

  /// Insert a new waypoint before the destination.
  void addStop() {
    _stops.insert(
      _stops.length - 1,
      TravelStop(
        place: const PlacePoint(latitude: 0, longitude: 0),
        label: '',
        startDate: '',
        endDate: '',
        description: '',
      ),
    );
    notifyListeners();
  }

  /// Remove a stop (keeps at least origin + destination).
  void removeStop(int index) {
    if (_stops.length <= 2) return;
    if (index <= 0 || index >= _stops.length - 1) return; // avoid deleting origin/destination
    _stops.removeAt(index);
    notifyListeners();
  }

  /// Update label only (typically from UI text or autocomplete description).
  void updateLabel(int index, String label) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = TravelStop(
      travelStopId: s.travelStopId,
      place: s.place,
      label: label,
      startDate: s.startDate,
      endDate: s.endDate,
      description: s.description,
    );
    notifyListeners();
  }

  /// Replace coordinates when resolving placeId -> LatLng externally.
  void updateLatLng(int index, LatLng latLng) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = TravelStop(
      travelStopId: s.travelStopId,
      place: PlacePoint(latitude: latLng.latitude, longitude: latLng.longitude),
      label: s.label,
      startDate: s.startDate,
      endDate: s.endDate,
      description: s.description,
    );
    notifyListeners();
  }

  void updateDates(int index, {String? start, String? end}) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = TravelStop(
      travelStopId: s.travelStopId,
      place: s.place,
      label: s.label,
      startDate: start ?? s.startDate,
      endDate: end ?? s.endDate,
      description: s.description,
    );
    notifyListeners();
  }

  void updateDescription(int index, String notes) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = TravelStop(
      travelStopId: s.travelStopId,
      place: s.place,
      label: s.label,
      startDate: s.startDate,
      endDate: s.endDate,
      description: notes,
    );
    notifyListeners();
  }

  void _ensureIndex(int index) {
    if (index < 0 || index >= _stops.length) {
      throw RangeError('Invalid stop index $index');
    }
  }

  /// Build TravelRouteArgs for the map using current stops.
  /// Assumes index 0 = origin, last = destination.
  TravelRouteArgs? buildRouteArgs() {
    if (_stops.length < 2) return null;

    final o = _stops.first.place;
    final d = _stops.last.place;

    // origem/destino precisam estar resolvidos (não 0,0)
    final hasOrigin = !(o.latitude == 0 && o.longitude == 0);
    final hasDest   = !(d.latitude == 0 && d.longitude == 0);
    if (!hasOrigin || !hasDest) return null;

    final origin = LatLng(o.latitude, o.longitude);
    final destination = LatLng(d.latitude, d.longitude);

    // middle waypoints: apenas os que não são (0,0)
    final waypoints = <LatLng>[];
    for (int i = 1; i < _stops.length - 1; i++) {
      final p = _stops[i].place;
      final valid = !(p.latitude == 0 && p.longitude == 0);
      if (valid) waypoints.add(LatLng(p.latitude, p.longitude));
    }

    final title =
        '${StringUtils.beforeComma(_stops.first.label)} → ${StringUtils.beforeComma(_stops.last.label)}';

    return TravelRouteArgs(
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      title: title,
    );
  }


  /// Resolve a Google placeId and update a stop with its coordinates + label.
  Future<void> resolveAndSetPlace({
    required int index,
    required String placeId,
    required String label,
  }) async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;
    final details = PlaceDetailsApi(apiKey);

    final latLng = await details.getLatLngFromPlaceId(placeId);
    if (latLng == null) return;

    updateLabel(index, label);
    updateLatLng(index, latLng);
  }
}
