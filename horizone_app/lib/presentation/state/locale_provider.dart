import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  /// The current locale.
  Locale _locale;

  Locale? get locale => _locale;

  LocaleProvider(this._locale) {
    _loadLocale();
  }

  /// Sets the current locale.
  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    _saveLocale(newLocale);
    notifyListeners();
  }

  /// Loads the locale from shared preferences.
  Future<void> _loadLocale() async {
    final perfs = await SharedPreferences.getInstance();
    final languageCode = perfs.getString('languageCode') ?? 'pt';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  /// Saves the locale to shared preferences.
  Future<void> _saveLocale(Locale locale) async {
    final perfs = await SharedPreferences.getInstance();
    await perfs.setString('languageCode', locale.languageCode);
  }
}
