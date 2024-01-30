import 'dart:convert';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> with UiLogger {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;
  final phoneTC = PhoneTextFieldController();
  final vcodeControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  void gotoStep(int step) {
    emit(state.copyWith(step: step));
  }

  void noCode() {
    emit(state.copyWith(verificationCodeStatus: VerificationCodeStatus.none));
  }

  void choosePlan(int plan) {}
  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
          state.firstname,
          state.lastname,
          state.phone,
        ]),
      ),
    );
  }

  void firstnameChanged(String value) {
    final firstname = TextInput.dirty(value);
    emit(
      state.copyWith(
        firstname: firstname,
        status: Formz.validate([
          state.email,
          state.lastname,
          state.phone,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void lastnameChanged(String value) {
    final lastname = TextInput.dirty(value);
    emit(
      state.copyWith(
        lastname: lastname,
        status: Formz.validate([
          state.email,
          state.firstname,
          state.phone,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void phoneChanged(PhoneNumber value) {
    final phone = Phone.dirty(value.completeNumber);

    emit(
      state.copyWith(
        country: value.countryISOCode,
        phone: phone,
        status: Formz.validate([
          state.email,
          state.password,
          state.firstname,
          state.lastname,
          state.confirmedPassword,
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
          state.firstname,
          state.lastname,
          state.email,
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
          state.firstname,
          state.lastname,
          state.email,
        ]),
      ),
    );
  }

  Future<void> signUp() async {
    // if (!state.status.isValidated) return;
    if (!state.phone.valid || !state.password.valid) return;
    notify.loading();

    try {
      final res = await http.post(
        Uri.parse('${_authenticationRepository.api}auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'password': state.password.value,
          'phone': state.phone.value,
          'country': state.country,
        }),
      );
      notify.closeLoading();

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        //................................................................
        //print(data);
        //print('Was the code sent or not? ${data['code_sent']}');

        await _authenticationRepository.formatUser(
          data['user'] as Map<String, dynamic>,
          data['jwt'] as String,
          redirect: false,
        );

        //major edit................................................................
        emit(
          state.copyWith(
            verificationCodeStatus: VerificationCodeStatus.confirmed,
            step: 3,
          ),
        );
        //major edit................................................................

        //emit(state.copyWith(step: 2));
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

  Future<void> confirmVerificationCode(String code) async {
    // if (!state.status.isValidated) return;
    if (code.isEmpty) return;
    notify.loading();
    try {
      final res = await http.post(
        Uri.parse('${_authenticationRepository.api}auth/verify-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${_authenticationRepository.currentUser.jwt!}'
        },
        body: jsonEncode({'token': code}),
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

  Future<void> resendVerificationCode() async {
    notify.loading();
    try {
      final res = await http.post(
        Uri.parse('${_authenticationRepository.api}auth/send-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${_authenticationRepository.currentUser.jwt!}'
        },
      );
      notify.closeLoading();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        if (data['code_sent'] as bool == true) {
          emit(
            state.copyWith(
              verificationCodeStatus: VerificationCodeStatus.resent,
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

  Future<void> submitProfileInfo() async {
    logger.d('submitProfileInfo');
    if (!state.email.valid || !state.firstname.valid || !state.lastname.valid) {
      return;
    }
    notify.loading();
    try {
      final res = await http.post(
        Uri.parse('${_authenticationRepository.api}auth/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${_authenticationRepository.currentUser.jwt!}'
        },
        body: jsonEncode({
          'email': state.email.value,
          'firstname': state.firstname.value,
          'lastname': state.lastname.value,
        }),
      );
      notify.closeLoading();

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        await _authenticationRepository.formatUser(
          data['user'] as Map<String, dynamic>,
          data['jwt'] as String,
          // redirect: false,
        );
        // emit(state.copyWith(step: 4));
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

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      errorMessage: null,
    ));
    try {
      final r = await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        firstname: state.firstname.value,
        lastname: state.lastname.value,
        phone: state.phone.value,
        country: state.country,
      );

      emit(
        state.copyWith(
          // status: FormzStatus.submissionSuccess,
          errorMessage: null,
        ),
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'An error occurred. Please try again.'));
    }
  }

  //Custom function...............................................................................
  void goToStepThree (){
    emit(
      state.copyWith(
        verificationCodeStatus: VerificationCodeStatus.confirmed,
        step: 3,
      ),
    );
  }
}
