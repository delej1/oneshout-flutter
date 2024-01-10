class Language {
  Language({
    this.languageCode = 'en',
    this.countryCode = 'US',
    this.name = 'English',
    this.nativeName = 'English',
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageCode: json['languageCode'] as String,
        countryCode: json['countryCode'] as String,
        name: json['name'] as String,
        nativeName: json['nativeName'] as String,
      );

  final String languageCode;
  final String countryCode;
  final String name;
  final String nativeName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'languageCode': languageCode,
        'countryCode': countryCode,
        'name': name,
        'nativeName': nativeName,
      };
}
