// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:oneshout/modules/home/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeState> with NetworkLogger, UiLogger {
  HomeCubit() : super(RequireUserState()) {
    init();
  }

  final box = GetStorage();

  Future<void> init() async {
    logger.i('Starting initialization...');

    //check if permissions have been granted.
    await checkPermissions();
    // checkUser();
    //1. SEND_SMS, VIEW_SMS, RECEIVE_SMS
    //2. LOCATION
    //3. Contacts
  }

  Future<void> acceptPolicy() async {
    final box = GetStorage();
    await box.write('policy', true);
    await checkPermissions();
  }

  Future<void> checkPermissions() async {
    emit(ReadyState());

    // final smsPermission = await ph.Permission.sms.status;
    final locationPermission = await ph.Permission.location.status;
    final box = GetStorage();
    final policy = box.read<bool>('policy');
    final shownLocationRequest =
        box.read<bool>('shown_location_request') ?? false;

    if (policy == null || policy == false) {
      emit(AcceptPolicyState());
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (locationPermission.isGranted) {
        emit(ReadyState());
        return;
      }
    } else {
      if (locationPermission.isGranted) {
        emit(ReadyState());
        return;
      }
    }

    print('homecubit has loc perm? ${locationPermission.isGranted}');

    if (!shownLocationRequest &&
        (locationPermission.isDenied ||
            locationPermission.isPermanentlyDenied)) {
      emit(RequirePermissionState());
      return;
    }

    emit(ReadyState());
  }

  void logError(Object e) {
    logger.e(e.toString());
  }
}
