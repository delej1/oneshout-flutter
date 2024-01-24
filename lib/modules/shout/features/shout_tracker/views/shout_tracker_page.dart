// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneshout/modules/shout/features/shout_tracker/cubit/shout_tracker_cubit.dart';
import 'package:oneshout/modules/shout/features/shout_tracker/cubit/shout_tracker_states.dart';
// import 'package:go_router_flow/go_router_flow.dart';
import 'package:oneshout/modules/shout/shout.dart';

class ShoutTrackerPage extends StatefulWidget {
  const ShoutTrackerPage({super.key, required this.shout});
  final Shout shout;

  @override
  State<ShoutTrackerPage> createState() => _ShoutTrackerPageState();
}

class _ShoutTrackerPageState extends State<ShoutTrackerPage> {
  late BitmapDescriptor startIcon;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoutTrackerCubit()..init(widget.shout),
      child: const ShoutTrackerView(),
    );
  }
}

class ShoutTrackerView extends StatefulWidget {
  const ShoutTrackerView({super.key});

  @override
  State<ShoutTrackerView> createState() => _ShoutTrackerViewState();
}

class _ShoutTrackerViewState extends State<ShoutTrackerView> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoutTrackerCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker').tr(),
        actions: [
          // IconButton(
          //     onPressed: () => cubit.init(cubit.state.shout),
          //     icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocBuilder<ShoutTrackerCubit, ShoutTrackerState>(
        buildWhen: (previous, current) => previous.markers != current.markers,
        builder: (context, state) {
          final cubit = context.read<ShoutTrackerCubit>();
          return SafeArea(
            child: (state.currentLocation == const LatLng(0, 0))
                ? const Center(child: Text('Waiting for location data...'))
                : Column(
                    children: [
                      Text(
                        '${cubit.state.shout.senderName} ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${cubit.state.shout.senderPhone}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      VSpace.lg,
                      if (state.markers.isEmpty)
                        const CircularProgressIndicator()
                      else
                        Expanded(
                          child: BlocListener<ShoutTrackerCubit,
                              ShoutTrackerState>(
                            listenWhen: (previous, current) =>
                                previous != current,
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: state.route.last,
                                zoom: 13.5,
                              ),
                              markers: Set.from(state.markers),
                              onMapCreated: cubit.controller.complete,
                              polylines: Set.from(state.polylines),
                            ),
                          ),
                        ),
                      VSpace.md,
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Last known location:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                Text(
                                    'Latitude: ${state.route.last.latitude.toStringAsFixed(5)}'),
                                HSpace.lg,
                                Text(
                                  'Longitude: ${state.route.last.longitude.toStringAsFixed(5)}',
                                ),
                                const Spacer(),
                              ],
                            ),
                            Text(
                              "Last updated on ${DateFormat('MMM d yyyy, h:mm a').format(cubit.state.shout.locations.last.timestamp.toLocal())}",
                            )
                          ],
                        ),
                      ),
                      VSpace.md,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
