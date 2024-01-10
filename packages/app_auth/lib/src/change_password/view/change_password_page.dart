// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_auth/src/change_password/cubit/change_password_cubit.dart';
import 'package:app_auth/src/change_password/view/view.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  /// page
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ChangePasswordPage());
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
                ChangePasswordCubit(context.read<AuthenticationRepository>()),
            child: const ChangePasswordForm(),
          ),
        ),
      ),
    );
  }
}
