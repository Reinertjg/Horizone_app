import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

/// A service for getting route points between two coordinates.
class RouteService {
  late final PolylinePoints _polylinePoints;

  /// Creates a [RouteService] instance.
  RouteService() {
    final key = dotenv.env['MAPS_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('MAPS_API_KEY not defined in .env');
    }
    _polylinePoints = PolylinePoints(apiKey: key);
  }

  /// Gets the route points between the origin and destination coordinates.
  Future<List<PointLatLng>> getRoutePoints({
    required PointLatLng origin,
    required PointLatLng destination,
    List<PointLatLng> waypoints = const [],
  }) async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      // ignore: deprecated_member_use
      request: PolylineRequest(
        origin: origin,
        destination: destination,
        mode: TravelMode.driving,
        wayPoints: waypoints
            .map(
              (w) => PolylineWayPoint(
                location: '${w.latitude},${w.longitude}',
                stopOver: true,
              ),
            )
            .toList(),
      ),
    );

    if (result.points.isEmpty) {
      return [];
    }
    return result.points;
  }
}
