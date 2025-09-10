import 'dart:convert';

class LanguageModel {
  String name;
  String languageCode;
  String countryCode;

  LanguageModel({
    required this.name,
    required this.languageCode,
    required this.countryCode,
  });

  factory LanguageModel.fromRawJson(String str) =>
      LanguageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    name: json["name"],
    languageCode: json["languageCode"],
    countryCode: json["countryCode"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "languageCode": languageCode,
    "countryCode": countryCode,
  };

  static List<LanguageModel> languages() {
    return <LanguageModel>[
      LanguageModel(name: 'English', languageCode: 'en', countryCode: 'US'),
      LanguageModel(name: 'Français', languageCode: 'fr', countryCode: 'FR'),
    ];
  }
}
