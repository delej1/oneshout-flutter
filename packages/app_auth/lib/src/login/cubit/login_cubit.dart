import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with NetworkLogger {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  final phoneTC = PhoneTextFieldController();

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(
      state.copyWith(
        phone: phone,
        status: Formz.validate([phone, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.phone, password]),
      ),
    );
  }

  Future<bool> logInWithCredentials() async {
    if (!state.status.isValidated) return false;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        phone: state.phone.value,
        password: state.password.value,
      );

      // await logInToServer(idToken: idToken);
      // emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
    return false;
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final uc = await _authenticationRepository.logInWithGoogle();
      logger.d('google = ${uc!.user!.uid}');
      // await logInToServer(idToken: idToken);

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      // final uc = await _authenticationRepository.signInWithFacebook();

      // print('facebook = ' + uc!.user!.toString());
      // await logInToServer(idToken: idToken);

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithFacebookFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  // Future<void> logInToServer({required String? idToken}) async {
  //   // emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     final jwt =
  //         await _authenticationRepository.logInToServer(idToken: idToken!);
  //     // AuthBloc(authenticationRepository: _authenticationRepository)
  //     //     .add(JWTRequested(jwt));
  //     // await AuthBloc(authenticationRepository: _authenticationRepository)
  //     //     .storeJwtToken(jwt);
  //     // await _authenticationRepository.storeJwtToken(jwt);
  //     // emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on ServerLoginFailure catch (e) {
  //     throw Exception(e.message);
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}
