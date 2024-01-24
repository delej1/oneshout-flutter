// import 'package:app_auth/app_auth.dart';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with UiLogger {
  ProfileCubit(
    this._authenticationRepository,
  ) : super(const ProfileState()) {
    init();
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> init() async {
    final user = _authenticationRepository.currentUser;

    emit(
      state.copyWith(
        firstname: user.firstname,
        lastname: user.lastname,
        phone: user.phone,
        // avatar: user.avatar,
      ),
    );
  }
}
