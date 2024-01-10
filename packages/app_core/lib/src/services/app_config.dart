// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/services.dart' as s;
import 'package:injectable/injectable.dart';
import 'package:json_object_lite/json_object_lite.dart';
import 'package:yaml/yaml.dart';

@singleton
class AppConfig extends JsonObjectLite<dynamic> with UiLogger {
  AppConfig(); // empty, default constructor

  factory AppConfig.fromJsonString(String json) =>
      JsonObjectLite<dynamic>.fromJsonString(json, AppConfig()) as AppConfig;

  dynamic config;

  ///Initializes an instance of AppConfig
  @factoryMethod
  static Future<AppConfig> init() async {
    final ac = AppConfig()..config = await AppConfig().loadConfig();
    return ac;
  }

  Future<dynamic> loadConfig() async {
    try {
      final data = await s.rootBundle.loadString('assets/app_config.yaml');
      final yamlData = loadYaml(data) as YamlMap;
      config = AppConfig.fromJsonString(jsonEncode(yamlData));
    } catch (e) {
      logger.e('Could not load settings config file', e);
    }

    return config;
  }

  bool enabled<bool>(String key, [bool? defaultValue]) {
    final args = key.split('.')..add('enabled');

    final callback = buildArgs(args, config);
    final dynamic v = fetch(callback!, bool);

    return v == null ? defaultValue ?? false as bool : v as bool;
  }

  T value<T>(String key, [T? defaultValue]) {
    final args = key.split('.');

    final callback = buildArgs(args, config);
    final dynamic v = fetch(callback!, T);

    return v == null ? defaultValue as T : v as T;
  }

  dynamic fetch(Pick pick, dynamic type) {
    switch (type) {
      case bool:
        return pick.asBoolOrNull();
      case int:
        return pick.asIntOrNull();
    }
    return null;
  }

  Pick? buildArgs(List<String> args, dynamic json) {
    final len = args.length;
    switch (len) {
      case 1:
        return pick(json, args[0]);
      case 2:
        return pick(json, args[0], args[1]);
      case 3:
        return pick(json, args[0], args[1], args[2]);
      case 4:
        return pick(json, args[0], args[1], args[2], args[3]);

      default:
        return null;
    }
  }
}

@injectable
class ConfigKeys {
  String ck_settings_shout = 'settings.shout';
  String ck_settings_shout_tracking = 'settings.shout.tracking';
  String ck_settings_darkMode = 'settings.dark_mode';
  String ck_settings_language = 'settings.account.language';
  String ck_settings_location = 'settings.account.location';
  String ck_settings_privacy = 'settings.terms.privacy';
  String ck_settings_terms = 'settings.terms.terms';
  String ck_settings_security = 'settings.account.security';

//Notifications
  String ck_settings_notification = 'settings.notification';
  String ck_settings_notification_latest_news =
      'settings.notification.latest_news';
  String ck_settings_notification_account_activity =
      'settings.notification.account_activity';
  String ck_settings_notification_newsletter =
      'settings.notification.newsletter';
  String ck_settings_notification_app_updates =
      'settings.notification.app_updates';

//Account
  String ck_settings_account = 'settings.account';
  String ck_settings_account_userProfile = 'settings.account.user_profile';
  String ck_settings_account_info = 'settings.account.account_info';
  String ck_settings_account_password = 'settings.account.change_password';
  String ck_settings_account_update_profile = 'settings.account.update_profile';
  String ck_settings_account_logout = 'settings.account.logout';
  String ck_settings_account_delete_account = 'settings.account.delete_account';

//Feedback
  String ck_settings_feedback = 'settings.feedback';
  String ck_settings_feedback_report_bug = 'settings.feedback.report_bug';
  String ck_settings_feedback_send_feedback = 'settings.feedback.send_feedback';
}
