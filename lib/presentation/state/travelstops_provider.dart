// lib/presentation/state/travel_stops_provider.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/travelstop.dart';
import '../pages/google_map_screen.dart';
import '../../api/place_details_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TravelStopsProvider extends ChangeNotifier {
  TravelStopsProvider();

  // Agora: só waypoints
  final List<TravelStop> _stops = [];

  List<TravelStop> get stops => List.unmodifiable(_stops);
  int get length => _stops.length;

  void addStop() {
    _stops.add(
      TravelStop(
        place: const PlacePoint(latitude: 0, longitude: 0),
        label: '',
        startDate: null,
        endDate: null,
        description: '',
      ),
    );
    notifyListeners();
  }

  void removeStop(int index) {
    _ensureIndex(index);
    _stops.removeAt(index);
    notifyListeners();
  }

  void updateLabel(int index, String label) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = s.copyWith(label: label);
    notifyListeners();
  }

  void updateLatLng(int index, LatLng latLng) {
    _ensureIndex(index);
    final s = _stops[index];
    _stops[index] = s.copyWith(
      place: PlacePoint(latitude: latLng.latitude, longitude: latLng.longitude),
    );
    notifyListeners();
  }

  Future<void> resolveAndSetPlace({
    required int index,
    required String placeId,
    required String label,
  }) async {
    _ensureIndex(index);
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;

    final details = PlaceDetailsApi(apiKey);
    final latLng = await details.getLatLngFromPlaceId(placeId);
    if (latLng == null) return;

    updateLabel(index, label);
    updateLatLng(index, latLng);
  }

  // AGORA recebe origem/destino de fora (ex.: do InterviewProvider)
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
      '${beforeComma(originLabel ?? '')} → ${beforeComma(destinationLabel ?? '')}'.trim(),
    );
  }

  bool _isValid(PlacePoint? p) =>
      p != null && p.latitude != 0 && p.longitude != 0;

  void _ensureIndex(int index) {
    if (index < 0 || index >= _stops.length) {
      throw RangeError('Invalid stop index $index');
    }
  }
}

String beforeComma(String text) {
  final i = text.indexOf(',');
  return (i == -1) ? text : text.substring(0, i);
}
