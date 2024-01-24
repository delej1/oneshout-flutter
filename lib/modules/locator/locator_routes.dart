// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/contacts/cubit/contacts_states.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';
import 'package:oneshout/modules/locator/features/locators/views/locator_map.dart';
import 'package:oneshout/modules/locator/features/locators/views/locator_page.dart';
import 'package:oneshout/modules/locator/features/locators/views/locator_request_page.dart';

const String locatorRoute = 'locator';
const String locatorsRoute = 'locators';
const String locatorFindRoute = 'find';
const String locatorRequestRoute = 'locator_request';

List<GoRoute> locatorRoutes = [
  GoRoute(
    path: locatorRoute,
    name: 'LocatorPage',
    builder: (context, state) => const LocatorPage(),
    routes: [
      GoRoute(
        path: locatorFindRoute,
        name: 'LocateMe',
        builder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          return LocatorMapPage(
            contact: data['contact'] as MyContact,
            locator: data['locator'] as Locator,
          );
        },
      ),
    ],
  ),
  GoRoute(
    path: locatorRequestRoute,
    name: 'LocatorRequestPage',
    builder: (context, state) {
      final data = state.extra! as Map<String, dynamic>;
      return LocatorRequestPage(
        phone: data['phone'].toString(),
        name: data['name'].toString(),
      );
    },
  ),
];
