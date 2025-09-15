import '../entities/place_suggestion.dart';

/// A repository for fetching place-related information.
class PlacesRepository {
  /// Fetches a list of place suggestions based on the user's input.
  Future<List<PlaceSuggestion>> fetchSuggestions({
    required String input,
    List<String>? regionCodes,
    String? sessionToken,
  }) => throw UnimplementedError();
}
