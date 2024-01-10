// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// Login Form
class LoginForm extends StatelessWidget {
  /// Login Form
  const LoginForm({
    Key? key,
    required this.authSettings,
  }) : super(key: key);

  final AppAuthSettings authSettings;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
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
      child: ResponsiveWidget(
        mobile: _LoginFormWidget(
          authSettings: authSettings,
        ),
        desktop: Center(
          child: SizedBox(
            width: 300,
            child: _LoginFormWidget(
              authSettings: authSettings,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormWidget extends StatelessWidget {
  _LoginFormWidget({
    Key? key,
    required this.authSettings,
  }) : super(key: key);
  final AppAuthSettings authSettings;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const Spacer(),
              if (authSettings.pathToLogo != null)
                Image.asset(
                  authSettings.pathToLogo!,
                  height: authSettings.logoSize,
                ),
              VSpace.xxxl,
              // if (authSettings.pathToLogo != null) const Spacer(),
              ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VSpace.xl,

                  Row(
                    children: [
                      Text(
                        'auth.login',
                        style: TextStyles.h2,
                      ).tr(),
                    ],
                  ),

                  if (authSettings.authProviders!.contains(AuthProviders.email))
                    const EmailPasswordForm(),

                  if (!DeviceOS.isMacOS) ...[
                    VSpace.xl,
                    if (authSettings.authProviders!
                            .contains(AuthProviders.email) &&
                        !(const bool.fromEnvironment('IS_GROUP_TARGET')))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                    VSpace.xl,
                    if (authSettings.authProviders!
                        .contains(AuthProviders.google)) ...[
                      VSpace.xl,
                      _GoogleLoginButton(),
                    ],
                    if (authSettings.authProviders!
                            .contains(AuthProviders.apple) &&
                        (DeviceOS.isIOS || DeviceOS.isMacOS)) ...[
                      VSpace.xl,
                      _AppleLoginButton(),
                    ],
                    if (authSettings.authProviders!
                        .contains(AuthProviders.phone)) ...[
                      VSpace.xl,
                      _PhoneLoginButton()
                    ],
                    if (authSettings.authProviders!
                        .contains(AuthProviders.facebook)) ...[
                      VSpace.xl,
                      _FacebookLoginButton()
                    ],
                    if (authSettings.authProviders!
                        .contains(AuthProviders.twitter)) ...[
                      VSpace.xl,
                      _TwitterLoginButton()
                    ],
                  ],

                  // ],

                  VSpace.xxl,
                  if (!(const bool.fromEnvironment('IS_GROUP_TARGET')))
                    _SignUpButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPasswordForm extends StatelessWidget {
  const EmailPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VSpace.xl,
        _PhoneInput(),
        VSpace.lg,
        _PasswordInput(),
        // VSpace.sm,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _ForgotPasswordButton(),
          ],
        ),
        VSpace.xl,
        _LoginButton(),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return IntlPhoneField(
          key: const Key('loginForm_phoneInput_textField'),
          initialCountryCode: 'NG',
          onChanged: (phone) =>
              context.read<LoginCubit>().phoneChanged(phone.completeNumber),
          controller: context.read<LoginCubit>().phoneTC,
          dropdownIconPosition: IconPosition.trailing,
          // decoration: InputDecoration(
          //   labelText: 'auth.phone'.tr(),
          //   helperText: '',
          //   errorText: state.phone.invalid ? 'auth.invalid_phone'.tr() : null,
          // ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) {
            return context.read<LoginCubit>().passwordChanged(password);
          },
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

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const SizedBox(
                height: 53,
                width: 53,
                child: CircularProgressIndicator(),
              )
            : PrimaryBtn(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginCubit>().logInWithCredentials();
                        //if group user, request change of password.
                        // if (state.password.value == state.phone.value &&
                        //     const bool.fromEnvironment('IS_GROUP_TARGET')) {
                        //   Navigator.of(context)
                        //       .push<void>(ChangePasswordPage.route());
                        // }
                      }
                    : () {},
                label: 'auth.login'.tr(),
                // child: const Text('auth.login').tr(),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleBtn(
      key: const Key('loginForm_googleLogin_raisedButton'),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _PhoneLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PhoneNumberBtn(
      key: const Key('loginForm_phoneLogin_raisedButton'),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppleLoginBtn(
      key: const Key('loginForm_appleLogin_raisedButton'),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FacebookLoginBtn(
      key: const Key('loginForm_facebookLogin_raisedButton'),
      onPressed: () => context.read<LoginCubit>().signInWithFacebook(),
    );
  }
}

class _TwitterLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TwitterLoginBtn(
      key: const Key('loginForm_twitterLogin_raisedButton'),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('New to ${'app_title'.tr()}?'),
        HSpace.xs,
        TextLink(
          'auth.register'.tr(),
          highlight: true,
          key: const Key('loginForm_register_flatButton'),
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        ),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextLink(
      'auth.forgot_password_q'.tr(),
      highlight: true,
      key: const Key('loginForm_forgotPassword_flatButton'),
      onPressed: () =>
          Navigator.of(context).push<void>(ForgotPasswordPage.route()),
    );
  }
}
