// import 'package:app_auth/app_auth.dart';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> with UiLogger {
  ProfileEditCubit(
    this._authenticationRepository,
  ) : super(const ProfileEditState()) {
    init();
  }

  final fnameC = TextEditingController();
  final lnameC = TextEditingController();
  final phoneC = TextEditingController();
  final countryC = TextEditingController();

  final AuthenticationRepository _authenticationRepository;

  void reload() {
    init();
  }

  Future<void> init() async {
    final user = _authenticationRepository.currentUser;

    fnameC.text = user.firstname.toString();
    lnameC.text = user.lastname.toString();
    phoneC.text = user.phone.toString();
    countryC.text = user.country!;

    emit(
      state.copyWith(
        firstname: user.firstname,
        lastname: user.lastname,
        phone: user.phone,
        // avatar: user.avatar,
      ),
    );

    emit(
      state.copyWith(),
    );
  }

  void firstnameChanged(String value) {
    final firstname = TextInput.dirty(value.trim());
    emit(
      state.copyWith(
        firstname: firstname.value,
        status: Formz.validate([
          firstname,
        ]),
      ),
    );
  }

  void lastnameChanged(String value) {
    final lastname = TextInput.dirty(value.trim());
    emit(
      state.copyWith(
        lastname: lastname.value,
        status: Formz.validate([
          lastname,
        ]),
      ),
    );
  }

  void phoneChanged(String value) {
    final phone = TextInput.dirty(value.trim());
    emit(
      state.copyWith(
        phone: phone.value,
        status: Formz.validate([
          phone,
        ]),
      ),
    );
  }

  // Future<User?> photoChanged(XFile avatar) async {
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     final fileName = avatar.path.split('/').last;

  //     final data = FormData.fromMap({
  //       'display_picture':
  //           await MultipartFile.fromFile(avatar.path, filename: fileName),
  //     });

  //     const url = 'user/update-profile';

  //     final dynamic response = await httpNetworkController.post(
  //       url,
  //       data,
  //       options: Options(contentType: 'multipart/form-data'),
  //       isFormData: true,
  //       asRawResponse: true,
  //     );

  //     logger.d('response=$response');

  //     if (response != null) {
  //       final res = response as Map<String, dynamic>;

  //       if (res['statusCode'] == 200) {
  //         final data = res['data'] as Map<String, dynamic>;
  //         await _authenticationRepository.updateProfilePhoto(
  //           avatar: data['avatar'].toString(),
  //         );

  //         emit(
  //           state.copyWith(
  //             avatar: data['avatar'].toString(),
  //             photoUploadStatus: PhotoUploadStatus.successful,
  //           ),
  //         );

  //         return _authenticationRepository.currentUser;
  //       }
  //     } else {
  //       emit(state.copyWith(photoUploadStatus: PhotoUploadStatus.failed));
  //     }
  //   } on PhotoUploadFailure catch (e) {
  //     logger.d(e.message);
  //     emit(
  //       state.copyWith(
  //         photoUploadStatus: PhotoUploadStatus.failed,
  //         errorMessage: e.message,
  //       ),
  //     );
  //   } catch (e) {
  //     logger.d(e);
  //     emit(
  //       state.copyWith(
  //         photoUploadStatus: PhotoUploadStatus.failed,
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }

  //   emit(state.copyWith(status: FormzStatus.pure));
  //   return null;
  // }

  Future<void> profileFormSubmitted() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      logger.i('calling register');
      final userData = _authenticationRepository.currentUser.copyWith(
        firstname: state.firstname,
        lastname: state.lastname,
        // phone: state.phone,
      );

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      reload();
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
