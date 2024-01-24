///PHone number model
// ignore_for_file: lines_longer_than_80_chars

class PhoneNumber {
  ///
  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    required this.country,
  });

  ///Country ISO code e.g NG.
  String countryISOCode;

  ///Country code e.g +234.
  String countryCode;

  ///Phone number.
  String number;

  ///Country name e.g Nigeria.
  String country;

  /// Return formated phone number e.g +234 800 123 4567
  String get completeNumber {
    return countryCode + number;
  }

  ///
  @override
  String toString() => 'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
