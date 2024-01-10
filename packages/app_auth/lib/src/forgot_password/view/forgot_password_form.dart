// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:formz/formz.dart';
import 'package:app_form_fields/app_form_fields.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'auth.authentication_failure'.tr(),
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.passwordResetCompleted) {
          return const _PasswordResetCompletedWidget();
        }
        switch (state.step) {
          case 1:
            return _stepOne(context);
          case 2:
            return _stepTwo(context);
          case 3:
            return _stepThree(context);
          default:
            return _stepOne(context);
        }
      },
    );
  }
}

Widget _stepOne(BuildContext context) {
  return Align(
    alignment: const Alignment(0, -1 / 3),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Image.asset(
            'assets/images/forgot_password.png',
            // height: 120,
          ),
        ),
        Column(
          children: [
            VSpace.xl,
            ...[
              Row(
                children: [
                  SizedBox(
                    // width: 130,
                    child: Text(
                      'auth.forgot_password_q'.tr(),
                      style: TextStyles.h2,
                    ),
                  ),
                ],
              ),
              VSpace.xl,
              const Text(
                "Don't worry! it happens. Please enter the phone number associated with your account.",
                textAlign: TextAlign.left,
              ),
              VSpace.xxl,
              _PhoneInput(),
              _ResetButton(),
              VSpace.xxl,
              TextLink(
                'Back'.tr(),
                highlight: true,
                key: const Key('loginForm_register_flatButton'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ],
        )
      ],
    ),
  );
}

Widget _stepTwo(BuildContext context) {
  final cubit = context.read<ForgotPasswordCubit>();

  return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
    listener: (context, state) {
      if (state.verificationCodeStatus == VerificationCodeStatus.resending) {
        notify.toast('Resending verification code...');
      }
      if (state.verificationCodeStatus == VerificationCodeStatus.resent) {
        notify.toast('Verification code has been sent.');
      }
    },
    child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VSpace.xxxl,
            Text(
              'auth.verification'.tr(),
              style: TextStyles.h2,
            ),
            VSpace.md,
            Text(
              'auth.verification_msg'
                  .tr(namedArgs: {'number': cubit.state.phone.value}),
              textAlign: TextAlign.center,
            ),
            VSpace.lg,
            TextLink(
              'auth.change_number'.tr(),
              onPressed: () {
                cubit.gotoStep(1);
              },
            ),
            const Spacer(),
            VSpace.xl,
            OtpTextField(
              numberOfFields: 5,

              borderColor: Theme.of(context).dividerColor,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) async {
                await cubit.confirmVerificationCode(verificationCode);
              }, // end onSubmit
            ),
            VSpace.xl,
            Text(
              'auth.verification_explanation'.tr(),
              textAlign: TextAlign.center,
            ),
            VSpace.xl,
            TextLink(
              'auth.verification_no_code'.tr(),
              onPressed: cubit.noCode,
            ),
            VSpace.xl,
            const Spacer(),
            if (cubit.state.verificationCodeStatus ==
                    VerificationCodeStatus.failed ||
                cubit.state.verificationCodeStatus ==
                    VerificationCodeStatus.none)
              PrimaryBtn(
                label: 'auth.resend_code'.tr(),
                onPressed: cubit.sendVerificationCode,
              ),
            VSpace.xl,
          ],
        );
      },
    ),
  );
}

Widget _stepThree(BuildContext context) {
  final cubit = context.read<ForgotPasswordCubit>();
  return Column(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      VSpace.xl,
      Text(
        'Enter Password'.tr(),
        style: TextStyles.h2,
        textAlign: TextAlign.center,
      ),
      VSpace.xl,
      _PasswordInput(),
      _ConfirmPasswordInput(),
      VSpace.xl,
      PrimaryBtn(
        label: 'Change Password'.tr(),
        onPressed: cubit.state.status.isValidated ? cubit.sendPassword : null,
      ),
      VSpace.xl,
    ],
  );
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<ForgotPasswordCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'auth.password'.tr(),
            helperText: '',
            errorText:
                state.password.invalid ? 'auth.invalid_password'.tr() : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<ForgotPasswordCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'auth.confirm_password'.tr(),
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'auth.passwords_do_not_match'.tr()
                : null,
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return IntlPhoneField(
          key: const Key('forgotpass_phoneInput_textField'),
          initialCountryCode: 'NG',
          onChanged: (phone) =>
              context.read<ForgotPasswordCubit>().phoneChanged(phone),
          controller: context.read<ForgotPasswordCubit>().phoneTC,
          dropdownIconPosition: IconPosition.trailing,
          decoration: InputDecoration(
            labelText: 'Phone'.tr(),
            helperText: '',
            errorText: state.phone.invalid ? 'auth.invalid_phone'.tr() : null,
          ),
        );
      },
    );
  }
}

class _PasswordResetCompletedWidget extends StatelessWidget {
  const _PasswordResetCompletedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 100, color: Colors.green),
        VSpace.xl,
        const Text('Your password reset is successful. Please login.'),
        VSpace.xl,
        PrimaryBtn(
          key: const Key('forgotPasswordForm_back_raisedButton'),
          onPressed: () => Navigator.of(context).pop(),
          label: 'login'.tr(),
        ),
      ],
    );
  }
}

class _ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : PrimaryBtn(
                label: 'auth.reset_password'.tr(),
                key: const Key('forgotPasswordForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<ForgotPasswordCubit>()
                        .sendVerificationCode()
                    : () {},
              );
      },
    );
  }
}
