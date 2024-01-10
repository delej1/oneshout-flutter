import 'package:app_auth/app_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login Page
class LoginPage extends StatelessWidget {
  /// Login Page
  const LoginPage({
    Key? key,
    this.authSettings = const AppAuthSettings(),
  }) : super(key: key);

  final AppAuthSettings authSettings;
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  /// page
  static Page page() => const MaterialPage<void>(
        child: LoginPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      // appBar: AppBar(title: const Text('auth.login').tr()),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: LoginForm(
            authSettings: authSettings,
          ),
        ),
      ),
    );
  }
}
