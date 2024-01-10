part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

enum VerificationCodeStatus {
  initial,
  confirmed,
  resending,
  resent,
  failed,
  none
}

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.phone = const Phone.pure(),
    this.firstname = const TextInput.pure(),
    this.lastname = const TextInput.pure(),
    this.country = '',
    this.step = 1,
    this.verificationCodeStatus = VerificationCodeStatus.initial,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;
  final Phone phone;
  final TextInput firstname;
  final TextInput lastname;
  final String country;
  final int step;
  final VerificationCodeStatus verificationCodeStatus;

  @override
  List<Object> get props => [
        email,
        password,
        confirmedPassword,
        status,
        phone,
        firstname,
        lastname,
        country,
        step,
        verificationCodeStatus,
      ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
    String? errorMessage,
    Phone? phone,
    TextInput? firstname,
    TextInput? lastname,
    String? country,
    int? step,
    VerificationCodeStatus? verificationCodeStatus,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      phone: phone ?? this.phone,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      country: country ?? this.country,
      step: step ?? this.step,
      verificationCodeStatus:
          verificationCodeStatus ?? this.verificationCodeStatus,
    );
  }
}
