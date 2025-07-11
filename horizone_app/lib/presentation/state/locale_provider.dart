import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  Locale? get locale => _locale;

  LocaleProvider(this._locale) {
    _loadLocale();
  }

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    _saveLocale(newLocale);
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final perfs = await SharedPreferences.getInstance();
    final languageCode = perfs.getString('languageCode') ?? 'pt';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> _saveLocale(Locale locale) async {
    final perfs = await SharedPreferences.getInstance();
    await perfs.setString('languageCode', locale.languageCode);
  }
}
