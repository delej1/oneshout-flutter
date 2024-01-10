// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content:
                    Text(state.errorMessage ?? 'auth.sign_up_failure'.tr()),
              ),
            );
        }
      },
      builder: (context, state) {
        return const _SignUpFormWidget();
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: (state.status == FormzStatus.submissionSuccess)
              ? const _SignUpSuccessfulWidget()
              : const _SignUpFormWidget(),
        );
      },
    );
  }
}

class _SignUpFormWidget extends StatelessWidget {
  const _SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.step != current.step,
      builder: (context, state) {
        switch (state.step) {
          case 1:
            return _stepOne(context);
          case 2:
            return _stepTwo(context);
          case 3:
            return _stepThree(context);
          case 4:
            return _stepFour(context);
          default:
            return _stepOne(context);
        }
      },
    );
  }
}

Widget _stepOne(BuildContext context) {
  final cubit = context.read<SignUpCubit>();

  return Column(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              'auth.sign_up'.tr(),
              style: TextStyles.h2,
            ),
          ),
        ],
      ),
      VSpace.xl,
      _PhoneInput(),
      _PasswordInput(),
      _ConfirmPasswordInput(),
      VSpace.xxl,
      PrimaryBtn(
        label: 'auth.next'.tr(),
        onPressed: cubit.signUp,
      ),
      VSpace.xxxl,
    ],
  );
}

Widget _stepTwo(BuildContext context) {
  final cubit = context.read<SignUpCubit>();

  return BlocListener<SignUpCubit, SignUpState>(
    listener: (context, state) {
      if (state.verificationCodeStatus == VerificationCodeStatus.resending) {
        notify.toast('Resending verification code...');
      }
      if (state.verificationCodeStatus == VerificationCodeStatus.resent) {
        notify.toast('Verification code has been sent.');
      }
    },
    child: BlocBuilder<SignUpCubit, SignUpState>(
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

              borderColor: Theme.of(context).colorScheme.primary,
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
                onPressed: cubit.resendVerificationCode,
              ),
            VSpace.xl,
          ],
        );
      },
    ),
  );
}

Widget _stepThree(BuildContext context) {
  final cubit = context.read<SignUpCubit>();
  return Column(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      VSpace.xl,
      Text(
        'auth.personal_info'.tr(),
        style: TextStyles.h2,
        textAlign: TextAlign.center,
      ),
      VSpace.xl,
      _EmailInput(),
      _FNameInput(),
      _LNameInput(),
      VSpace.xl,
      PrimaryBtn(
        label: 'Next'.tr(),
        onPressed: cubit.submitProfileInfo,
      ),
      VSpace.xl,
    ],
  );
}

Widget _stepFour(BuildContext context) {
  final cubit = context.read<SignUpCubit>();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VSpace.xl,
      Text(
        'auth.select_plan'.tr(),
        style: TextStyles.h2,
      ),
      Spacer(),
      PrimaryBtn(
        label: 'Free'.tr(),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

class _SignUpSuccessfulWidget extends StatelessWidget {
  const _SignUpSuccessfulWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('A verification code has been sent to ${cubit.state.phone}.'),
        const SizedBox(height: 16),
        ElevatedButton(
          key: const Key('okForm_back_raisedButton'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'auth.email'.tr(),
            helperText: '',
            errorText: state.email.invalid ? 'auth.invalid_email'.tr() : null,
          ),
        );
      },
    );
  }
}

class _FNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.firstname != current.firstname,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_firstnameInput_textField'),
          onChanged: (firstname) =>
              context.read<SignUpCubit>().firstnameChanged(firstname),
          decoration: InputDecoration(
            labelText: 'auth.firstname'.tr(),
            helperText: '',
            errorText:
                state.firstname.invalid ? 'auth.invalid_name'.tr() : null,
          ),
        );
      },
    );
  }
}

class _LNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.lastname != current.lastname,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_lastnameInput_textField'),
          onChanged: (lastname) =>
              context.read<SignUpCubit>().lastnameChanged(lastname),
          decoration: InputDecoration(
            labelText: 'auth.lastname'.tr(),
            helperText: '',
            errorText: state.lastname.invalid ? 'auth.invalid_name'.tr() : null,
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return IntlPhoneField(
          key: const Key('loginForm_phoneInput_textField'),
          initialCountryCode: 'NG',
          onChanged: (phone) => context.read<SignUpCubit>().phoneChanged(phone),
          controller: context.read<SignUpCubit>().phoneTC,
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : PrimaryBtn(
                key: const Key('signUpForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                    : () {},
                label: 'auth.sign_up'.tr(),
              );
      },
    );
  }
}
