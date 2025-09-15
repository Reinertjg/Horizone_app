import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// A client for the Google Places API, specifically for fetching place details.
class PlaceDetailsApi {
  /// The API key for accessing Google Cloud services.
  final String apiKey;

  /// Creates an instance of [PlaceDetailsApi].
  PlaceDetailsApi(this.apiKey);

  /// Retrieves the latitude and longitude for a given [placeId].
  Future<LatLng?> getLatLngFromPlaceId(String placeId) async {
    final url = Uri.parse(
      'https://places.googleapis.com/v1/places/$placeId?fields=location',
    );
    final resp = await http.get(
      url,
      headers: {'X-Goog-Api-Key': apiKey, 'X-Goog-FieldMask': 'location'},
    );
    if (resp.statusCode != 200) return null;

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final loc = data['location'];
    if (loc == null) return null;
    return LatLng(
      (loc['latitude'] as num).toDouble(),
      (loc['longitude'] as num).toDouble(),
    );
  }
}
