// ignore_for_file: non_constant_identifier_names

part of 'profile_edit_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

enum PhotoUploadStatus { pure, failed, successful }

class ProfileEditState extends Equatable {
  const ProfileEditState({
    // this.email = const Email.pure(),
    // this.password = const Password.pure(),
    this.firstname = '',
    this.lastname = '',
    this.phone = '',

    // this.password_again = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.avatar = '',
    this.photoUploadStatus = PhotoUploadStatus.pure,
  });

  // final Email email;
  final String firstname;
  final String lastname;
  final String phone;
  // final Password password;
  // final ConfirmedPassword password_again;
  final FormzStatus status;
  final String? errorMessage;
  final String avatar;
  final PhotoUploadStatus photoUploadStatus;

  @override
  List<Object> get props => [
        firstname,
        lastname,
        phone,
        status,
        avatar,
        photoUploadStatus,
      ];

  ProfileEditState copyWith({
    // Email? email,
    String? firstname,
    String? lastname,
    String? phone,
    // Password? password,
    // ConfirmedPassword? password_again,
    FormzStatus? status,
    String? errorMessage,
    String? avatar,
    PhotoUploadStatus? photoUploadStatus,
  }) {
    return ProfileEditState(
      // email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      // password: password ?? this.password,
      // password_again: password_again ?? this.password_again,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      avatar: avatar ?? this.avatar,
      photoUploadStatus: photoUploadStatus ?? this.photoUploadStatus,
    );
  }
}
