// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/shout/features/shout_tracker/views/shout_tracker_page.dart';
import 'package:oneshout/modules/shout/features/view_shouts/views/view_shouts_page.dart';
import 'package:oneshout/modules/shout/shout.dart';

const String shoutRoute = 'shout';
const String shoutsRoute = 'shouts';
const String shoutTrackerRoute = 'shout_tracker';

List<GoRoute> shoutRoutes = [
  GoRoute(
    path: shoutRoute,
    name: 'ShoutPage',
    builder: (context, state) => const ShoutPage(),
  ),
  GoRoute(
    path: shoutsRoute,
    name: 'ViewShoutPage',
    builder: (context, state) => const ViewShoutsPage(),
    routes: [
      GoRoute(
        path: shoutTrackerRoute,
        name: 'ShoutTrackerPage',
        builder: (context, state) =>
            ShoutTrackerPage(shout: state.extra! as Shout),
      ),
    ],
  ),
];
