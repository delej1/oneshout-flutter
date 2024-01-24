// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/modules/contacts/contacts_api.dart';
import 'package:oneshout/modules/contacts/cubit/contacts_states.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/features/locators/cubit/locator_states.dart';
import 'package:oneshout/modules/locator/locator_api.dart';

class LocatorCubit extends Cubit<LocatorState> with NetworkLogger {
  LocatorCubit({
    required LocatorRepository locatorRepository,
  })  : _locatorRepository = locatorRepository,
        super(const LocatorState());

  final LocatorRepository _locatorRepository;
  List<MyContact> contacts = [];
  List<String> contactPhones = [];
  List<String> locatorsOld = [];
  Timer? refreshTimer;
  Timer? locationUpdateTimer;

  Future<void> init() async {
    logger.d('Initializing LocatorCubit');

    emit(state.copyWith(status: LocatorStatus.loading));

    getMyLocators();

    contacts = await ContactsApi().getContactsFromStorage();
    final contactPhones = getContactsPhoneNumbers();

    if (contacts.isEmpty) {
      emit(state.copyWith(status: LocatorStatus.empty));
      return;
    }

    final data = await _locatorRepository.fetchLocator(contacts: contactPhones);

    data.fold((l) {
      emit(
        state.copyWith(
          status: l is NetworkFailure
              ? LocatorStatus.network
              : LocatorStatus.failed,
          locators: [],
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: LocatorStatus.loaded,
          locators: r,
        ),
      );
    });

    refreshTimer =
        Timer.periodic(const Duration(seconds: 60), (_) => refreshData());
  }

  Future<void> startLocationUpdate() async {
    //check if we want to share location.
    final box = GetStorage();
    final canLocateMe = box.read<bool>('_can_locator_me') ?? false;
    final shownLocationRequest =
        box.read<bool>('shown_location_request') ?? false;

    final permission = await Geolocator.checkPermission();

    if (!shownLocationRequest ||
        (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse)) return;

    final location = await MyLocatorApi().getLocation();

    if (canLocateMe) {
      await _locatorRepository.updateMyLocation(
        lat: location!.latitude,
        lng: location.longitude,
      );
    }
  }

  List<String> getContactsPhoneNumbers() {
    return contactPhones.isEmpty
        ? contacts.map((c) => c.phone).toList()
        : contactPhones;
  }

  Future<void> refreshData() async {
    final phones = getContactsPhoneNumbers();
    final data = await _locatorRepository.fetchLocator(contacts: phones);

    data.fold((l) {}, (r) {
      emit(
        state.copyWith(
          locators: r,
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    refreshTimer?.cancel();
    locationUpdateTimer?.cancel();
    await super.close();
  }

  void getMyLocators() {
    final box = GetStorage();
    final json = box.read<String>('_locator_me') ?? jsonEncode([]);
    final lists =
        (jsonDecode(json) as List<dynamic>).map((e) => e.toString()).toList();
    final canLocateMe = box.read<bool>('_can_locator_me') ?? false;

    emit(
      state.copyWith(
        locatorsMe: lists,
        locatorsMeTemp: lists,
        canLocateMe: canLocateMe,
      ),
    );
  }

  Future<void> setCanLocateMe({required bool canLocateMe}) async {
    notify.loading();

    final location = await MyLocatorApi().getLocation();

    final res = await _locatorRepository.setCanLocateMe(
      canLocateMe: canLocateMe,
      viewers: state.locatorsMe,
      lat: location?.latitude ?? 0,
      lng: location?.longitude ?? 0,
    );

    await res.fold(
      (l) {
        notify
          ..closeLoading()
          ..toast(
            'Your locator could not be updated. Please try again.',
            type: NT.error,
          );
      },
      (r) async {
        final box = GetStorage();
        await box.write('_can_locator_me', canLocateMe);
        emit(state.copyWith(canLocateMe: canLocateMe));
        notify
          ..closeLoading()
          ..toast('Your locator has been updated.', type: NT.success);
      },
    );

    notify.closeLoading();
  }

  Future<void> updateLocator({
    required MyContact contact,
    required bool canSee,
  }) async {
    final seeMe = [...state.locatorsMeTemp];
    final index = seeMe.indexWhere((e) => e == contact.phone);
    if (canSee) {
      if (!seeMe.contains(contact.phone)) {
        seeMe.add(contact.phone);
      }
    } else {
      seeMe.removeAt(index);
    }

    emit(state.copyWith(isDirty: true, locatorsMeTemp: seeMe));

    return;
  }

  Future<void> saveUpdateLocator({bool background = false}) async {
    final seeMe = [...state.locatorsMeTemp];
    if (!background) notify.loading();

    final location = await MyLocatorApi().getLocation();

    final res = await _locatorRepository.setCanLocateMe(
      canLocateMe: state.canLocateMe,
      viewers: seeMe,
      lat: location?.latitude ?? 0,
      lng: location?.longitude ?? 0,
    );

    await res.fold(
      (l) {
        notify
          ..closeLoading()
          ..toast(
            'Your locator could not be updated. Please try again.',
            type: NT.error,
          );
      },
      (r) async {
        final box = GetStorage();
        await box.write('_locator_me', jsonEncode(seeMe));
        emit(
          state.copyWith(
            locatorsMe: seeMe,
            isDirty: false,
          ),
        );
        if (!background) {
          notify
            ..closeLoading()
            ..toast('Your locator has been updated.', type: NT.success);
        }
      },
    );
  }

  Future<void> cancelUpdateLocator() async {
    final seeMe = [...state.locatorsMe];

    emit(
      state.copyWith(
        locatorsMeTemp: seeMe,
        isDirty: false,
      ),
    );
  }

  Future<bool> sendLocatorRequest(MyContact contact) async {
    notify.loading();
    final data = await _locatorRepository.requestLocator(phone: contact.phone);

    return data.fold((l) {
      notify.closeLoading();
      return false;
    }, (r) {
      notify.closeLoading();
      return r;
    });
  }

  Future<bool> grantLocatorRequest({
    required String phone,
  }) async {
    getMyLocators();

    final seeMe = [...state.locatorsMe];

    if (!seeMe.contains(phone)) {
      seeMe.add(phone);
    }

    emit(state.copyWith(locatorsMe: seeMe, locatorsMeTemp: seeMe));

    unawaited(saveUpdateLocator(background: true));
    final done = await respondToLocatorRequest(accept: true, phone: phone);

    return done;
  }

  Future<bool> respondToLocatorRequest({
    required String phone,
    required bool accept,
  }) async {
    notify.loading();
    final res = await _locatorRepository.respondToLocatorRequest(
      phone: phone,
      accept: accept,
    );

    return await res.fold(
      (l) {
        notify
          ..closeLoading()
          ..toast(
            'Your response could not be sent. Please try again.',
            type: NT.error,
          );
        return false;
      },
      (r) async {
        notify
          ..closeLoading()
          ..toast('Your response has been sent.', type: NT.success);
        return true;
      },
    );
  }
}
