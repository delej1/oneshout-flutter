import 'package:flutter/widgets.dart';

///Controller for PhoneTextField widget.
class PhoneTextFieldController extends TextEditingController {
  ///
  PhoneTextFieldController({
    this.country,
    this.countryCode,
    this.dialCode,
    this.phoneNumber,
    this.initialCountryCode,
  });

  ///Country name.
  String? country;

  ///Country code.
  String? countryCode;

  ///Country dialling code.
  String? dialCode;

  ///Phone number.
  String? phoneNumber;

  ///Initial country value.
  String? initialCountryCode;
}

///Country field controller.
class CountryTextFieldController extends TextEditingController {
  ///
  CountryTextFieldController({
    this.country,
    this.countryCode,
    this.dialCode,
  });

  ///Country name.
  String? country;

  ///Country code.
  String? countryCode;

  ///Country dialling code.
  String? dialCode;
}
