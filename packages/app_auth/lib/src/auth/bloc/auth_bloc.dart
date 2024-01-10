import 'dart:async';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with ChangeNotifier, UiLogger {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              //&&      authenticationRepository.currentUser.jwt != null
              ? AuthState.authenticated(authenticationRepository.currentUser)
              : const AuthState.unauthenticated(),
        ) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    // on<JWTRequested>(_onJWTRequested);

    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        add(AuthUserChanged(user));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  // FutureOr<void> _onJWTRequested(
  //   JWTRequested jwt,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthState.jwt(jwt.jwt));
  //   // await storeJwtToken(jwt.jwt);
  // }

  Future<void> _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    logger.d('_onUserChanged');
    var user = event.user;

    // If the user is empty, then user needs to log into firebase first.
    if (user.isEmpty) {
      return emit(const AuthState.unauthenticated());
    }

    // If jwt is not available, so server login is required.
    if (user.jwt == null) {
      user = await _authenticationRepository.logInToServer();
    }

    //if jwt is now available, then user is authenticated.
    if (user.isNotEmpty && user.jwt != null) {
      emit(AuthState.authenticated(user));
      await _authenticationRepository.getFCMToken();
      // unawaited(registerOneSignalExternalId(user));
    }

    unawaited(FirebaseAnalyticsService().setUserProperties(id: user.id));

    notifyListeners();
  }

  // Future<void> registerOneSignalExternalId(User user) async {
  //   // Setting External User Id with Callback Available in SDK Version 3.9.3+
  //   await OneSignal.shared.setExternalUserId(user.phone!).then((results) {
  //     logger.d(results.toString());
  //   }).catchError((dynamic error) {
  //     logger.d(error.toString());
  //   });
  // }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authenticationRepository.logOut());
    final box = GetStorage();
    unawaited(box.remove('jwtToken'));
    logger.d('Cleared JWT from storage.');
    emit(const AuthState.unauthenticated());
    notifyListeners();
  }

  void setToken({
    required String jwt,
    required HttpNetworkController http,
    required String api,
  }) {
    http.setup(baseUrl: api, token: jwt);
  }

  Future<void> storeJwtToken(String token) async {
    try {
      final box = GetStorage();
      await box.write('jwtToken', token);

      add(JWTRequested(token));
      logger.d('Fetched and stored JWT.');
    } catch (e) {
      throw Exception(e);
    }
  }

  String retrieveJwtToken() {
    try {
      final box = GetStorage();
      // ignore: omit_local_variable_types
      final String? token = box.read('jwtToken');
      return token ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
