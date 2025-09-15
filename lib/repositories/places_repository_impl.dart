import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/place_suggestion.dart';
import '../../domain/repositories/places_repository.dart';

/// Implementation of the [PlacesRepository] interface.
class PlacesRepositoryImpl implements PlacesRepository {
  /// API key for Google Places API.
  final String apiKey;

  /// HTTP client to make requests.
  final http.Client httpClient;

  /// Creates a [PlacesRepositoryImpl].
  PlacesRepositoryImpl({required this.apiKey, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  @override
  Future<List<PlaceSuggestion>> fetchSuggestions({
    required String input,
    List<String>? regionCodes,
    String? sessionToken,
  }) async {
    final uri = Uri.https('places.googleapis.com', '/v1/places:autocomplete');

    final resp = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'X-Goog-Api-Key': apiKey,
        // FieldMask reduz payload.
        'X-Goog-FieldMask':
            'suggestions.placePrediction.placeId,'
            'suggestions.placePrediction.text',
        if (sessionToken != null && sessionToken.isNotEmpty)
          'X-Goog-Maps-Platform-Session-Token': sessionToken,
      },
      body: jsonEncode({'input': input, 'includedRegionCodes': regionCodes}),
    );

    if (resp.statusCode != 200) return const [];

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final items = (data['suggestions'] as List? ?? [])
        .map((s) => s['placePrediction'])
        .where((p) => p != null);

    return items
        .map<PlaceSuggestion>(
          (p) => PlaceSuggestion(
            placeId: p['placeId'] as String,
            description: (p['text']?['text'] as String?) ?? '',
          ),
        )
        .toList();
  }
}
