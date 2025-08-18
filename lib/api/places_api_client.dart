import 'dart:convert';
import 'package:http/http.dart' as http;

// Para Opção A, passe a URL do seu BFF ao instanciar.
class PlacesApiClient {
  final String baseUrl;
  final http.Client _client;
  PlacesApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

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
      body['includedRegionCodes'] = regionCodes; // só envia se pedirem
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


