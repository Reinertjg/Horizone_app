import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// A [ChangeNotifier] that manages the session token for
/// Google Places Autocomplete.
class PlacesAutocompleteNotifier extends ChangeNotifier {
  final _uuid = const Uuid();

  String _sessionToken = '';

  /// The current session token.
  String get sessionToken => _sessionToken;

  /// Ensures that a session token exists. If not, it creates a new one.
  void ensureSession() {
    if (_sessionToken.isEmpty) _sessionToken = _uuid.v4();
  }

  /// Resets the current session token.
  void resetSession() {
    _sessionToken = '';
    notifyListeners();
  }
}
