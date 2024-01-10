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
import 'package:go_router/go_router.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:oneshout/bootstrap.dart';
import 'package:oneshout/common/widgets/widgets.dart';
// import 'package:go_router_flow/go_router_flow.dart';
import 'package:oneshout/modules/shout/features/view_shouts/cubit/view_shout_cubit.dart';
import 'package:oneshout/modules/shout/features/view_shouts/cubit/view_shout_states.dart';
import 'package:oneshout/modules/shout/shout.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewShoutsPage extends StatelessWidget {
  const ViewShoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ViewShoutCubit(
            shoutRepository: context.read<ShoutRepository>(),
          )..init(),
        ),
      ],
      child: const ViewShoutsView(),
    );
  }
}

class ViewShoutsView extends StatelessWidget {
  const ViewShoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ViewShoutCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('alerts').tr(),
        // toolbarHeight: 40,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ClippedContainer(
                child: BlocBuilder<ViewShoutCubit, ViewShoutState>(
                  builder: (context, state) {
                    if (state.shouts.isEmpty) {
                      if (state.status == ViewShoutStatus.loading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else if (state.status != ViewShoutStatus.loaded) {
                        if (state.status == ViewShoutStatus.failed) {
                          return AppStateWidget(
                            type: AppState.serverError,
                            message: 'An error occured while loading the data!',
                            // message: state.fetchCategoriesError,
                            action: () =>
                                context.read<ViewShoutCubit>()..init(),
                          );
                        }
                        if (state.status == ViewShoutStatus.network) {
                          return AppStateWidget(
                            type: AppState.noConnection,
                            // message: state.fetchCategoriesError,
                            action: () =>
                                context.read<ViewShoutCubit>()..init(),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text(
                            'No Alerts',
                          ),
                        );
                      }
                    }

                    return CupertinoScrollbar(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          final shout = state.shouts[index];
                          return ShoutListTile(
                            shout: shout,
                            onTap: () {
                              // context.go(
                              //   viewAlertRoute,
                              //   extra: shout,
                              // );
                            },
                          );
                        },
                        itemCount: state.shouts.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: Sizes.lg,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoutListTile extends StatelessWidget {
  const ShoutListTile({
    super.key,
    required this.shout,
    required this.onTap,
  });
  final Shout shout;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final latitude = shout.latitude ?? 0.0;
    final longitude = shout.longitude ?? 0.0;
    return Container(
      padding: EdgeInsets.all(Sizes.lg),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shout.senderName != null
                ? '${shout.senderName} (${shout.senderPhone}) ${'needs_help'.tr()}!'
                : '',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          VSpace.md,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (shout.date != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: Sizes.lg,
                      color: Colors.grey,
                    ),
                    HSpace.sm,
                    Text(
                      DateFormat.yMMMEd().format(shout.date!.toLocal()),
                      style: TextStyle(height: 1, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              VSpace.sm,
              if (shout.date != null)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: Sizes.lg,
                      color: Colors.grey.shade500,
                    ),
                    HSpace.sm,
                    Text(
                      DateFormat.jms().format(shout.date!.toLocal()),
                      style: TextStyle(height: 1, color: Colors.grey.shade600),
                    ),
                  ],
                ),
            ],
          ),
          VSpace.lg,
          Row(
            children: [
              Expanded(
                child: PrimaryBtn(
                  icon: Icons.location_on,
                  label: 'location'.tr(),
                  onPressed: longitude == 0.0 || latitude == 0.0
                      ? null
                      : () async {
                          await context.push(
                            '/$shoutsRoute/$shoutTrackerRoute',
                            extra: shout,
                          );
                          // final availableMaps = await MapLauncher.installedMaps;
                          // final title =
                          //     "${shout.senderName}'s ${'location'.tr()}";
                          // const zoom = 300;
                          // if (availableMaps.isNotEmpty) {
                          //   await availableMaps[0].showMarker(
                          //     coords: Coords(latitude, longitude),
                          //     title: title,
                          //     zoom: zoom,
                          //   );
                          // }
                        },
                  isCompact: true,
                ),
              ),
              HSpace.lg,
              Expanded(
                child: OutlinedBtn(
                  icon: Icons.phone,
                  label: 'call'.tr(),
                  onPressed: shout.senderPhone == null
                      ? null
                      : () async {
                          // context.push('/$viewAlertRoute', extra: shout);
                          // await telephony.openDialer(shout.senderPhone!);
                          final launchUri = Uri(
                            scheme: 'tel',
                            path: shout.senderPhone,
                          );
                          await canLaunchUrl(launchUri)
                              .then((bool result) async {
                            if (result) await launchUrl(launchUri);
                          });
                        },
                  isCompact: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        shout.senderName != null
            ? '${shout.senderName} ${'needs_help!'.tr()}'
            : '',
      ).h6(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shout.senderPhone ?? ''),
          Text(DateFormat.yMMMEd().format(shout.date!)),
        ],
      ),
      trailing: Column(
        children: [
          PrimaryBtn(
            icon: Icons.location_on,
            label: 'location'.tr(),
            onPressed: () async {
              // context.push('/$viewAlertRoute', extra: shout);
              final availableMaps = await MapLauncher.installedMaps;
              const latitude = 9.0813657;
              const longitude = 7.4298679;
              final title = "${shout.senderName}'s ${'location'.tr()}";
              const zoom = 300;
              if (availableMaps.isNotEmpty) {
                await availableMaps[0].showMarker(
                  coords: Coords(latitude, longitude),
                  title: title,
                  zoom: zoom,
                );
              }
            },
            isCompact: true,
          ),
          VSpace.lg,
          PrimaryBtn(
            icon: Icons.phone,
            label: 'call'.tr(),
            onPressed: () async {
              // context.push('/$viewAlertRoute', extra: shout);
              await telephony.openDialer(shout.senderPhone!);
            },
            isCompact: true,
          ),
        ],
      ),
    );
  }
}
