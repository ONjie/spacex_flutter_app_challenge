import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpaceXLocalization {
  final Locale locale;

  SpaceXLocalization(this.locale);

  static SpaceXLocalization? of(BuildContext context) {
    return Localizations.of<SpaceXLocalization>(context, SpaceXLocalization);
  }

  Map<String, String>? _localizedValues;

  Future<void> load() async {
    try {
      String jsonStringValues = await rootBundle.loadString(
        'lib/lang/${locale.languageCode}.json',
      );
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      _localizedValues = mappedJson.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      debugPrint('Error loading localization for ${locale.languageCode}: $e');
      // Fallback to empty map to prevent crashes
      _localizedValues = <String, String>{};
    }
  }

  String? translate(String key) {
    return _localizedValues?[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<SpaceXLocalization> delegate =
      _SpaceXLocalizationsDelegate();
}

class _SpaceXLocalizationsDelegate
    extends LocalizationsDelegate<SpaceXLocalization> {
  const _SpaceXLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support all English and French variants
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<SpaceXLocalization> load(Locale locale) async {
    SpaceXLocalization localization = SpaceXLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<SpaceXLocalization> old) => false;
}
