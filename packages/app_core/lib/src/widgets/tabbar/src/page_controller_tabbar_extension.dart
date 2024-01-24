import 'package:flutter/widgets.dart';

extension TabbarPageControllerExtension on PageController {
  // ignore: recursive_getters
  double get page => positions.isEmpty ? 0 : page;

  bool get isInitialized => positions.isNotEmpty;
  bool get isNotInitialized => positions.isEmpty;
}
