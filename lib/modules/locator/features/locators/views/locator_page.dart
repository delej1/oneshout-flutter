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
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';
import 'package:oneshout/modules/locator/features/locators/cubit/locator_cubit.dart';
import 'package:oneshout/modules/locator/features/locators/cubit/locator_states.dart';
import 'package:oneshout/modules/locator/locator_routes.dart';

class LocatorPage extends StatelessWidget {
  const LocatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<LocatorCubit>(context)..init(),
        )
      ],
      child: const ContactListView(),
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  late BuildContext ctx;
  PageController pageController = PageController();
  int currPage = 0;

  Widget _menu({
    required String label,
    required Function onTap,
    required bool isActive,
    required IconData icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: isActive ? Colors.red : Colors.red.shade100.withOpacity(0.5),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.black87,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    final cubit = context.read<LocatorCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('locator'.tr()),
        actions: [
          SizedBox(
            width: 36,
            child: IconBtn(
              Icons.refresh,
              onPressed: cubit.init,
            ),
          ),
          HSpace.lg,
        ],
        // toolbarHeight: 40,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Row(
              children: [
                _menu(
                  label: 'My Contacts',
                  onTap: () {
                    if (!pageController.isInitialized) return;

                    pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      currPage = pageController.page!.ceil();
                    });
                  },
                  isActive: currPage == 0,
                  icon: CupertinoIcons.person_2,
                ),
                _menu(
                  label: 'Me',
                  onTap: () {
                    if (!pageController.isInitialized) return;
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      currPage = pageController.page!.ceil();
                    });
                  },
                  isActive: currPage == 1,
                  icon: CupertinoIcons.person,
                )
              ],
            ),
            VSpace.lg,
            Expanded(
              child: ClippedContainer(
                isScaffoldBody: false,
                withPadding: false,
                child: BlocBuilder<LocatorCubit, LocatorState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state.status == LocatorStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.status == LocatorStatus.empty) {
                      return const EmptyStateView();
                    } else if (state.status == LocatorStatus.network) {
                      return AppStateWidget(
                        type: AppState.noConnection,
                        // message: state.fetchCategoriesError,
                        action: () => context.read<LocatorCubit>().init(),
                      );
                    } else if (state.status == LocatorStatus.loaded) {
                      return PageView(
                        controller: pageController,
                        children: [
                          _locateOthers(),
                          _me(),
                        ],
                        onPageChanged: (int num) {
                          setState(() {
                            currPage = num;
                          });
                        },
                      );
                    } else if (state.status == LocatorStatus.failed) {
                      return AppStateWidget(
                        type: AppState.serverError,
                        // message: state.fetchCategoriesError,
                        action: () => context.read<LocatorCubit>().init(),
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
    );
  }

  Widget _me() {
    final cubit = context.read<LocatorCubit>();
    final contacts = cubit.contacts;
    final state = cubit.state;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Column(
            children: [
              // Text(
              //   'Contacts that can view your location.',
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VSpace.md,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.canLocateMe ? 'Locator is on' : 'Locator is off',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      HSpace.lg,
                      SizedBox(
                        height: 24,
                        width: 40,
                        child: BlocBuilder<LocatorCubit, LocatorState>(
                          builder: (context, state) {
                            return Switch.adaptive(
                              value: state.canLocateMe,
                              onChanged: (bool value) {
                                cubit.setCanLocateMe(canLocateMe: value);
                              },
                              inactiveTrackColor:
                                  Theme.of(context).disabledColor,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  VSpace.md,
                  Text(
                    state.canLocateMe
                        ? 'Only enabled contacts can view your location.'
                        : 'No one can view your location.',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        // VSpace.sm,
        VSpace.lg,
        const Divider(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ...contacts.map((e) {
                final index = contacts.indexOf(e);
                final c = contacts[index];
                final canSee = state.isDirty
                    ? state.locatorsMeTemp.contains(c.phone) &&
                        state.canLocateMe
                    : state.locatorsMe.contains(c.phone) && state.canLocateMe;

                final color =
                    canSee ? Colors.grey.shade800 : Colors.grey.shade400;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: ListTile(
                        onTap: () {},
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
                          style: const TextStyle(
                            // color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.phone,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: double.infinity,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    canSee
                                        ? Icons.location_on
                                        : Icons.location_off,
                                    color: canSee ? Colors.red : Colors.grey,
                                  ),
                                  iconSize: 24,
                                  onPressed: () async {
                                    await cubit.updateLocator(
                                      contact: c,
                                      canSee: !canSee,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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

        BlocBuilder<LocatorCubit, LocatorState>(
          builder: (context, state) {
            if (state.isDirty) {
              return Padding(
                padding: EdgeInsets.only(
                  left: Insets.xl,
                  right: Insets.xl,
                  top: Insets.xl,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedBtn(
                        onPressed: () async => cubit.cancelUpdateLocator(),
                        label: 'cancel'.tr(),
                      ),
                    ),
                    HSpace.lg,
                    Expanded(
                      child: PrimaryBtn(
                        onPressed: () async => cubit.saveUpdateLocator(),
                        label: 'save'.tr(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
        VSpace.lg,
      ],
    );
  }

  Widget _locateOthers() {
    final cubit = context.read<LocatorCubit>();
    final contacts = cubit.contacts;
    final state = cubit.state;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: const Text(
            'Contacts that have shared their locations with you.',
            textAlign: TextAlign.center,
          ),
        ),
        VSpace.lg,
        const Divider(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ...contacts.map((e) {
                final index = contacts.indexOf(e);
                final c = contacts[index];

                final locator = state.locators.firstWhere(
                  (l) => l.phone == c.phone,
                  orElse: () => Locator.empty,
                );
                final color = locator != Locator.empty
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).disabledColor;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: ListTile(
                        onTap: () {
                          if (locator != Locator.empty) {
                            context.push(
                              '/$locatorRoute/$locatorFindRoute',
                              extra: {'locator': locator, 'contact': c},
                            );
                          } else {
                            _openMenu(c);
                          }
                        },
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   c.phone,
                            //   style: TextStyle(color: color),
                            // ),
                            // VSpace.xs,
                            if (locator != Locator.empty)
                              Text(
                                'Last seen ${convertToAgo(locator.lastSeen!)}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                ),
                              )
                            else
                              Text(
                                '-',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: double.infinity,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    locator != Locator.empty
                                        ? Icons.location_on
                                        : Icons.location_off,
                                    color: locator == Locator.empty
                                        ? Theme.of(context).disabledColor
                                        : Colors.red,
                                  ),
                                  iconSize: 24,
                                  onPressed: () async {
                                    // final cubit = BlocProvider.of<
                                    //     ContactsCubit>(
                                    //   context,
                                    // );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
  }

  Future<void> _openMenu(MyContact contact) async {
    await MyBottomSheet.to.show<void>(
      context: context,
      title: 'Locator Request',
      centered: true,
      children: [
        Column(
          children: [
            Text(
              '${contact.name} is not sharing their location with you. Click the button below to send a request to view their location.',
              textAlign: TextAlign.center,
            ),
            VSpace.xxl,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: PrimaryBtn(
                onPressed: () async {
                  final done = await context
                      .read<LocatorCubit>()
                      .sendLocatorRequest(contact);
                  if (done) {
                    Navigator.of(context).pop();
                    notify.toast('Your request was sent. successfully');
                  } else {
                    notify.toast(
                      'Your request could not be sent. Please try again later.',
                    );
                  }
                },
                label: 'Send a Request',
              ),
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
            VSpace.lg,
            SizedBox(
              width: double.infinity - 100,
              child: OutlinedButton(
                onPressed: () async {
                  context.go('/$contactsRoute');
                },
                child: Text('goto_contacts'.tr().toUpperCase()),
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
