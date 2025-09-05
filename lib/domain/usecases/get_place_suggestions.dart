import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

/// Represents a service for fetching place suggestions
/// from the Google Places API.
class PlacesService {
  /// The API key for the Google Places API.
  final String apiKey;
  final _uuid = const Uuid();
  String _sessionToken = '';

  /// Creates a new [PlacesService] object.
  PlacesService({required this.apiKey});

  /// Fetches place suggestions based on the given input.
  Future<List<Map<String, String>>> fetchSuggestions(String input) async {
    if (input.trim().length < 2) return [];

    _sessionToken = _sessionToken.isEmpty ? _uuid.v4() : _sessionToken;

    final uri = Uri.https('places.googleapis.com', '/v1/places:autocomplete');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'suggestions.placePrediction.placeId,suggestions.placePrediction.text',
        'X-Goog-Maps-Platform-Session-Token': _sessionToken,
      },
      body: jsonEncode({'input': input}),
    );

    if (resp.statusCode != 200) return [];

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final list = (data['suggestions'] as List? ?? [])
        .map((e) => e['placePrediction'])
        .where((p) => p != null)
        .map(
          (p) => {
            'placeId': p['placeId'] as String,
            'description': (p['text']?['text'] as String?) ?? '',
          },
        )
        .toList();

    return list;
  }

  /// Resets the session token for the next request.
  void resetSession() {
    _sessionToken = '';
  }
}
