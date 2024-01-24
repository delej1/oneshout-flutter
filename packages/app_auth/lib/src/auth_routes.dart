// // ignore_for_file: lines_longer_than_80_chars

// import 'package:app_auth/app_auth.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthLocations extends BeamLocation<BeamState> {
//   @override
//   List<String> get pathPatterns => ['/auth/:routeName'];

//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final pages = [
//       const BeamPage(
//         key: ValueKey('login'),
//         name: 'LoginPage',
//         title: 'Login',
//         child: LoginPage(),
//       ),
//       if (state.uri.pathSegments.contains('forgot_password'))
//         const BeamPage(
//           key: ValueKey('forgot_password'),
//           name: 'ForgotPasswordPage',
//           title: 'Forgot Password',
//           child: ForgotPasswordPage(),
//         ),
//       if (state.uri.pathSegments.contains('sign_up'))
//         const BeamPage(
//           key: ValueKey('sign_up'),
//           name: 'SignUpPage',
//           title: 'Sign Up',
//           child: SignUpPage(),
//         ),
//     ];

//     return pages;
//   }

//   @override
//   List<BeamGuard> get guards => [
//         // Guard /login by beaming to /home if the user is authenticated:
//         BeamGuard(
//           pathPatterns: [loginRoute],
//           check: (context, state) => context.read<AuthBloc>().state.status == AuthStatus.unauthenticated,
//           beamToNamed: (_, __) => '/',
//         ),
//       ];
// }
