import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

///Responsive UI
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  @override
  Widget build(BuildContext context) {
    // print(DeviceScreen.get(context));
    // print(MediaQuery.of(context).size.shortestSide);
    if (DeviceScreen.isPhone(context)) {
      return mobile;
    } else if (DeviceScreen.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return desktop ?? mobile;
    }
  }
}
