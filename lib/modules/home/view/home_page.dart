// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: use_build_context_synchronously

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router_flow/go_router_flow.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/bootstrap.dart';
import 'package:oneshout/common/consts/consts.dart';
import 'package:oneshout/common/widgets/native_dialog.dart';
import 'package:oneshout/core.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/home/cubit/home_states.dart';
import 'package:oneshout/modules/home/home.dart';
import 'package:oneshout/modules/home/view/permissions_page.dart';
import 'package:oneshout/modules/iap/iap.dart';
import 'package:oneshout/modules/iap/iap_routes.dart';
import 'package:oneshout/modules/iap/paywall.dart';
import 'package:oneshout/modules/locator/locator_api.dart';
import 'package:oneshout/modules/locator/locator_routes.dart';
import 'package:oneshout/modules/settings/settings_routes.dart';
import 'package:oneshout/modules/shout/shout.dart';
import 'package:oneshout/modules/shout/shout_routes.dart';
import 'package:oneshout/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => ContactsCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with UiLogger {
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkFcm();

      await initRevenueCat();
    });

    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();
  }

  Future<void> initRevenueCat() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    final user = context.read<AuthBloc>().state.user;

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = user.id
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = user.id
        ..observerMode = false;
    }
    await Purchases.configure(configuration);

    iapAppData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      iapAppData.appUserID = await Purchases.appUserID;

      final customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]!.isActive)
          ? iapAppData.entitlementIsActive = true
          : iapAppData.entitlementIsActive = false;

      setState(() {});
    });
  }

  void _checkFcm() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      logger.d('getInitialMessage');

      setState(
        () {
          _resolved = true;
          initialMessage = message == null ? 'null' : message.data.toString();
        },
      );

      if (message != null) {
        logger.d('getInitialMessage: Received ${message.data}');
        final notificationData = NotificationData.fromJson(message.data);
        final payload = notificationData.payload;

        if (payload != null && payload.isNotEmpty) {
          processRemoteMessage(notificationData);
        }
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   logger.d('onMessageOpenedApp');
    //   final notificationData = NotificationData.fromJson(message.data);
    //   final payload = notificationData.payload;

    //   if (payload != null && payload.isNotEmpty) {
    //     processRemoteMessage(notificationData);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context)..checkPermissions();
    // ..checkUser();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('One Shout'),
                if (const String.fromEnvironment('ENV_TYPE') == 'live')
                  Container()
                else
                  Text(
                    '(' +
                        const String.fromEnvironment('ENV_TYPE').toUpperCase() +
                        ')',
                  )
              ],
            ),
            if (const bool.fromEnvironment('IS_GROUP_TARGET')) ...[
              VSpace.xs,
              Text(
                'Corporate'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 7,
                  color: Colors.grey,
                ),
              ),
            ]
          ],
        ),
        // toolbarHeight: 40,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Column(
            //   children: [
            //     Text(_resolved ? 'Resolved' : 'Resolving'),
            //     Text(initialMessage ?? 'None'),
            //   ],
            // ),
            Expanded(
              child: ClippedContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is ReadyState) {
                          return Padding(
                            padding: EdgeInsets.zero,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MenuItem(
                                  icon: Icons.group,
                                  label: 'contacts'.tr(),
                                  onTap: () async {
                                    context.go('/$contactsRoute');
                                  },
                                ),
                                HSpace.xl,
                                MenuItem(
                                  icon: Icons.notifications,
                                  label: 'alerts'.tr(),
                                  onTap: () {
                                    final user = BlocProvider.of<AuthBloc>(ctx)
                                        .state
                                        .user;
                                    if (isGroupTarget &&
                                        !user.hasValidSubscription!) {
                                      context.go('/subscription');
                                      return;
                                    }
                                    context.go('/$shoutsRoute');
                                  },
                                ),
                                HSpace.xl,
                                MenuItem(
                                  icon: Icons.settings,
                                  label: 'settings.settings'.tr(),
                                  onTap: () => context.go('/$settingsRoute'),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    const Spacer(),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       await Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (context) => const PermissionsPage(),
                    //         ),
                    //       );
                    //     },
                    //     child: const Text('perms')),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is ReadyState) {
                          //add loader code here after boolean check.....................................
                          return Column(
                            children: [
                              const HelpWidget(),
                              VSpace.xxl,
                              const LocateWidget(),
                            ],
                          );
                        } else if (state is AcceptPolicyState) {
                          return Column(
                            children: [
                              const Text(
                                'Privacy Policy',
                                style: TextStyle(fontSize: 24),
                              ),
                              VSpace.lg,
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                          'By clicking continue you agree to our ',
                                    ),
                                    TextSpan(
                                      text: 'Terms of Use and Privacy Policy.',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(
                                            Uri.parse(
                                              'https://one-shout.netlify.app/',
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              VSpace.xxl,
                              ElevatedButton(
                                onPressed: () async {
                                  await BlocProvider.of<HomeCubit>(context)
                                      .acceptPolicy();
                                },
                                child: const Text('Continue').tr(),
                              )
                            ],
                          );
                        } else if (state is RequirePermissionState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.perm_device_information_sharp,
                                size: 120,
                                color: Colors.grey.shade300,
                              ),
                              VSpace.lg,
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'view_grant_permission_msg.'.tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              VSpace.lg,
                              ElevatedButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PermissionsPage(),
                                    ),
                                  );
                                  await cubit.checkPermissions();
                                },
                                child: const Text('view_grant_permission').tr(),
                              )
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    const Spacer(),
                    // BlocBuilder<ShoutCubit, ShoutState>(
                    //   builder: (context, state) {
                    //     if (state.status is Shout) {
                    //       return const Text(
                    //         'Status: Failed',
                    //         style: TextStyle(color: Colors.red),
                    //       );
                    //     } else {
                    //       return Container();
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpWidget extends StatefulWidget {
  const HelpWidget({super.key});

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  bool _isLoading = false;
  bool _hasPremium = false;
  bool _revenueCatInitiated = false;
  @override
  void initState() {
    super.initState();
    if (!isGroupTarget) {
      perfomMagic();
    } else {}
  }

  /*
    We should check if we can magically change the weather 
    (subscription active) and if not, display the paywall.
  */
  Future<void> perfomMagic() async {
    setState(() {
      _isLoading = true;
      _revenueCatInitiated = false;
    });

    final customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]!.isActive == true) {
      // iapAppData.currentData = WeatherData.generateData();
      notify.toast(
        'Entitlement: ${customerInfo.entitlements.all[entitlementID]!.identifier}',
      );

      setState(() {
        _isLoading = false;
        _hasPremium = true;
        _revenueCatInitiated = true;
        //print("HAS IN-APP SUBSCRIPTION");...............................................
        // final user = BlocProvider.of<AuthBloc>(ctx).state.user;
        // print(user.hasValidSubscription.toString());
      });
    } else {
      setState(() {
        _hasPremium = false;
        _revenueCatInitiated = true;
        // print("NO IN-APP SUBSCRIPTION");...............................................
        // final user = BlocProvider.of<AuthBloc>(ctx).state.user;
        // print(user.hasValidSubscription.toString());
      });
      context.go('/$iapRoute');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final user = BlocProvider.of<AuthBloc>(ctx).state.user;.....................................
    final width = MediaQuery.of(context).size.width - 64;

    return Center(
      child: ElevatedButton(
        //major edit here on button press........................................................
        //onPressed: () => user.hasValidSubscription!?onHelp(context):context.go('/$iapRoute'),
        onPressed: () => onHelp(context),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width, width),
          maximumSize: const Size(300, 150),
        ),
        child: Text(
          '${'help'.tr().toUpperCase()}!',
          style: TextStyle(
            fontSize: width / 5,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> onHelp(BuildContext ctx) async {
    final contactsCubit = BlocProvider.of<ContactsCubit>(ctx);
    final user = BlocProvider.of<AuthBloc>(ctx).state.user;
    //......................................................
    // final location = await MyLocatorApi().getLocation();
    // print(location?.toJson());
    //return;
    if (!_hasPremium && _revenueCatInitiated) {
    await perfomMagic();
    ctx.go('/$iapRoute');
    return;
    }

    await perfomMagic();
    ctx.go('/$contactsRoute');
    //..................................................
    if (isGroupTarget && !user.hasValidSubscription!) {
      ctx.go('/subscription');
      return;
    }
    try {
      final c = await contactsCubit.loadContacts(enabled: true);
      if (c.isEmpty) {
        ctx.go('/$contactsRoute');
      } else {
        ctx.go('/$shoutRoute');
      }
    } catch (e) {
      BlocProvider.of<HomeCubit>(ctx).logError(e);
    }
  }
}

class LocateWidget extends StatelessWidget {
  const LocateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 64;

    return Center(
      child: ElevatedButton(
        onPressed: () {
          final user = BlocProvider.of<AuthBloc>(ctx).state.user;
          if (isGroupTarget && !user.hasValidSubscription!) {
            context.go('/subscription');
            return;
          }
          context.push('/$locatorRoute');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          fixedSize: Size(width, width),
          maximumSize: const Size(300, 150),
        ),
        child: Text(
          'locate'.tr().toUpperCase(),
          style: TextStyle(
            fontSize: width / 7,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(fontSize: FontSizes.s12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class HomeText extends StatelessWidget {
  const HomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((HomeCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.headline1);
  }
}
