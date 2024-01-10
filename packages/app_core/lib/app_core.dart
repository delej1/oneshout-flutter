library app_core;

import 'package:app_core/injection.dart';
import 'package:app_core/src/services/services.dart';
import 'package:app_core/src/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

export 'src/errors/errors.dart';
export 'src/models/models.dart';
export 'src/network/index.dart';
export 'src/services/services.dart';
export 'src/utils/utils.dart';
export 'src/widgets/widgets.dart';

/// {@template vs_app_auth}
/// A Flutter App Core Package
/// {@endtemplate}
///

@singleton
class AppCore {
  /// {@macro vs_app_auth}
  AppCore() {
    // init();
  }
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static BuildContext get context => scaffoldMessengerKey.currentState!.context;

  late ThemeServiceImpl themes;
  late FirebaseAnalyticsService analytics;
  late NetworkConnectionBloc network;
  late YamlMap settingsConfig;
  late AppConfig appConfig;
  late SettingsCacheService settings;
  late ConfigKeys keys;

  /// {@macro app_notification_service}
  late AppNotificationService notifications;

  Future<AppCore> init() async {
    await configureDependencies();
    // themes = await getItCore.getAsync<ThemeService>();
    analytics = getItCore.get<FirebaseAnalyticsService>();
    // network = await getItCore.getAsync<NetworkConnectionBloc>();
    settings = getItCore.get<SettingsCacheService>();
    keys = getItCore.get<ConfigKeys>();
    // notifications = getItCore.get<AppNotificationService>();
    // appConfig = await getItCore.getAsync<AppConfig>();
    return this;
  }
}

// @injectable
// class AppCoreInjections {
//   late ThemeService themeService;

//   @factoryMethod
//   static Future<AppCoreInjections> create() async {
//     AppCoreInjections().themeService = await getIt.getAsync<ThemeService>();
//     return AppCoreInjections();
//   }
// }
