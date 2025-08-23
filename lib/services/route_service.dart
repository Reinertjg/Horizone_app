import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RouteService {
  late final PolylinePoints _polylinePoints;

  RouteService() {
    final key = dotenv.env['MAPS_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('MAPS_API_KEY não definido no .env');
    }
    _polylinePoints = PolylinePoints(apiKey: key);
  }

  /// Retorna os pontos decodificados da rota (em ordem) entre origem -> destino,
  /// com waypoints intermediários (se houver).
  Future<List<PointLatLng>> getRoutePoints({
    required PointLatLng origin,
    required PointLatLng destination,
    List<PointLatLng> waypoints = const [],
  }) async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: origin,
        destination: destination,
        mode: TravelMode.driving,
        wayPoints: waypoints
            .map((w) => PolylineWayPoint(location: '${w.latitude},${w.longitude}', stopOver: true))
            .toList(),
        // optional:
        // optimizeWaypoints: true, // reordena os waypoints para rota ótima
        // avoidTolls: true,
        // avoidHighways: true,
      ),
    );

    if (result.points.isEmpty) {
      // debugPrint('Directions error: ${result.errorMessage}');
      return [];
    }
    return result.points;
  }
}
