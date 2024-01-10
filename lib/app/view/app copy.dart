// // Copyright (c) 2022, Very Good Ventures
// // https://verygood.ventures
// //
// // Use of this source code is governed by an MIT-style
// // license that can be found in the LICENSE file or at
// // https://opensource.org/licenses/MIT.

// import 'dart:async';
// import 'dart:io';

// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:app_auth/app_auth.dart';
// import 'package:app_core/app_core.dart';
// import 'package:bot_toast/bot_toast.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:go_router/go_router.dart';

// import 'package:oneshout/common/common.dart' as c;
// import 'package:oneshout/core.dart';

// import 'package:oneshout/modules/contacts/contacts.dart';
// import 'package:oneshout/modules/home/home.dart';
// import 'package:oneshout/modules/locator/data/data.dart';
// import 'package:oneshout/modules/locator/locator.dart';
// import 'package:oneshout/modules/locator/locator_api.dart';
// import 'package:oneshout/modules/locator/locator_routes.dart';
// import 'package:oneshout/modules/settings/settings.dart';
// import 'package:oneshout/modules/shout/shout.dart';
// import 'package:oneshout/modules/shout/shout_routes.dart';

// class App extends StatelessWidget {
//   App({super.key, required AuthenticationRepository authenticationRepository})
//       : _authenticationRepository = authenticationRepository;

//   final AuthenticationRepository _authenticationRepository;
//   late AuthBloc bloc;

//   late final GoRouter _router = GoRouter(
//     debugLogDiagnostics: true,
//     // initialLocation: homeRoute,
//     observers: [
//       // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
//       BotToastNavigatorObserver(),
//     ],
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (BuildContext context, GoRouterState state) =>
//             const HomePage(),
//         routes: <GoRoute>[
//           ...authRoutes,
//           ...settingsRoutes,
//           ...contactsRoutes,
//           ...permissionsRoutes,
//           ...shoutRoutes,
//           ...locatorRoutes,
//         ],
//       ),
//     ],
//     // redirect to the login page if the user is not logged in
//     redirect: (ctx, state) async {
//       // return '/';
//       // if the user is not logged in, they need to login
//       final loggedIn = bloc.state.status == AuthStatus.authenticated;
//       final loggingIn = state.subloc == '/login';
//       if (!loggedIn) return loggingIn ? null : '/login';

//       // if (!bloc.state.user.confirmed) return '/confirm_phone';
//       // if (!bloc.state.user.confirmed) return '/sign_up';

//       // if the user is logged in but still on the login page,
//       // send them to the home page.
//       if (loggingIn) return '/';

//       // no need to redirect at all
//       return null;
//     },
//     // changes on the listenable will cause the router to refresh it's route
//     refreshListenable: bloc,
//     errorBuilder: (context, state) => NotFoundPage(error: state.error),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider(
//           create: (context) => _authenticationRepository,
//           lazy: true,
//         ),
//         RepositoryProvider(
//           create: (context) => ShoutRepository(
//             shoutApi: ShoutApi(),
//             auth: _authenticationRepository,
//           ),
//           lazy: true,
//         ),
//         RepositoryProvider(
//           create: (context) => LocatorRepository(
//             locatorApi: LocatorApi(),
//             auth: _authenticationRepository,
//           ),
//           lazy: true,
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<AuthBloc>(
//             create: (_) =>
//                 AuthBloc(authenticationRepository: _authenticationRepository),
//           ),
//           BlocProvider(
//             create: (context) => NetworkConnectionBloc(),
//           ),
//           BlocProvider<ShoutCubit>(
//             create: (context) => ShoutCubit(
//               networkConnectionBloc: context.read<NetworkConnectionBloc>(),
//               shoutRepository: context.read<ShoutRepository>(),
//               authBloc: context.read<AuthBloc>(),
//             ),
//           ),
//           BlocProvider<LocatorCubit>(
//             create: (context) => LocatorCubit(
//               locatorRepository: context.read<LocatorRepository>(),
//             ),
//           ),
//         ],
//         child: Builder(
//           builder: (context) {
//             bloc = context.read<AuthBloc>();

//             return MultiBlocListener(
//               listeners: [
//                 BlocListener<NetworkConnectionBloc, NetworkConnectionState>(
//                   listener: (context, state) {
//                     if (state.networkConnectionStatus ==
//                         NetworkConnectionStatus.connected) {
//                       notify.toast('Connection has been established');
//                     } else {
//                       notify.toast('No connection is established');
//                     }
//                   },
//                 ),
//                 BlocListener<AuthBloc, AuthState>(
//                   // listenWhen: (previous, current) =>
//                   //     previous.status != current.status,
//                   listener: (context, state) {
//                     if (state.status == AuthStatus.authenticated &&
//                         state.user.jwt != null) {
//                       httpNetworkController.setup(
//                         baseUrl: c.Urls.baseApi,
//                         token: state.user.jwt!,
//                       );
//                       //call user data
//                       Timer(const Duration(seconds: 5), () async {
//                         context.read<LocatorCubit>().startLocationUpdate();
//                       });
//                     }
//                   },
//                 ),
//               ],
//               child: AdaptiveTheme(
//                 light: c.MyAppTheme.light,
//                 dark: c.MyAppTheme.dark,
//                 initial: themes.theme ?? AdaptiveThemeMode.system,
//                 builder: (theme, darkTheme) => MaterialApp.router(
//                   theme: theme,
//                   scaffoldMessengerKey: AppCore.scaffoldMessengerKey,
//                   localizationsDelegates: [
//                     ...context.localizationDelegates,
//                   ],
//                   supportedLocales: context.supportedLocales,
//                   locale: context.locale,
//                   debugShowCheckedModeBanner: false,
//                   routerConfig: _router,
//                   builder: BotToastInit(),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class NotFoundPage extends StatelessWidget {
//   const NotFoundPage({super.key, this.error});
//   final Exception? error;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(
//         builder: (context) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: Text(error?.toString() ?? 'Page not found'),
//               ),
//               ElevatedButton(
//                 onPressed: () => context.go('/'),
//                 child: const Text('Back'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
