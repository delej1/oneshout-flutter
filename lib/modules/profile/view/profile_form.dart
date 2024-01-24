// ignore_for_file: lines_longer_than_80_chars

// import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/profile/cubit/profile_edit_cubit.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileEditCubit, ProfileEditState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ??
                    'Your profile update was not successful. Please try again.'
                        .tr()),
              ),
            );
        }
        if (state.photoUploadStatus == PhotoUploadStatus.failed) {
          notify.snack(
            state.errorMessage ?? 'Photo upload failed. Please try again.',
            type: NT.error,
          );
        }
        if (state.photoUploadStatus == PhotoUploadStatus.successful) {
          notify.snack(
            'Your Photo was successfully uploaded.',
            type: NT.success,
          );
        }
      },
      builder: (context, state) {
        return (state.status == FormzStatus.submissionSuccess)
            ? const _ProfileSuccessfulWidget()
            : const _ProfileFormWidget();
      },
    );
  }
}

class _ProfileFormWidget extends StatelessWidget {
  const _ProfileFormWidget();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.push('/?page=3');
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  VSpace.xl,
                  BlocBuilder<ProfileEditCubit, ProfileEditState>(
                    builder: (context, state) {
                      return Avatar(photo: state.avatar);
                    },
                  ),
                  // TextBtn(
                  //   'Change Photo',
                  //   onPressed: () async {
                  //     final bloc = context.read<AuthBloc>();
                  //     final profileCubit = context.read<ProfileEditCubit>();
                  //     final picture = await availableCameras().then(
                  //       (value) => Navigator.push<XFile?>(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => CameraPage(cameras: value),
                  //         ),
                  //       ),
                  //     );

                  //     if (picture != null) {
                  //       final user = await profileCubit.photoChanged(picture);
                  //       if (user != null) {
                  //         bloc.add(AuthUserChanged(user));
                  //       }
                  //     }
                  //   },
                  // ),
                  VSpace.xxl,
                  _FirstNameInput(),
                  VSpace.lg,
                  _LastNameInput(),
                  VSpace.lg,
                  _PhoneInput(),

                  VSpace.xl,
                  // const Spacer(),
                ],
              ),
            ),
            VSpace.xl,
            _ProfileButton(),
          ],
        ),
      ),
    );
  }
}

class _ProfileSuccessfulWidget extends StatelessWidget {
  const _ProfileSuccessfulWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your profile update was successful!'),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('okForm_back_raisedButton'),
            onPressed: () => context.push('/?page=3'),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctx = context.read<ProfileEditCubit>();
    return BlocBuilder<ProfileEditCubit, ProfileEditState>(
      buildWhen: (previous, current) => previous.firstname != current.firstname,
      builder: (context, state) {
        return TextField(
          controller: ctx.fnameC,
          key: const Key('ProfileForm_fnameInput_textField'),
          onChanged: (firstname) =>
              context.read<ProfileEditCubit>().firstnameChanged(firstname),
          decoration: InputDecoration(
            labelText: 'auth.firstname'.tr(),
            errorText:
                state.firstname.isEmpty ? 'auth.invalid_firstname'.tr() : null,
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctx = context.read<ProfileEditCubit>();

    return BlocBuilder<ProfileEditCubit, ProfileEditState>(
      buildWhen: (previous, current) => previous.lastname != current.lastname,
      builder: (context, state) {
        return TextField(
          controller: ctx.lnameC,
          key: const Key('ProfileForm_lnameInput_textField'),
          onChanged: (lastname) =>
              context.read<ProfileEditCubit>().lastnameChanged(lastname),
          decoration: InputDecoration(
            labelText: 'auth.lastname'.tr(),
            errorText:
                state.lastname.isEmpty ? 'auth.invalid_lastname'.tr() : null,
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctx = context.read<ProfileEditCubit>();

    return BlocBuilder<ProfileEditCubit, ProfileEditState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextField(
          controller: ctx.phoneC,
          key: const Key('ProfileForm_phoneInput_textField'),
          onChanged: (phone) =>
              context.read<ProfileEditCubit>().phoneChanged(phone),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'auth.phone'.tr(),
            errorText: state.phone.isEmpty ? 'auth.invalid_phone'.tr() : null,
          ),
        );
      },
    );
  }
}

// class _EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileEditCubit, ProfileEditState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('ProfileForm_emailInput_textField'),
//           onChanged: (email) =>
//               context.read<ProfileEditCubit>().emailChanged(email),
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             labelText: 'auth.email'.tr(),
//             helperText: '',
//             errorText: state.email.invalid ? 'auth.invalid_email'.tr() : null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileEditCubit, ProfileEditState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('ProfileForm_passwordInput_textField'),
//           onChanged: (password) =>
//               context.read<ProfileEditCubit>().passwordChanged(password),
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'auth.password'.tr(),
//             helperText: '',
//             errorText:
//                 state.password.invalid ? 'auth.invalid_password'.tr() : null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _ConfirmPasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileEditCubit, ProfileEditState>(
//       buildWhen: (previous, current) =>
//           previous.password != current.password ||
//           previous.password_again != current.password_again,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('ProfileForm_confirmedPasswordInput_textField'),
//           onChanged: (confirmPassword) => context
//               .read<ProfileEditCubit>()
//               .confirmedPasswordChanged(confirmPassword),
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'auth.confirm_password'.tr(),
//             helperText: '',
//             errorText: state.password_again.invalid
//                 ? 'auth.passwords_do_not_match'.tr()
//                 : null,
//           ),
//         );
//       },
//     );
//   }
// }

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileEditCubit, ProfileEditState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : PrimaryBtn(
                key: const Key('ProfileForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () =>
                        context.read<ProfileEditCubit>().profileFormSubmitted()
                    : null,
                label: 'Update Profile'.tr(),
              );
      },
    );
  }
}
