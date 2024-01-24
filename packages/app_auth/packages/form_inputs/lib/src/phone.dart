import 'package:formz/formz.dart';

/// Validation errors for the [Phone] [FormzInput].
enum PhoneValidationError {
  /// Generic invalid error.
  empty
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Phone extends FormzInput<String, PhoneValidationError> {
  /// {@macro email}
  const Phone.pure() : super.pure('');

  /// {@macro email}
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String? value) {
    return value!.isNotEmpty == true ? null : PhoneValidationError.empty;
  }
}
