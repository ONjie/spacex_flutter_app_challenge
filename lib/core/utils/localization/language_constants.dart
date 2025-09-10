import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'spacex_localization.dart';

// Language codes
const String LANGUAGE_CODE = 'languageCode';
const String ENGLISH = 'en';
const String FRANCAIS = 'fr';

// Country codes
const String US = 'US';
const String FR = 'FR';

// This method will be called when user manually selects a language
Future<Locale> setLocale(BuildContext context, String languageCode) async {
  try {
    // Update the app locale
    Locale locale = _locale(languageCode);

    // Save to preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, languageCode);

    return locale;
  } catch (e) {
    debugPrint('Error setting locale: $e');
    return const Locale(ENGLISH, US);
  }
}

Future<Locale> getLocale() async {
  try {
    // Get system locale first
    final deviceLocale =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode
            .toLowerCase();

    // Check if device locale is supported
    if (deviceLocale == ENGLISH.toLowerCase() ||
        deviceLocale == FRANCAIS.toLowerCase()) {
      return _locale(deviceLocale);
    }

    // Fallback to saved preference only if device locale is not supported
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
    return _locale(languageCode);
  } catch (e) {
    debugPrint('Error getting locale: $e');
    return const Locale(ENGLISH, US);
  }
}

Locale _locale(String languageCode) {
  switch (languageCode.toLowerCase()) {
    case FRANCAIS:
      return const Locale(FRANCAIS, FR);
    case ENGLISH:
    default:
      return const Locale(ENGLISH, US);
  }
}

String? getTranslated(BuildContext context, String key) {
  return SpaceXLocalization.of(context)?.translate(key);
}
