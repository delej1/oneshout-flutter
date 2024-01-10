part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.phone = const Phone.pure(),
    this.step = 1,
    this.verificationCodeStatus = VerificationCodeStatus.initial,
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.passwordResetCompleted = false,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;
  final Phone phone;
  final int step;
  final bool passwordResetCompleted;
  final VerificationCodeStatus verificationCodeStatus;
  @override
  List<Object> get props => [
        email,
        status,
        phone,
        step,
        verificationCodeStatus,
        password,
        confirmedPassword,
        passwordResetCompleted
      ];

  ChangePasswordState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    Phone? phone,
    FormzStatus? status,
    String? errorMessage,
    int? step,
    VerificationCodeStatus? verificationCodeStatus,
    bool? passwordResetCompleted,
  }) {
    return ChangePasswordState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        phone: phone ?? this.phone,
        step: step ?? this.step,
        verificationCodeStatus:
            verificationCodeStatus ?? this.verificationCodeStatus,
        passwordResetCompleted:
            passwordResetCompleted ?? this.passwordResetCompleted);
  }
}
