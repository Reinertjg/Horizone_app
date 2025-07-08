// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `EXPLORE NEW HORIZONS`
  String get newHorizons {
    return Intl.message(
      'EXPLORE NEW HORIZONS',
      name: 'newHorizons',
      desc: '',
      args: [],
    );
  }

  /// `Ready to explore beyond boundaries?`
  String get readyExplore {
    return Intl.message(
      'Ready to explore beyond boundaries?',
      name: 'readyExplore',
      desc: '',
      args: [],
    );
  }

  /// `Your Journey Starts Here`
  String get startJourney {
    return Intl.message(
      'Your Journey Starts Here',
      name: 'startJourney',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Biography`
  String get bio {
    return Intl.message('Biography', name: 'bio', desc: '', args: []);
  }

  /// `Soy desarrollador Flutter en Lince Tech, creando aplicaciones móviles rápidas y elegantes.`
  String get bioDescription {
    return Intl.message(
      'Soy desarrollador Flutter en Lince Tech, creando aplicaciones móviles rápidas y elegantes.',
      name: 'bioDescription',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Job Title`
  String get jobTitle {
    return Intl.message('Job Title', name: 'jobTitle', desc: '', args: []);
  }

  /// `Tell us who you are and we'll take you where you want to be`
  String get introMessage {
    return Intl.message(
      'Tell us who you are and we\'ll take you where you want to be',
      name: 'introMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Tell Us {highlight1}\nAnd We'll Take You Where \nYou Want to Be`
  String introText(Object highlight1) {
    return Intl.message(
      'Tell Us $highlight1\nAnd We\'ll Take You Where \nYou Want to Be',
      name: 'introText',
      desc: 'Introductory message with highlighted part',
      args: [highlight1],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
