import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ContactsApi with UiLogger {
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return '';
    }
    final fm = PhoneNumber.parse(phoneNumber);
    if (fm.isValid()) {
      return fm.getFormattedNsn();
    } else {
      return '';
    }
  }

  static Future<void> showContactTypeChooser({
    required BuildContext context,
    required Function(int) callback,
  }) async {
    final list = ['Import from Contacts', 'Manually add a Contact'];

    final children = list
        .map<Widget>(
          (text) => ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  list.indexOf(text) == 0
                      ? Icons.import_contacts
                      : Icons.contact_phone,
                ),
                HSpace.lg,
                Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onTap: () {
              callback(list.indexOf(text));
              Navigator.of(context).pop();
            },
          ),
        )
        .toList();

    await MyBottomSheet.to.show<void>(
      context: context,
      children: children,
    );
    // return [];
  }

  static Future<void> showAddContactForm({
    required BuildContext context,
    required Function(MyContact) callback,
  }) async {
    final children = [InsertContactPage()];

    final mc = await MyBottomSheet.to.show<MyContact>(
      context: context,
      children: children,
    );
    // callback(mc);
    // return [];
  }

  Future<List<MyContact>> getContactsFromStorage() async {
    try {
      final box = GetStorage();
      final contactsjson = box.read<List<dynamic>>('contacts');

      if (contactsjson == null) {
        return <MyContact>[];
      } else {
        final contacts = List<Map<dynamic, dynamic>>.from(contactsjson)
            .map(
              (jsonMap) =>
                  MyContact.fromJson(Map<String, dynamic>.from(jsonMap)),
            )
            .toList();

        return contacts;
      }
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }
}
