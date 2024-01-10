import 'dart:convert';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> with UiLogger {
  ForgotPasswordCubit(this._authenticationRepository)
      : super(const ForgotPasswordState());

  final AuthenticationRepository _authenticationRepository;
  final phoneTC = PhoneTextFieldController();

  void gotoStep(int step) {
    emit(state.copyWith(step: step));
  }

  void noCode() {
    emit(state.copyWith(verificationCodeStatus: VerificationCodeStatus.none));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email]),
      ),
    );
  }

  void phoneChanged(PhoneNumber value) {
    final phone = Phone.dirty(value.completeNumber);

    emit(
      state.copyWith(
        phone: phone,
        status: Formz.validate([
          state.phone,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.phone,
          password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.phone,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> confirmVerificationCode(String code) async {
    // if (!state.status.isValidated) return;
    if (code.isEmpty) return;
    notify.loading();
    try {
      final res = await http.post(
        Uri.parse(
            '${_authenticationRepository.api}auth/verify-password-reset-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'token': code, 'phone': state.phone.value}),
      );
      notify.closeLoading();
      if (res.statusCode == 200) {
        emit(
          state.copyWith(
            verificationCodeStatus: VerificationCodeStatus.confirmed,
            step: 3,
          ),
        );
      } else {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final err = data['error'] as Map<String, dynamic>;
        notify.snack(err['message'].toString(), type: NT.error);
        emit(
          state.copyWith(
            verificationCodeStatus: VerificationCodeStatus.failed,
          ),
        );
      }
    } catch (_, s) {
      logger.d(s);
      notify
        ..closeLoading()
        ..snack('An error occurred. Please try again.', type: NT.error);
      emit(
        state.copyWith(
          verificationCodeStatus: VerificationCodeStatus.failed,
        ),
      );
    }
  }

  Future<void> sendVerificationCode() async {
    notify.loading();

    try {
      final res = await http.post(
        Uri.parse(
          '${_authenticationRepository.api}auth/send-forgot-password-otp',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'phone': state.phone.value}),
      );

      notify.closeLoading();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        if (data['code_sent'] as bool == true) {
          emit(
            state.copyWith(
              verificationCodeStatus: VerificationCodeStatus.resent,
              step: 2,
            ),
          );
        } else {
          notify.snack(
            'There was a problem sending your code. Please try again shortly.',
            title: 'Oops!',
            type: NT.error,
            important: true,
          );
          emit(
            state.copyWith(
              verificationCodeStatus: VerificationCodeStatus.failed,
            ),
          );
        }
      } else {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final err = data['error'] as Map<String, dynamic>;
        notify.snack(err['message'].toString(), type: NT.error);
      }
    } catch (_, s) {
      logger.d(s);
      notify
        ..closeLoading()
        ..snack('An error occurred. Please try again.', type: NT.error);
    }
  }

  Future<void> sendPassword() async {
    if (!state.phone.valid || !state.password.valid) return;

    notify.loading();

    try {
      final res = await http.post(
        Uri.parse(
          '${_authenticationRepository.api}auth/change-password',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {'phone': state.phone.value, 'password': state.password.value},
        ),
      );

      notify.closeLoading();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        if (data['done'] as bool == true) {
          emit(
            state.copyWith(
              passwordResetCompleted: true,
            ),
          );
        } else {
          notify.snack(
            'There was a problem resetting your password. Please try again shortly.',
            title: 'Oops!',
            type: NT.error,
            important: true,
          );
          emit(
            state.copyWith(
              verificationCodeStatus: VerificationCodeStatus.failed,
            ),
          );
        }
      } else {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final err = data['error'] as Map<String, dynamic>;
        notify.snack(err['message'].toString(), type: NT.error);
      }
    } catch (_, s) {
      logger.d(s);
      notify
        ..closeLoading()
        ..snack('An error occurred. Please try again.', type: NT.error);
    }
  }

  Future<void> sendPasswordResetCode() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _authenticationRepository.sendPasswordResetEmail(
          email: state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on SendPasswordResetEmailFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzStatus.submissionFailure));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
