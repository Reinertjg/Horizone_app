import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class PlacesAutocompleteNotifier extends ChangeNotifier {
  final _uuid = const Uuid();

  String _sessionToken = '';
  String get sessionToken => _sessionToken;

  void ensureSession() {
    if (_sessionToken.isEmpty) _sessionToken = _uuid.v4();
  }

  void resetSession() {
    _sessionToken = '';
    notifyListeners();
  }
}
