// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/home/view/contact_permissions_page.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';
import 'package:oneshout/modules/locator/features/locators/cubit/locator_cubit.dart';

class LocatorMapPage extends StatelessWidget {
  const LocatorMapPage({
    super.key,
    required this.locator,
    required this.contact,
  });

  final Locator locator;
  final MyContact contact;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocatorCubit(
            locatorRepository: context.read<LocatorRepository>(),
          )..init(),
        ),
      ],
      child: ContactListView(
        locator: locator,
        contact: contact,
      ),
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({
    super.key,
    required this.locator,
    required this.contact,
  });
  final Locator locator;
  final MyContact contact;
  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.contact.name}'s Location",
        ),
        // toolbarHeight: 40,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.locator.latitude!,
                    widget.locator.longitude!,
                  ),
                  zoom: 13.5,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('markerId'),
                    position: LatLng(
                      widget.locator.latitude!,
                      widget.locator.longitude!,
                    ),
                    infoWindow: InfoWindow(
                      title: "${widget.contact.name}'s Location",
                      snippet:
                          "Last seen on ${DateFormat('MMM d yyyy, h:mm a').format(widget.locator.lastSeen!)}",
                    ),
                  )
                },
                onMapCreated: _controller.complete,
              ),
            ),
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
                      Text('Latitude: ${widget.locator.latitude}'),
                      HSpace.lg,
                      Text('Longitude: ${widget.locator.longitude}'),
                      const Spacer(),
                    ],
                  ),
                  Text(
                    "Last updated on ${DateFormat('MMM d yyyy, h:mm a').format(widget.locator.lastSeen!.toLocal())}",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _openMenu(Locator locator, MyContact contact) async {
    await MyBottomSheet.to.show<void>(
      context: context,
      children: [
        if (locator != Locator.empty)
          Column(
            children: [
              Text('${contact.name} '),
              PrimaryBtn(
                onPressed: () {},
                label: "View on Map",
              )
            ],
          )
        else
          Column(
            children: [],
          ),
      ],
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Sizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 100, color: Colors.grey.withOpacity(0.5)),
            const Text('no_contacts_yet').tr(),
            const VSpace(80),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final contactPermission = await Permission.contacts.status;
                  if (contactPermission.isGranted) {
                    final contacts = await Navigator.push<List<MyContact>>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddContactsPage()),
                    );
                    if (contacts != null && contacts.isNotEmpty) {
                      final cubit = BlocProvider.of<ContactsCubit>(context);
                      await cubit.saveContacts(contacts);
                      await cubit.getContacts();
                    }
                  } else {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContactPermissionsPage(),
                      ),
                    );
                  }
                },
                child: Text('import_contact'.tr().toUpperCase()),
              ),
            ),
            VSpace.lg,
            const Text('or').tr(),
            VSpace.lg,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final contact = await Navigator.push<MyContact>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsertContactPage(),
                    ),
                  );
                  if (contact != null) {
                    final cubit = BlocProvider.of<ContactsCubit>(context);
                    await cubit.saveContacts([contact]);
                    await cubit.getContacts();
                  }
                },
                child: Text('add_a_contact'.tr().toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(fontSize: FontSizes.s12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class HomeText extends StatelessWidget {
  const HomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((ContactsCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.headline1);
  }
}
