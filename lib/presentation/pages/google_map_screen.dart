// lib/presentation/pages/travel_route_page.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme_color/app_colors.dart';

class TravelRouteArgs {
  final LatLng origin;
  final LatLng destination;
  final String title;
  final List<LatLng> waypoints;

  const TravelRouteArgs({
    required this.origin,
    required this.destination,
    required this.title,
    this.waypoints = const [],
  });
}

class TravelRoutePage extends StatefulWidget {
  const TravelRoutePage({super.key});

  @override
  State<TravelRoutePage> createState() => _TravelRoutePageState();
}

class _TravelRoutePageState extends State<TravelRoutePage> {
  // ----- Config -----
  static const double _kMaxDistanceKmForDirections = 2000;

  // ----- State -----
  final _ctl = Completer<GoogleMapController>();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _ran = false; // evita chamadas repetidas
  late final TravelRouteArgs _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ran) return;
    _ran = true;
    _args = ModalRoute.of(context)!.settings.arguments as TravelRouteArgs;
    _draw();
  }

  // ----- Helpers -----
  double _deg2rad(double d) => d * math.pi / 180.0;

  double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLng = _deg2rad(b.longitude - a.longitude);
    final la1 = _deg2rad(a.latitude);
    final la2 = _deg2rad(b.latitude);
    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(la1) * math.cos(la2) * math.sin(dLng / 2) * math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return R * c;
  }

  LatLngBounds _bounds(List<LatLng> pts) {
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
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
      geodesic: true, // “reta” geodésica (melhor visual em longas distâncias)
    );
  }

  Future<void> _draw() async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('MAPS_API_KEY ausente no .env');
      return;
    }

    // Distância total, considerando waypoints como “pernas”
    final legs = <LatLng>[_args.origin, ..._args.waypoints, _args.destination];
    double totalKm = 0;
    for (int i = 0; i < legs.length - 1; i++) {
      totalKm += _haversineKm(legs[i], legs[i + 1]);
    }

    List<LatLng> coords = [];

    // Tenta Directions apenas se a distância não for absurda
    if (totalKm <= _kMaxDistanceKmForDirections) {
      final polylinePoints = PolylinePoints(apiKey: apiKey);
      final wp = _args.waypoints
          .map(
            (w) => PolylineWayPoint(
              location: '${w.latitude},${w.longitude}',
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
          wayPoints: wp,
          // optimizeWaypoints: true,
        ),
      );

      if (result.points.isNotEmpty) {
        coords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(growable: false);
      } else {
        debugPrint('Directions vazio: ${result.errorMessage}');
      }
    }

    // Fallback: desenha linha reta (origin -> waypoints -> dest)
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
            (e) => Marker(
              markerId: MarkerId('wp${e.key}'),
              position: e.value,
              infoWindow: InfoWindow(title: 'Parada ${e.key + 1}'),
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

    // Caso Directions tenha funcionado
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
          (e) => Marker(
            markerId: MarkerId('wp${e.key}'),
            position: e.value,
            infoWindow: InfoWindow(title: 'Parada ${e.key + 1}'),
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
          style: GoogleFonts.raleway(color: colors.tertiary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (c) => _ctl.complete(c),
        initialCameraPosition: CameraPosition(target: _args.origin, zoom: 12),
        markers: _markers,
        polylines: _polylines,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
