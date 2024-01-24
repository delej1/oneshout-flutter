// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseAnalyticsService with UiLogger {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setUserProperties({
    String? id,
    String? loginType,
    String? userRole,
  }) async {
    await _analytics.setUserId(id: id);
    await _analytics.setUserProperty(name: 'login_type', value: loginType);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
    logger.d('setUserProperties');
  }

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen(callOptions: AnalyticsCallOptions(global: true));
    logger.d('logAppOpen');
  }

  Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
    logger.d('logSignUp');
  }

  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
    logger.d('logLogin');
  }

  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
    logger.d('logSearch');
  }

  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
    logger.d('logShare');
  }

  Future<void> logEvent({
    required AnalyticsType name,
    Map<String, Object?>? parameters,
  }) async {
    await _analytics.logEvent(
      name: EnumToString.convertToString(name),
      parameters: parameters,
    );
    logger.d('logEvent - $name');
  }
}

// ignore: constant_identifier_names
enum AnalyticsType { select_content }
