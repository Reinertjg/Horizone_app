import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider class responsible for
/// managing and persisting the app's locale settings.
class LocaleProvider extends ChangeNotifier {
  /// The current locale of the application.
  Locale _locale;

  /// Gets the current locale.
  Locale? get locale => _locale;

  /// Creates a [LocaleProvider] with the given initial [_locale].
  /// Automatically loads any persisted locale from storage.
  LocaleProvider(this._locale) {
    _loadLocale();
  }

  /// Updates the current locale and persists the change.
  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    _saveLocale(newLocale);
    notifyListeners();
  }

  /// Loads the locale from [SharedPreferences].
  Future<void> _loadLocale() async {
    final perfs = await SharedPreferences.getInstance();
    final languageCode = perfs.getString('languageCode') ?? 'pt';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  /// Saves the selected [locale] to [SharedPreferences].
  Future<void> _saveLocale(Locale locale) async {
    final perfs = await SharedPreferences.getInstance();
    await perfs.setString('languageCode', locale.languageCode);
  }
}
