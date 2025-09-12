// lib/presentation/pages/travel_route_page.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme_color/app_colors.dart';

/// Args for the [TravelRoutePage].
class TravelRouteArgs {
  /// The starting point of the route.
  final LatLng origin;

  /// The ending point of the route.
  final LatLng destination;

  /// The title to be displayed in the AppBar.
  final String title;

  /// A list of intermediate points (stops) between origin and destination.
  final List<LatLng> waypoints;

  /// Creates arguments for the travel route page.
  const TravelRouteArgs({
    required this.origin,
    required this.destination,
    required this.title,
    this.waypoints = const [],
  });
}

/// Page to show the route between two points.
class TravelRoutePage extends StatefulWidget {
  /// Creates a custom [TravelRoutePage].
  const TravelRoutePage({super.key});

  @override
  State<TravelRoutePage> createState() => _TravelRoutePageState();
}

class _TravelRoutePageState extends State<TravelRoutePage> {
  /// The maximum distance in kilometers for directions.
  static const double _kMaxDistanceKmForDirections = 2000;

  /// Controller for the Google Map.
  final _ctl = Completer<GoogleMapController>();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _ran = false;
  late final TravelRouteArgs _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ran) return;
    _ran = true;
    _args = ModalRoute.of(context)!.settings.arguments as TravelRouteArgs;
    _draw();
  }


  double _deg2rad(double degrees) => degrees * math.pi / 180.0;

  double _haversineKm(LatLng point1, LatLng point2) {
    const earthRadiusKm = 6371.0;
    final dLat = _deg2rad(point2.latitude - point1.latitude);
    final dLng = _deg2rad(point2.longitude - point1.longitude);
    final lat1Rad = _deg2rad(point1.latitude);
    final lat2Rad = _deg2rad(point2.latitude);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) * math.sin(dLng / 2) * math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  LatLngBounds _bounds(List<LatLng> pts) {
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final point in pts) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Polyline _straightPolyline(List<LatLng> pts) {
    return Polyline(
      polylineId: const PolylineId('route_straight'),
      points: pts,
      width: 5,
      geodesic: true,
    );
  }

  Future<void> _draw() async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('MAPS_API_KEY ausente no .env');
      return;
    }

    final legs = <LatLng>[_args.origin, ..._args.waypoints, _args.destination];
    double totalKm = 0;
    for (int i = 0; i < legs.length - 1; i++) {
      totalKm += _haversineKm(legs[i], legs[i + 1]);
    }


    var coords = <LatLng>[];

    if (totalKm <= _kMaxDistanceKmForDirections) {
      final polylinePoints = PolylinePoints(apiKey: apiKey);
      final waypoints = _args.waypoints
          .map(
            (waypoint) => PolylineWayPoint(
              location: '${waypoint.latitude},${waypoint.longitude}',
              stopOver: true,
            ),
          )
          .toList();

      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(_args.origin.latitude, _args.origin.longitude),
          destination: PointLatLng(
            _args.destination.latitude,
            _args.destination.longitude,
          ),
          mode: TravelMode.driving,
          wayPoints: waypoints,
          // optimizeWaypoints: true,
        ),
      );

      if (result.points.isNotEmpty) {
        coords = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(growable: false);
      } else {
        debugPrint('Directions vazio: ${result.errorMessage}');
      }
    }

    if (coords.isEmpty) {
      final straightPts = <LatLng>[
        _args.origin,
        ..._args.waypoints,
        _args.destination,
      ];

      setState(() {
        _polylines = {_straightPolyline(straightPts)};
        _markers = {
          Marker(
            markerId: const MarkerId('o'),
            position: _args.origin,
            infoWindow: const InfoWindow(title: 'Origem'),
          ),
          Marker(
            markerId: const MarkerId('d'),
            position: _args.destination,
            infoWindow: const InfoWindow(title: 'Destino'),
          ),
          ..._args.waypoints.asMap().entries.map(
            (entry) => Marker(
              markerId: MarkerId('wp${entry.key}'),
              position: entry.value,
              infoWindow: InfoWindow(title: 'Parada ${entry.key + 1}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
            ),
          ),
        };
      });

      final ctl = await _ctl.future;
      await ctl.animateCamera(
        CameraUpdate.newLatLngBounds(_bounds(straightPts), 60),
      );
      return;
    }

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: coords,
          width: 6,
        ),
      };
      _markers = {
        Marker(
          markerId: const MarkerId('o'),
          position: _args.origin,
          infoWindow: const InfoWindow(title: 'Origem'),
        ),
        Marker(
          markerId: const MarkerId('d'),
          position: _args.destination,
          infoWindow: const InfoWindow(title: 'Destino'),
        ),
        ..._args.waypoints.asMap().entries.map(
          (entry) => Marker(
            markerId: MarkerId('wp${entry.key}'),
            position: entry.value,
            infoWindow: InfoWindow(title: 'Parada ${entry.key + 1}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        ),
      };
    });

    final ctl = await _ctl.future;
    await ctl.animateCamera(CameraUpdate.newLatLngBounds(_bounds(coords), 60));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        centerTitle: true,
        title: Text(
          _args.title,
          style: GoogleFonts.raleway(
            color: colors.tertiary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _ctl.complete,
        initialCameraPosition: CameraPosition(target: _args.origin, zoom: 12),
        markers: _markers,
        polylines: _polylines,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
