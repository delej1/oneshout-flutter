// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:contacts_service/contacts_service.dart' as cs;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/contacts/contacts_api.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as pnp;

class AddContactsPage extends StatefulWidget with UiLogger {
  AddContactsPage({super.key, this.myContacts = const []});
  List<MyContact> myContacts;
  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  List<MyContact>? _contacts;
  List<MyContact>? _existing;
  bool _permissionDenied = false;
  bool loadingContacts = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _contacts = widget.myContacts;
      _existing = widget.myContacts;
    });
    _fetchContacts();
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  bool isNotAdded(String phone) {
    final result =
        widget.myContacts.indexWhere((element) => element.phone == phone);
    return result == -1;
  }

  Future<void> _fetchContacts() async {
    final user = context.read<AuthenticationRepository>().currentUser;
    final country = user.country!;

    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      // var contacts = await FlutterContacts.getContacts(
      //   withAccounts: true,
      //   withProperties: true,
      // );
      setState(() {
        loadingContacts = true;
      });
      var contacts =
          (await cs.ContactsService.getContacts(withThumbnails: false))
              .toList();

      // var contactsx = await FlutterContacts.openExternalPick();
      // return;
      //filter contacts that have phone numbers.
      contacts = contacts
          .where(
            (c) => c.phones!.isNotEmpty,
          )
          .toList();
      // convert to MyContact.
      var contactx = contacts.map(
        (c) {
          // final fm = pnp.PhoneNumber.parse(
          //   c.phones!.first.value.toString(),
          //   callerCountry: pnp.IsoCode.values.byName(country),
          // );

          // final fmf =
          //     FlutterLibphonenumber().formatNumberSync(fm.international);
          return MyContact(
            name: c.displayName ?? '-',
            // phone: c.phones!.first.number,
            phone: c.phones!.first.value.toString(),
            phoneFormatted: '',
            initials: getInitials(c.displayName ?? '-'),
            enabled: true,
          );
        },
      ).toList();
      //merge with old.

      // addAll(widget.myContacts ?? []);
      setState(() => _contacts = contactx);
      setState(() {
        loadingContacts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactsCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: PhoneContactsView(
        permissionDenied: _permissionDenied,
        contacts: _contacts,
        existingContacts: widget.myContacts,
        loading: loadingContacts,
      ),
    );
  }
}

class PhoneContactsView extends StatefulWidget {
  PhoneContactsView({
    super.key,
    required this.permissionDenied,
    required this.contacts,
    required this.existingContacts,
    required this.loading,
  });

  final bool permissionDenied;
  final List<MyContact>? contacts;
  final List<MyContact>? existingContacts;
  final bool loading;
  final searchTextController = TextEditingController();
  List<MyContact> filtered = [];

  @override
  State<PhoneContactsView> createState() => _PhoneContactsViewState();
}

class _PhoneContactsViewState extends State<PhoneContactsView> {
  final List<MyContact> selectedContacts = [];

  @override
  void initState() {
    // selectedContacts.addAll(widget.existingContacts ?? []);
    start();
    super.initState();
  }

  void start() {
    setState(() {
      widget.filtered.addAll(widget.contacts!);
    });
  }

  void filter() {
    widget.filtered = widget.contacts!.where((item) {
      return item.name
              .toLowerCase()
              .contains(widget.searchTextController.value.text.toLowerCase()) ||
          item.phone
              .contains(widget.searchTextController.value.text.toLowerCase());
    }).toList();

    setState(() {
      widget.filtered = widget.filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    start();
    final styleActive =
        TextStyle(color: Theme.of(context).colorScheme.onSurface, height: 1.2);
    final styleHint =
        TextStyle(color: Theme.of(context).disabledColor, height: 1.2);
    final style = widget.searchTextController.value.text.isEmpty
        ? styleHint
        : styleActive;
    return Scaffold(
      appBar: AppBar(
        title: Text('select_contacts'.tr()),
        // toolbarHeight: 40,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        child: (widget.filtered == null || widget.loading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.permissionDenied)
                    const Center(child: Text('Permission denied')),

                  if (widget.contacts!.isEmpty && !widget.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 38),
                      child: Center(
                        child: Text('There are no contacts to add.'),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          const Divider(),
                          if (!widget.loading)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: widget.searchTextController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search, color: style.color),
                                  suffixIcon: widget.searchTextController.value
                                          .text.isNotEmpty
                                      ? GestureDetector(
                                          child: Icon(Icons.close,
                                              color: style.color),
                                          onTap: () {
                                            widget.searchTextController.text =
                                                '';
                                            filter();
                                            // FocusScope.of(Get.context!).requestFocus(FocusNode());
                                          },
                                        )
                                      : null,
                                  hintText: 'Search ',
                                  hintStyle: style,
                                  border: InputBorder.none,
                                ),
                                style: style,
                                onChanged: (text) {
                                  filter();
                                },
                              ),
                            ),
                          const Divider(),
                          VSpace.md,
                          if (!widget.loading)
                            Expanded(
                              child: ListView.separated(
                                itemCount: widget.filtered.length,
                                itemBuilder: (context, i) {
                                  final contact = widget.filtered[i];
                                  final isSelected =
                                      selectedContacts.indexWhere(
                                            (c) => c.phone == contact.phone,
                                          ) !=
                                          -1;

                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Insets.lg),
                                    leading: CircleAvatar(
                                      child: Text(contact.initials),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Text(contact.name)),
                                      ],
                                    ),
                                    trailing: isSelected
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Icon(Icons.check),
                                          )
                                        : null,
                                    subtitle: Text(contact.phone),
                                    onTap: () async {
                                      contactSelected(contact);
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  // const Spacer(),
                  VSpace.lg,
                  PrimaryBtn(
                    onPressed:
                        selectedContacts.isEmpty || widget.contacts!.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context, selectedContacts);
                              },
                    child: Text(getBtnText()),
                  ),
                  VSpace.lg,
                ],
              ),
      ),
    );
  }

  String getBtnText() {
    final count =
        selectedContacts.length > 1 ? 'other' : '=${selectedContacts.length}';

    return 'add_contact.plural:count.$count'
        .tr(namedArgs: {'count': selectedContacts.length.toString()});
  }

  void contactSelected(MyContact contact) {
    final list = widget.existingContacts?.map((e) => e.phone).toList() ?? [];
    final user = context.read<AuthenticationRepository>().currentUser;
    final country = user.country!;
    final fm = pnp.PhoneNumber.parse(
      contact.phone,
      callerCountry: pnp.IsoCode.values.byName(country),
    );

    final exists = list.contains(fm.international);
    // selectedContacts.indexWhere(
    //   (e) => e.phone == fm.international,
    // );

    if (!exists) {
      //insert.
      setState(() => selectedContacts.add(contact));
    } else {
      //remove.
      setState(() {
        selectedContacts.removeWhere((e) => e.phone == contact.phone);
      });
    }
  }
}
