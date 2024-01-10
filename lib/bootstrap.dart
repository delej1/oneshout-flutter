// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_settings/src/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oneshout/app/app.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/core.dart';
import 'package:oneshout/injection.dart';
import 'package:oneshout/modules/iap/iap.dart';
import 'package:oneshout/notifications_bloc.dart';
import 'package:oneshout/store_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as pf;
import 'package:telephony/telephony.dart';

part 'modules/iap/iap_service.dart';
part 'notifications.dart';

final Telephony telephony = Telephony.instance;
PackageInfo? packageInfo;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (Platform.isAndroid) {
    await showNotification(message);
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> setup({required FirebaseOptions firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Settings.init(cacheProvider: SettingsCacheService());

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt
    ..registerSingletonAsync<AuthenticationRepository>(() async {
      final authenticationRepository =
          AuthenticationRepository(baseUrl: Urls.baseApi);
      await authenticationRepository.user.first;
      return authenticationRepository;
    })
    ..registerSingleton<NetworkConnectionBloc>(NetworkConnectionBloc())
    ..registerSingleton<NotificationBloc>(NotificationBloc());

  // GoRouter.usePathUrlStrategy();
}

Future<void> initFCM() async {
  LoggerController().logger.d('Initializing FCM Token...');

  final authenticationRepository =
      await getIt.getAsync<AuthenticationRepository>();
  final user = await authenticationRepository.user.first;

  FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
    //

    if (user.isNotEmpty) {
      unawaited(
        authenticationRepository.sendFCMTokenToServer(
          newToken: token,
          oldToken: authenticationRepository.readFCMTokenFromStorage()!,
        ),
      );
    }
  });

  if (user.isNotEmpty) {
    await authenticationRepository.getFCMToken();
  }
}

//...

Future<void> initRevenueCat(User? user) async {
  if (isGroupTarget) {
    return;
  }

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment('amazon');
    StoreConfig(
      store: useAmazon ? Store.amazonAppstore : Store.googlePlay,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }

  await pf.Purchases.setLogLevel(pf.LogLevel.verbose);

  var configuration = pf.PurchasesConfiguration("<public_google_sdk_key>");
  const userId = null;
  //user != null && user.isNotEmpty ? user.id : null;

  if (Platform.isAndroid) {
    configuration = pf.PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;
  } else if (Platform.isIOS) {
    configuration = pf.PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;
  }

  await pf.Purchases.configure(configuration);
  // await pf.Purchases.setup(StoreConfig.instance.apiKey);

  iapAppData.appUserID = await pf.Purchases.appUserID;

  pf.Purchases.addCustomerInfoUpdateListener((customerInfo) async {
    iapAppData.appUserID = await pf.Purchases.appUserID;

    final customerInfo = await pf.Purchases.getCustomerInfo();
    (customerInfo.entitlements.all[entitlementID] != null &&
            customerInfo.entitlements.all[entitlementID]!.isActive)
        ? iapAppData.entitlementIsActive = true
        : iapAppData.entitlementIsActive = false;

    // setState(() {});
  });
}

Future<void> bootstrap({required FirebaseOptions firebaseOptions}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  await runZonedGuarded(
    () async {
      await GetStorage.init();
      await setup(firebaseOptions: firebaseOptions);
      // await FlutterLibphonenumber().init();
      unawaited(
        PackageInfo.fromPlatform().then((value) => packageInfo = value),
      );

      // initOneSignal();

      final authenticationRepository =
          await getIt.getAsync<AuthenticationRepository>();

      final user = await authenticationRepository.user.first;

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );

      // await HydratedBlocOverrides.runZoned(
      //   () async {
      configureInjection(Environment.prod);

      await loadAppCore();

      unawaited(core.analytics.logAppOpen());

      await initNotifications();
      final notificationBloc = getIt.get<NotificationBloc>();

      await initFCM();
      await initRevenueCat(user);
      // final _message = await FirebaseMessaging.instance.getInitialMessage();

      // await FirebaseMessaging.instance.getInitialMessage().then((message) {
      //   print('getInitialMessage');
      //   if (message != null) {
      //     print('getInitialMessage: Received ${message.data}');
      //     final notificationData = NotificationData.fromJson(message.data);
      //     final payload = notificationData.payload;

      //     if (payload != null && payload.isNotEmpty) {
      //       processRemoteMessage(notificationData);
      //     }
      //   }
      // });

      return runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('fr', 'FR'),
          ],
          useOnlyLangCode: true,
          path: 'assets/i18n',
          fallbackLocale: const Locale('en', 'US'),
          child: MultiBlocProvider(
            providers: [BlocProvider.value(value: notificationBloc)],
            child: App(
              authenticationRepository: authenticationRepository,
              notificationAppLaunchDetails: notificationAppLaunchDetails!,
            ),
          ),
        ),
      );
      // }
      // blocObserver: AppBlocObserver(),
      // storage: storage,
      // );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
