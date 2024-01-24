// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/settings/settings.dart';

const String settingsRoute = 'settings';

List<GoRoute> settingsRoutes = [
  GoRoute(
    path: settingsRoute,
    name: 'SettingsPage',
    builder: (context, state) => const SettingsPage(),
  ),
];
