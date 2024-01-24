// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/contacts/contacts.dart';

const String contactsRoute = 'contacts';
const String addContactsRoute = 'addContactsRoute';

List<GoRoute> contactsRoutes = [
  GoRoute(
    path: contactsRoute,
    name: 'contactListPage',
    builder: (context, state) => const ContactListPage(),
  ),
  GoRoute(
    path: addContactsRoute,
    name: 'addContactsPage',
    builder: (context, state) => AddContactsPage(),
  ),
];
