// ignore_for_file: lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/home/home.dart';
import 'package:oneshout/modules/home/view/permissions_page.dart';
import 'package:oneshout/modules/home/view/subscription_page.dart';
import 'package:oneshout/modules/profile/profile.dart';

const String homeRoute = '/';
const String permissionsRoute = 'permissions';
const String testRoute = 'test';
const String profileRoute = '/profile';
const String profileViewRoute = '/profile/view';
List<GoRoute> homeRoutes = [
  GoRoute(
    path: homeRoute,
    name: 'HomePage',
    builder: (context, state) => const HomePage(),
  ),
];
List<GoRoute> permissionsRoutes = [
  GoRoute(
    path: permissionsRoute,
    name: 'PermissionsPage',
    builder: (context, state) => const PermissionsPage(),
  ),
];

const String loginRoute = 'login';
const String signUpRoute = 'sign_up';
const String changePasswordRoute = 'change_password';

List<GoRoute> authRoutes = [
  GoRoute(
    path: loginRoute,
    name: 'LoginPage',
    builder: (context, state) => const LoginPage(
      authSettings: AppAuthSettings(
        pathToLogo: 'assets/images/icon.png',
        authProviders: [
          AuthProviders.email,
          // AuthProviders.google,
          // AuthProviders.phone,
        ],
      ),
    ),
  ),
  GoRoute(
    path: signUpRoute,
    name: 'SignUpPage',
    builder: (context, state) => const SignUpPage(),
  ),
  GoRoute(
    path: changePasswordRoute,
    name: 'ChangePasswordPage',
    builder: (context, state) => const ChangePasswordPage(),
  ),
  GoRoute(
    path: 'profile',
    name: 'ProfilePage',
    builder: (context, state) => const ProfilePage(),
    routes: [
      GoRoute(
        path: 'view',
        name: 'ProfileViewPage',
        builder: (context, state) => const ProfileViewPage(),
      ),
      GoRoute(
        path: 'edit',
        name: 'ProfileForm',
        builder: (context, state) => const ProfileForm(),
      ),
    ],
  ),
];

List<GoRoute> subscriptionRoutes = [
  GoRoute(
    path: 'subscription',
    name: 'SubscriptionPage',
    builder: (context, state) => const SubscriptionPage(),
  ),
];

// class HomeLocation extends BeamLocation<BeamState> {
//   @override
//   List<String> get pathPatterns => ['/', '/test'];

//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         const BeamPage(
//           key: ValueKey('home'),
//           name: 'HomePage',
//           title: 'Home',
//           child: HomePage(),
//         ),
//         if (state.uri.pathSegments.contains('test'))
//           const BeamPage(
//             key: ValueKey('test'),
//             name: 'TestPage',
//             title: 'Test',
//             child: TestPage(),
//           ),
//       ];

//   @override
//   List<BeamGuard> get guards => [
//         // Guard /home by beaming to /login if the user is unauthenticated:
//         BeamGuard(
//           pathPatterns: [homeRoute],
//           check: (context, state) =>
//               context.read<AuthBloc>().state.status == AuthStatus.authenticated,
//           beamToNamed: (_, __) => loginRoute,
//         ),
//       ];
// }
