import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../data/models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  final String key = 'languageCode';
  late LanguageModel _selectedLanguage;
  final List<LanguageModel> _languages = LanguageModel.languages();
  bool _isInitialized = false;

  LanguageModel get currentLanguage => _selectedLanguage;
  List<LanguageModel> get languages => _languages;
  bool get isInitialized => _isInitialized;

  LanguageProvider() {
    _selectedLanguage = _languages.first;
  }

  Future<void> initializeLanguage() async {
    if (!_isInitialized) {
      await _loadSavedLanguage();
      _isInitialized = true;
    }
  }

  bool _isSupportedLanguage(String languageCode) {
    return _languages.any(
      (lang) => lang.languageCode.toLowerCase() == languageCode.toLowerCase(),
    );
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // First try to load saved preference
      String? savedLanguageCode = prefs.getString(key);

      String deviceLocale;
      try {
        deviceLocale =
            ui.PlatformDispatcher.instance.locale.languageCode.toLowerCase();
      } catch (e) {
        deviceLocale = 'en';
      }

      String languageCode;
      if (savedLanguageCode != null &&
          _isSupportedLanguage(savedLanguageCode)) {
        // Use saved preference if it exists and is supported
        languageCode = savedLanguageCode;
      } else if (_isSupportedLanguage(deviceLocale)) {
        // Use device locale if supported
        languageCode = deviceLocale;
      } else {
        // Fallback to English
        languageCode = 'en';
      }

      _selectedLanguage = _languages.firstWhere(
        (element) => element.languageCode.toLowerCase() == languageCode,
        orElse: () => _languages.first,
      );

      notifyListeners();
    } catch (e) {
      _selectedLanguage = _languages.first;
      notifyListeners();
    }
  }

  Locale get locale {
    return Locale(
      _selectedLanguage.languageCode,
      _selectedLanguage.countryCode,
    );
  }

  Future<void> setLanguage(BuildContext context, String languageCode) async {
    try {
      languageCode = languageCode.toLowerCase();

      final language = _languages.firstWhere(
        (element) => element.languageCode.toLowerCase() == languageCode,
        orElse: () => _languages.first,
      );

      _selectedLanguage = language;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, languageCode);

      // Update the app locale
      final newLocale = Locale(language.languageCode, language.countryCode);
      SpaceXApp.setLocale(context, newLocale);

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  void setLanguageWithoutLocaleChange(String languageCode) {
    try {
      languageCode = languageCode.toLowerCase();

      final language = _languages.firstWhere(
        (element) => element.languageCode.toLowerCase() == languageCode,
        orElse: () => _languages.first,
      );

      _selectedLanguage = language;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language without locale change: $e');
    }
  }
}

// Global reference to the app for locale changes
class SpaceXApp {
  static void setLocale(BuildContext context, Locale newLocale) {
    // This will be handled by the main app widget
  }
}
