// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/modules/home/cubit/permission_states.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_handler/permission_handler.dart';

class PermissionCubit extends Cubit<int> with NetworkLogger, UiLogger {
  PermissionCubit() : super(0) {
    viewPermissions();
  }

  final box = GetStorage();
  final perms = [
    Perm(
      title: 'Location permssion',
      body:
          'We require permission to access your location so that it will be included in your messages when you have an emergency.',
      action: () async {
        await ph.Permission.location.request();
        return;
      },
    ),
  ];

  void increment() => emit(state + 1);

  Future<void> viewPermissions() async {
    final locationPermission = await ph.Permission.location.status;
    if (locationPermission.isGranted) {
      emit(1);
    } else {
      emit(0);
      return;
    }
    // final smsPermission = await ph.Permission.sms.status;
    // if (smsPermission.isGranted) {
    //   emit(3);
    // } else {
    //   emit(1);
    //   return;
    // }
  }

  // Future<void> requestSMSPermissions() async {
  //   final smsPermission = await ph.Permission.sms.status;
  //   if (smsPermission.isDenied || smsPermission.isPermanentlyDenied) {
  //     logger.d('Requesting SMS');
  //     await ph.Permission.sms.request();
  //   }
  // }

  Future<void> requestLocationPermissions() async {
    try {
      final locationPermission = await ph.Permission.location.status;
      if (locationPermission.isDenied ||
          locationPermission.isPermanentlyDenied) {
        logger.d('Requesting Location');
        await ph.Permission.location.request();
        // await openAppSettings();
      } else {
        await ph.Permission.location.request();
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // Future<bool> hasSmsPermissions() async {
  //   final smsPermission = await ph.Permission.sms.status;
  //   return smsPermission.isGranted;
  // }

  Future<bool> hasLocationPermissions() async {
    final locationPermission = await ph.Permission.location.status;
    return locationPermission.isGranted;
  }
}
