// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as pnp;

class ContactsCubit extends Cubit<ContactsState> with UiLogger {
  ContactsCubit({required AuthenticationRepository authenticationRepository})
      : _authRepository = authenticationRepository,
        super(InitialState()) {
    getContacts();
  }

  final AuthenticationRepository _authRepository;
  Future<void> getContacts() async {
    try {
      emit(LoadingState());
      final contacts = await loadContacts();

      if (contacts.isEmpty) {
        emit(EmptyState());
      } else {
        emit(LoadedState(contacts));
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<List<MyContact>> loadContacts({bool enabled = false}) async {
    try {
      final box = GetStorage();
      final contactsjson = box.read<List<dynamic>>('contacts');

      if (contactsjson == null) {
        return <MyContact>[];
      } else {
        final contacts = List<Map>.from(contactsjson)
            .map(
              (jsonMap) =>
                  MyContact.fromJson(Map<String, dynamic>.from(jsonMap)),
            )
            .toList();

        return enabled ? contacts.where((c) => c.enabled).toList() : contacts;
      }
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  Future<void> saveContacts(List<MyContact> contacts) async {
    try {
      final box = GetStorage();
      final existing = await loadContacts();

      contacts.map((e) async {
        final exists = existing.indexWhere((f) => f.phone == e.phone);
        if (exists == -1) {
          final ph = e.phone.replaceAll('-', '').replaceAll(' ', '');

          final user = _authRepository.currentUser;
          final country = user.country!;

          final fm = pnp.PhoneNumber.parse(
            ph,
            callerCountry: pnp.IsoCode.values.byName(country),
          );

          final fmf = formatNumberSync(fm.international);

          e
            ..phone = fm.international
            ..phoneFormatted = fmf;

          existing.add(e);
        }
      }).toList();

      final json = existing.map((e) => e.toJson()).toList();

      await box.write('contacts', json);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> updateContact(MyContact contact, [int? index]) async {
    if (contact.phoneFormatted.isEmpty) {
      final user = _authRepository.currentUser;
      final country = user.country!;

      final fm = pnp.PhoneNumber.parse(
        contact.phone,
        callerCountry: pnp.IsoCode.values.byName(country),
      );

      final fmf = formatNumberSync(fm.international);
      contact.phoneFormatted = fmf;
    }

    try {
      final box = GetStorage();
      final existing = await loadContacts();

      existing
        ..removeAt(index!)
        ..insert(index, contact);

      final json = existing.map((e) => e.toJson()).toList();

      await box.write('contacts', json);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> deleteContact(MyContact contact) async {
    try {
      final box = GetStorage();
      final existing = await loadContacts();
      existing.removeWhere((f) => f.phone == contact.phone);
      final json = existing.map((e) => e.toJson()).toList();
      await box.write('contacts', json);

      if (existing.isNotEmpty) {
        emit(LoadedState(existing));
      } else {
        emit(EmptyState());
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> toggleEnabled({
    required MyContact contact,
    required bool value,
  }) async {
    try {
      final box = GetStorage();
      final existing = await loadContacts();
      final index = existing.indexWhere((f) => f.phone == contact.phone);

      final c = contact.copyWith(enabled: value);
      existing
        ..removeAt(index)
        ..insert(index, c);
      final json = existing.map((e) => e.toJson()).toList();
      await box.write('contacts', json);

      emit(LoadedState(existing));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // void increment() => emit(state + 1);
  // void decrement() => emit(state - 1);
}
