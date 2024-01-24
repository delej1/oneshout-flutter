// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  /// page
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        minimum: EdgeInsets.all(Insets.offset),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) =>
                ForgotPasswordCubit(context.read<AuthenticationRepository>()),
            child: const ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }
}
