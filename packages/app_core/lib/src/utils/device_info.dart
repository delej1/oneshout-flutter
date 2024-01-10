// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

enum FormFactorType { monitor, smallPhone, largePhone, tablet }

class DeviceOS {
  // Syntax sugar, proxy the UniversalPlatform methods so our views can reference a single class
  static bool isIOS = UniversalPlatform.isIOS;
  static bool isAndroid = UniversalPlatform.isAndroid;
  static bool isMacOS = UniversalPlatform.isMacOS;
  static bool isLinux = UniversalPlatform.isLinux;
  static bool isWindows = UniversalPlatform.isWindows;

  // Higher level device class abstractions (more syntax sugar for the views)
  static bool isWeb = kIsWeb;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktopOrWeb => isDesktop || isWeb;
  static bool get isMobileOrWeb => isMobile || isWeb;
}

class DeviceScreen {
  // Get the device form factor as best we can.
  // Otherwise we will use the screen size to determine which class we fall into.
  static FormFactorType get(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.width;
    if (shortestSide <= 350) return FormFactorType.smallPhone;
    if (shortestSide <= 600) return FormFactorType.largePhone;
    if (shortestSide <= 800) return FormFactorType.tablet;
    return FormFactorType.monitor;
  }

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // Shortcuts for various mobile device types
  static bool isPhone(BuildContext context) =>
      isSmallPhone(context) || isLargePhone(context);
  static bool isTablet(BuildContext context) =>
      get(context) == FormFactorType.tablet;
  static bool isMonitor(BuildContext context) =>
      get(context) == FormFactorType.monitor;
  static bool isSmallPhone(BuildContext context) =>
      get(context) == FormFactorType.smallPhone;
  static bool isLargePhone(BuildContext context) =>
      get(context) == FormFactorType.largePhone;
}
