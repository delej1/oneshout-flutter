// ignore_for_file: cascade_invocations, lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LoggerPrettyPrinter {
  SimpleLogPrinter({this.tag = ''}) {
    LoggerPrettyPrinter.tag = tag;
  }
  final String tag;
}

class CrashlyticsPrinter extends LogPrinter {
  CrashlyticsPrinter({this.tag = ''});

  final String tag;
  @override
  List<String> log(LogEvent event) {
    final msg = '$tag - ${event.message}';
    FirebaseCrashlytics.instance.recordError(
      event.error,
      event.stackTrace,
      reason: msg,
    );
    return [];
  }
}

mixin NetworkLogger {
  Logger get logger => Logger(
        printer: kReleaseMode ? CrashlyticsPrinter(tag: 'Network | ${runtimeType.toString()}') : SimpleLogPrinter(tag: 'Network | ${runtimeType.toString()}'),
      );
}

mixin UiLogger {
  Logger get logger => Logger(
        printer: kReleaseMode ? CrashlyticsPrinter(tag: 'App | ${runtimeType.toString()}') : SimpleLogPrinter(tag: 'App | ${runtimeType.toString()}'),
      );
}

class LoggerController with UiLogger {
  LoggerController();

  // static LoggerController get to => getIt<LoggerController>();

  void log(String message) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.log(message);
    }
  }

  void check() {
    logger.v("You don't always want to see all of these");
    logger.d('Logs a debug message');
    logger.i('Public Function called');
    logger.w('This might become a problem');
    logger.e('Something has happened');
    logger.wtf('What a terrible failure log');
  }
}
