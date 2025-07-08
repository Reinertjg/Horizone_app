import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider(this._locale);

  Locale? get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }
}
