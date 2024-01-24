// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/iap/paywall.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const String iapRoute = 'iap';

List<GoRoute> iapRoutes = [
  GoRoute(
    path: iapRoute,
    name: 'PaywallPage',
    builder: (context, state) => Paywall(
        // offering: state.extra! as Offering,
        ),
  ),
];
