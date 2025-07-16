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

  /// `I'm a Flutter developer at Lince Tech, building fast and elegant mobile apps.`
  String get bioDescription {
    return Intl.message(
      'I\'m a Flutter developer at Lince Tech, building fast and elegant mobile apps.',
      name: 'bioDescription',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
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

  /// `Tell us `
  String get tellUs {
    return Intl.message('Tell us ', name: 'tellUs', desc: '', args: []);
  }

  /// `Who you are`
  String get whoYouAre {
    return Intl.message('Who you are', name: 'whoYouAre', desc: '', args: []);
  }

  /// `\nAnd we'll take you where \nyou want to be`
  String get andWellTake {
    return Intl.message(
      '\nAnd we\'ll take you where \nyou want to be',
      name: 'andWellTake',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get welcome {
    return Intl.message('Hi', name: 'welcome', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Select Theme`
  String get selectTheme {
    return Intl.message(
      'Select Theme',
      name: 'selectTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message('Light Theme', name: 'lightTheme', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `System Theme`
  String get systemTheme {
    return Intl.message(
      'System Theme',
      name: 'systemTheme',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Name is required.`
  String get nameRequired {
    return Intl.message(
      'Name is required.',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters long.`
  String get nameTooShort {
    return Intl.message(
      'Name must be at least 3 characters long.',
      name: 'nameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Biography is required.`
  String get bioRequired {
    return Intl.message(
      'Biography is required.',
      name: 'bioRequired',
      desc: '',
      args: [],
    );
  }

  /// `Biography must be at least 10 characters long.`
  String get bioTooShort {
    return Intl.message(
      'Biography must be at least 10 characters long.',
      name: 'bioTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth is required.`
  String get dateOfBirthRequired {
    return Intl.message(
      'Date of birth is required.',
      name: 'dateOfBirthRequired',
      desc: '',
      args: [],
    );
  }

  /// `Gender is required.`
  String get genderRequired {
    return Intl.message(
      'Gender is required.',
      name: 'genderRequired',
      desc: '',
      args: [],
    );
  }

  /// `Job title is required.`
  String get jobTitleRequired {
    return Intl.message(
      'Job title is required.',
      name: 'jobTitleRequired',
      desc: '',
      args: [],
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
