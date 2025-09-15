import 'dart:convert';
import 'package:http/http.dart' as http;

/// A client for the Horizone places API.
class PlacesApiClient {
  /// The base URL for the API.
  final String baseUrl;
  final http.Client _client;

  /// Creates a new [PlacesApiClient].
  PlacesApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  /// Fetches autocomplete suggestions for a given [input].
  Future<List<Map<String, dynamic>>> autocomplete({
    required String input,
    String? sessionToken,
    List<String>? regionCodes,
  }) async {
    final body = <String, dynamic>{
      'input': input,
      'sessionToken': sessionToken,
    };
    if (regionCodes != null && regionCodes.isNotEmpty) {
      body['includedRegionCodes'] = regionCodes;
    }

    final uri = Uri.parse('$baseUrl/places/autocomplete');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );
    if (resp.statusCode != 200) {
      throw Exception('BFF error: ${resp.statusCode} ${resp.body}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return (data['suggestions'] as List? ?? []).cast<Map<String, dynamic>>();
  }
}
