import 'package:flutter/material.dart';


// Clase del tipo SINGLETON. Sólo permite una única instancia, aunque la instancies varias veces, sólo hay una instancia
class LanguageManager {
  static final LanguageManager _instance = LanguageManager._internal();

  LanguageManager._internal();

  static LanguageManager get instance => _instance;

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String language) {
    _currentLanguage = language;
  }

  String translate(String key) {
    return Translations.texts[_currentLanguage]?[key] ?? key;
  }
}


class Translations {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',
      'goodbye': 'Goodbye',
    },
    'es': {
      'hello': 'Hola',
      'welcome': 'Bienvenido',
      'goodbye': 'Adiós',
    },
    'fr': {
      'hello': 'Bonjour',
      'welcome': 'Bienvenue',
      'goodbye': 'Au revoir',
    },
  };
}

