// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/bootstrap.dart';

import 'package:oneshout/common/common.dart' as c;
import 'package:oneshout/core.dart';

import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/home/home.dart';
import 'package:oneshout/modules/iap/iap_page.dart';
import 'package:oneshout/modules/iap/iap_routes.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/locator.dart';
import 'package:oneshout/modules/locator/locator_routes.dart';
import 'package:oneshout/modules/settings/settings.dart';
import 'package:oneshout/modules/shout/shout.dart';
import 'package:oneshout/notifications_bloc.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
    required NotificationAppLaunchDetails notificationAppLaunchDetails,
  })  : _authenticationRepository = authenticationRepository,
        _notificationAppLaunchDetails = notificationAppLaunchDetails;

  final AuthenticationRepository _authenticationRepository;
  final NotificationAppLaunchDetails _notificationAppLaunchDetails;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with UiLogger {
  late AuthBloc bloc;
  String? initialMessage;
  bool _resolved = false;

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    // initialLocation: homeRoute,
    observers: [
      // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      BotToastNavigatorObserver(),
    ],
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
          // return const IAPPage();
        },
        routes: <GoRoute>[
          ...authRoutes,
          ...settingsRoutes,
          ...contactsRoutes,
          ...permissionsRoutes,
          ...shoutRoutes,
          ...locatorRoutes,
          ...iapRoutes,
          ...subscriptionRoutes,
        ],
      ),
    ],
    // redirect to the login page if the user is not logged in
    redirect: (ctx, state) async {
      // return '/';
      // if the user is not logged in, they need to login
      final loggedIn = bloc.state.status == AuthStatus.authenticated;
      final loggingIn = state.matchedLocation == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';

      // if (!bloc.state.user.confirmed) return '/confirm_phone';
      // if (!bloc.state.user.confirmed) return '/sign_up';
      if (loggedIn &&
          !bloc.state.user.confirmed &&
          bloc.state.user.type == 'group' &&
          state.location == '/') {
        return '/change_password';
      }
      // await Navigator.of(context).push<void>(ChangePasswordPage.route());
      // if the user is logged in but still on the login page,
      // send them to the home page.
      if (loggingIn) return '/';

      // no need to redirect at all
      return null;
    },
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: bloc,
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => widget._authenticationRepository,
          lazy: true,
        ),
        RepositoryProvider(
          create: (context) => ShoutRepository(
            shoutApi: ShoutApi(),
            auth: widget._authenticationRepository,
          ),
          lazy: true,
        ),
        RepositoryProvider(
          create: (context) => LocatorRepository(
            locatorApi: LocatorApi(),
            auth: widget._authenticationRepository,
          ),
          lazy: true,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              authenticationRepository: widget._authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => NetworkConnectionBloc(),
          ),
          BlocProvider<ShoutCubit>(
            create: (context) => ShoutCubit(
              networkConnectionBloc: context.read<NetworkConnectionBloc>(),
              shoutRepository: context.read<ShoutRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider<LocatorCubit>(
            create: (context) => LocatorCubit(
              locatorRepository: context.read<LocatorRepository>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            bloc = context.read<AuthBloc>();

            return MultiBlocListener(
              listeners: [
                BlocListener<NotificationBloc, NotificationState>(
                  bloc: context.read<NotificationBloc>(),
                  listener: (context, state) async {
                    switch (state.type) {
                      case NotificationTypeReceived.locationRequest:
                        final data = state.data?.payload?['data']
                            as Map<String, dynamic>;
                        _router.push(
                          '/$locatorRequestRoute',
                          extra: {'phone': data['phone'], 'name': data['name']},
                        );
                        break;
                      case NotificationTypeReceived.shout:
                        final data = state.data?.payload?['data']
                            as Map<String, dynamic>;
                        final shout = Shout.fromJson(data);

                        print(data);
                        print(shout.toJson());

                        _router.push(
                          '/$shoutsRoute/$shoutTrackerRoute',
                          extra: shout,
                        );

                        break;

                      case NotificationTypeReceived.general:
                        break;
                      case NotificationTypeReceived.initialize:
                        // TODO: Handle this case.
                        break;
                    }
                  },
                ),
                BlocListener<NetworkConnectionBloc, NetworkConnectionState>(
                  listener: (context, state) {
                    if (state.networkConnectionStatus ==
                        NetworkConnectionStatus.connected) {
                      notify.toast('Connection has been established');
                    } else {
                      notify.toast('No connection is established');
                    }
                  },
                ),
                BlocListener<AuthBloc, AuthState>(
                  // listenWhen: (previous, current) =>
                  //     previous.status != current.status,
                  listener: (context, state) {
                    //check user subscription.

                    if (state.status == AuthStatus.authenticated &&
                        state.user.jwt != null) {
                      httpNetworkController.setup(
                        baseUrl: c.Urls.baseApi,
                        token: state.user.jwt!,
                      );

                      //call user data
                      Timer(const Duration(seconds: 5), () async {
                        await context
                            .read<LocatorCubit>()
                            .startLocationUpdate();
                      });
                    }
                  },
                ),
              ],
              child: AdaptiveTheme(
                light: c.MyAppTheme.light,
                dark: c.MyAppTheme.dark,
                initial: themes.theme ?? AdaptiveThemeMode.system,
                builder: (theme, darkTheme) => MaterialApp.router(
                  theme: theme,
                  scaffoldMessengerKey: AppCore.scaffoldMessengerKey,
                  localizationsDelegates: [
                    ...context.localizationDelegates,
                  ],
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  routerConfig: _router,
                  builder: BotToastInit(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.error});
  final Exception? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(error?.toString() ?? 'Page not found'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// class NotificationEvent {
//   const NotificationEvent(this.payload);

//   //carries the payload sent for notification
//   final String payload;
// }

// class NotificationErrorEvent extends NotificationEvent {
//   const NotificationErrorEvent(this.error) : super(null);
//   final String error;
// }

// class NotificationState extends Equatable {
//   const NotificationState();

//   @override
//   List<Object> get props => [];
// }

// class StartUpNotificationState extends NotificationState {}

// class IndexedNotification extends NotificationState {
//   const IndexedNotification(this.index);
//   final int index;

//   @override
//   List<Object> get props => [this.index];

//   @override
//   bool operator ==(Object other) => false;

//   @override
//   int get hashCode => super.hashCode;
// }
