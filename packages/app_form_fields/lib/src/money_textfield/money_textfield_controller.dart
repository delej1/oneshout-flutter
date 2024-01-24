import 'package:flutter/widgets.dart';
import 'package:money2/money2.dart';

/// This is an extended [TextEditingController] for the MoneyTextField.
class MoneyTextFieldController extends TextEditingController {
  ///
  MoneyTextFieldController({
    this.currencyCode = 'NGN',
    this.moneyFormat = 'S###,###.#0',
    this.fieldHasFocus = false,
    this.initialValue,
    this.counter = 100,
    this.decimalSeparator = '.',
    this.thousandsSeparator = ',',
    this.invalidFormatError = 'Invalid input format',
    this.invalidLengthError = 'Length must be less than or equal to 9',
    this.maxDigitsBeforeDecimal = 9,
  }) {
    //validate the parameters
    _validateParameters();
    // set the initial value
    if (initialValue != null) {
      text = initialValue.toString();
      _toMoney();
    }
  }

  /// Decimal separator. Defaults to dot "."
  final String decimalSeparator;

  /// Thousands separator. Defaults to comma ",".
  final String thousandsSeparator;

  /// Error message for an invalid format.
  final String invalidFormatError;

  /// Error message for an invalid length.
  final String invalidLengthError;

  /// Maximum digits before decimal separator.
  /// Defaults to 9
  final int maxDigitsBeforeDecimal;

  /// Currency code. Defaults to 'NGN'
  final String currencyCode;

  /// Money format. Defaults to 'S###,###.#0'
  final String moneyFormat;

  /// Flag to give focus to the MoneyTextField
  bool fieldHasFocus;

  /// Initial value of the MoneyTextField
  num? initialValue;

  /// Sets the value used to increment or decrement
  /// the value of the MoneyTextField. Default is 100.
  final num counter;

  // bool _readOnly = false;

  /// Get the readonly state of the MoneyTextField.
  bool readOnly = false;
  // set readOnly(bool value) => _readOnly = value;

  /// Returns state if MoneyTextField is valid or not.
  bool get isValid => _validate();
  bool _validate() {
    if (amountAsNum == 0) {
      errorText = 'Please enter an amount';
      return false;
    }
    errorText = '';
    return true;
  }

  /// Error text
  String errorText = '';

  ///Set the default amount value
  void setValue(num value) {
    text = value == 0 ? '' : value.toString();
  }

  ///Notify [MoneyTextFieldController] of focus state of its MoneyTextField.
  // void setFocus(bool value) {
  //   fieldHasFocus = value;
  // }

  ///Set the initial value of MoneyTextField.
  // void _setAmountValue(String value) {
  //   text = value;
  // }

  ///Return the amount value of the [MoneyTextFieldController] as a [num].
  num get amountAsNum => _amountAsNum();
  num _amountAsNum() {
    final value = _convertToNumber();
    return value.isEmpty ? 0 : num.parse(value);
  }

  ///Return the amount value of the [MoneyTextFieldController] as a [String].
  String get amountAsString => _amountAsString();
  String _amountAsString() {
    return _convertToNumber();
  }

  ///Increment the amount value with the controller's
  ///[counter] argument a passed [value].
  void increment([num? value]) {
    if (readOnly) return;

    final amount = _amountAsNum();
    final _value = value ?? counter;
    text = (amount + _value).toString();
    fieldHasFocus ? toNum() : _toMoney();
    _validate();
  }

  ///Decrement the amount value with the
  ///controller's [counter] argument a passed [value].
  void decrement([num? value]) {
    if (readOnly) return;

    final amount = _amountAsNum();
    final _value = value ?? counter;
    var total = amount - _value;

    total = (total < 0) ? 0 : total;
    text = total.toString();
    fieldHasFocus ? toNum() : _toMoney();

    _validate();
  }

  ///Display the amount value as [num].
  void toNum() {
    text = _convertToNumber();
  }

  ///Display the amount value as formatted [Money].
  void toMoney() {
    _toMoney();
  }

  ///Display the amount value as formatted [Money].
  void _toMoney() {
    if (text.isEmpty) return;

    final amount = Money.fromNum(num.parse(text), code: currencyCode);
    text = amount.format(moneyFormat);
  }

  ///Convert the amount value from [Money] to [num].
  String _convertToNumber() {
    text = (text.isEmpty) ? '' : text;
    return text.replaceAll(RegExp('[^0-9.]'), '');
  }

  /// Return a [double] of the value of the [MoneyTextFieldController].
  double doubleValue() {
    if (isInputValid()) {
      final sanitizedInput = getSanitizedInput();
      return double.parse(sanitizedInput);
    }

    return 0;
  }

  /// Sanitizes the field input of the
  /// thousands separator to ensure proper parsing.
  String getSanitizedInput() {
    final tempText = text.replaceAll(thousandsSeparator, '');
    return tempText;
  }

  /// Checks to make sure the parameters are valid in order to avoid any issues.
  void _validateParameters() {
    if (decimalSeparator == thousandsSeparator) {
      throw ArgumentError("Separators can't have the same value.");
    }
  }

  /// Checks if the input format is valid.
  ///
  /// Returns true if the input matches the regex.
  bool isFormatValid() {
    final regExp = RegExp(
      r'(?=.*?\d)^(([1-9]\d{0,2}(\$thousandsSeparator\\d{3})*)|\\d+)?(\\$decimalSeparator\\d{2})?\$',
    );

    return regExp.hasMatch(text);
  }

  /// Checks if the input length is valid.
  ///
  /// Returns true if the length is <= [this.maxDigitsBeforeDecimal].
  bool isLengthValid() {
    // ignore: lines_longer_than_80_chars
    return getSanitizedInput().split(decimalSeparator)[0].length <=
        maxDigitsBeforeDecimal;
  }

  /// Checks if the format and length of input is valid.
  ///
  /// Returns true if valid.
  bool isInputValid() {
    return isFormatValid() && isLengthValid();
  }

  /// Validates the field and returns the proper error message,
  /// or null if there is no error.
  String? moneyFieldValidator() {
    if (!isFormatValid()) {
      return invalidFormatError;
    }

    if (!isLengthValid()) {
      return invalidLengthError;
    }

    return null;
  }
}
