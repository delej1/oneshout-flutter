// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/contacts/contacts_api.dart';
import 'package:oneshout/modules/home/view/contact_permissions_page.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactsCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const ContactListView(),
    );
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({super.key});

  Future<void> importContacts(BuildContext context) async {
    final contactPermission = await Permission.contacts.status;
    if (contactPermission.isGranted) {
      final cubit = context.read<ContactsCubit>();

      final c = await cubit.loadContacts();
      final contacts = await Navigator.of(context).push<List<MyContact>>(
        MaterialPageRoute(
          builder: (context) => AddContactsPage(myContacts: c),
        ),
      );

      if (contacts != null && contacts.isNotEmpty) {
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
  }

  Future<void> addContact(BuildContext context) async {
    await context.read<ContactsCubit>().loadContacts();

    final contact = await Navigator.of(context).push<MyContact>(
      MaterialPageRoute(
        builder: (context) => InsertContactPage(),
      ),
    );

    if (contact != null) {
      final cubit = BlocProvider.of<ContactsCubit>(context);
      await cubit.saveContacts([contact]);
      await cubit.getContacts();
    }
  }

  Future<void> editContact(
    MyContact contact,
    BuildContext context,
    int index,
  ) async {
    final c = await Navigator.of(context).push<MyContact>(
      MaterialPageRoute(
        builder: (context) => InsertContactPage(contact: contact),
      ),
    );

    if (c != null) {
      final cubit = BlocProvider.of<ContactsCubit>(context);
      await cubit.updateContact(c, index);
      await cubit.getContacts();
    }
  }

  void setScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    setScreen();
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('your_contact_list'.tr()),
          // toolbarHeight: 40,
        ),
        // backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await ContactsApi.showContactTypeChooser(
              context: context,
              callback: (int int) async {
                if (int == 0) {
                  await importContacts(context);
                  return;
                }
                if (int == 1) {
                  await addContact(context);
                }
              },
            );
          },
          child: const Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ClippedContainer(
                  isScaffoldBody: false,
                  withPadding: false,
                  child: BlocBuilder<ContactsCubit, ContactsState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is EmptyState) {
                        return const EmptyStateView();
                      } else if (state is LoadedState) {
                        final contacts = state.contacts;
                        final count = contacts.length > 1
                            ? 'other'
                            : '=${contacts.length}';
                        final msg = 'you_have_contact.plural:count.$count'.tr(
                            namedArgs: {'count': contacts.length.toString()});

                        final enabledC =
                            contacts.where((c) => c.enabled == true).length;
                        var warning = '';
                        if (enabledC == 0) {
                          warning =
                              'You have disabled all your contacts and no one will be alerted when you need help!';
                        }

                        return Column(
                          children: [
                            const Divider(
                              height: 15,
                            ),
                            if (msg.isNotEmpty) Text(msg),
                            if (warning.isNotEmpty) VSpace.md,
                            if (warning.isNotEmpty)
                              Text(
                                warning,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (warning.isNotEmpty) VSpace.md,
                            const Divider(
                              height: 15,
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ...contacts.map((e) {
                                    final index = contacts.indexOf(e);
                                    final c = contacts[index];
                                    final color = c.enabled
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Theme.of(context).disabledColor;

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.only(
                                            left: Insets.md,
                                          ),
                                          leading: CircleAvatar(
                                            // backgroundColor:
                                            //     Theme.of(context).colorScheme.secondary,
                                            child: Text(c.initials),
                                          ),
                                          title: Text(
                                            c.name,
                                            style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c.phoneFormatted,
                                                style: TextStyle(color: color),
                                              ),
                                              VSpace.xs,
                                              if (!c.phone.startsWith('+'))
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons
                                                          .exclamationmark_triangle,
                                                      color: Colors.amber,
                                                      size: 14,
                                                    ),
                                                    HSpace.sm,
                                                    Flexible(
                                                      child: Text(
                                                        'Phone number must start with +. Tap to edit.',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors
                                                              .red.shade600,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              VSpace.xs,
                                            ],
                                          ),
                                          onTap: () async {
                                            // contactSelected(contact);
                                            await editContact(
                                                c, context, index);
                                          },
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 24,
                                                child: Switch(
                                                  value: c.enabled,
                                                  onChanged: (val) async {
                                                    final cubit = BlocProvider
                                                        .of<ContactsCubit>(
                                                      context,
                                                    );
                                                    await cubit.toggleEnabled(
                                                      contact: c,
                                                      value: val,
                                                    );
                                                  },
                                                ),
                                              ),
                                              HSpace.sm,
                                              SizedBox(
                                                width: 48,
                                                height: double.infinity,
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    iconSize: 24,
                                                    onPressed: () async {
                                                      // final cubit = BlocProvider.of<
                                                      //     ContactsCubit>(
                                                      //   context,
                                                      // );
                                                      await showDeleteConfirmation(
                                                        c,
                                                        context,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index < contacts.length - 1)
                                          const Divider(
                                            height: 10,
                                          )
                                        else
                                          Container(height: 60)
                                      ],
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Nothing to show!');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmation(
    MyContact contact,
    BuildContext context,
  ) async {
    await MyBottomSheet.to.show<void>(
      context: context,
      title: 'Delete Confirmation',
      centered: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete ${contact.name} from your contacts?',
              textAlign: TextAlign.center,
            ),
            VSpace.lg,
            Row(
              children: [
                Expanded(
                  child: OutlinedBtn(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: 'No',
                  ),
                ),
                HSpace.lg,
                Expanded(
                  child: PrimaryBtn(
                    onPressed: () async {
                      final cubit = context.read<ContactsCubit>();
                      await cubit.deleteContact(contact);
                      Navigator.of(context).pop();
                    },
                    label: 'Yes, delete',
                  ),
                ),
              ],
            )
          ],
        )
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
