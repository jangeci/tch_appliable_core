import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';

class TranslatorOptions {
  final List<String> languages;
  final List<Locale> supportedLocales;

  /// TranslatorOptions initialization
  TranslatorOptions({
    required this.languages,
    required this.supportedLocales,
  })   : assert(languages.isNotEmpty),
        assert(languages.length == supportedLocales.length);
}

/// Shorthand to translate string to current Language
String tt(String text) => Translator.instance?.translate(text) ?? text;

class Translator {
  static Translator? get instance => _instance;

  static Translator? _instance;

  final HtmlUnescape _htmlUnescape = HtmlUnescape();
  final TranslatorOptions _options;
  String _currentLanguage = 'en';
  Map<String, String> _currentTranslations = Map();

  /// Translator initialization
  Translator({
    required TranslatorOptions options,
  }) : _options = options {
    _instance = this;
  }

  /// Initialize correct Language and translations for it
  Future init(BuildContext context) async {
    final Locale? locale = Localizations.localeOf(context);

    _currentLanguage = langSupported(locale?.languageCode ?? '');

    await initTranslations(context);
  }

  /// Check if language code is supported in options, fallback to first supported language
  String langSupported(String languageCode) {
    return _options.languages.contains(languageCode) ? languageCode : _options.languages.first;
  }

  /// Initialize translations for language from assets JSON file
  Future<void> initTranslations(BuildContext context, [String? language]) async {
    final String theLanguage = language ?? _currentLanguage;

    if (!_options.languages.contains(theLanguage)) {
      throw Exception('Translator cannot initialize unsupported language');
    }

    String json = await rootBundle.loadString('assets/translations/$theLanguage.json');

    Map<String, String> translations = Map<String, String>.from(jsonDecode(json));

    _currentTranslations = translations;
  }

  /// Translate string to current Language
  String translate(String text) => _currentTranslations[text] != null ? _htmlUnescape.convert(_currentTranslations[text]!) : text;

  /// Change current to new Language if supported in options
  void changeLanguage(String language) {
    if (_options.languages.contains(language)) {
      _currentLanguage = language;
    } else {
      _currentLanguage = _options.languages.first;
    }
  }

  /// Default DateFormat localized to current Language
  DateFormat get localizedDateFormat => DateFormat.yMMMMEEEEd(_currentLanguage).add_jm();
}
