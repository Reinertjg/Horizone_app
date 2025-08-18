import '../entities/place_suggestion.dart';

abstract class PlacesRepository {
  /// Retorna sugestões para o texto [input].
  /// Opcionalmente restringe por [regionCodes] (ex.: ['br']).
  Future<List<PlaceSuggestion>> fetchSuggestions({
    required String input,
    List<String> regionCodes,
    String? sessionToken,
  });
}

