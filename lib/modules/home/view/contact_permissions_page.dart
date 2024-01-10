// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPermissionsPage extends StatelessWidget {
  const ContactPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PermissionsViewer();
  }
}

class PermissionsViewer extends StatelessWidget {
  const PermissionsViewer({super.key});

  @override
  Widget build(BuildContext context) {
    // final cubit = BlocProvider.of<PermissionCubit>(context);

    return Scaffold(
      appBar: AppBar(
          // title: Text('app_title'.tr()),
          // toolbarHeight: 40,
          ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            Expanded(
              child: ClippedContainer(
                child: SMSRequest(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SMSRequest extends StatelessWidget {
  const SMSRequest({super.key});

  @override
  Widget build(BuildContext context) {
    // final cubit = BlocProvider.of<PermissionCubit>(context);
    // final homeCubit = BlocProvider.of<HomeCubit>(context);

    // final perm = cubit.perms[cubit.state];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VSpace.lg,
        const Text('contacts_permission').tr().h5(),
        const Spacer(),
        Icon(
          Icons.contact_phone_outlined,
          size: 120,
          color: Colors.grey.shade300,
        ),
        VSpace.lg,
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'contacts_permission_msg'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final granted = await Permission.contacts.request();
                    if (granted.isGranted) {
                      Navigator.pop(context);
                      // context.go('/$addContactsRoute');
                    } else if (granted.isDenied ||
                        granted.isPermanentlyDenied) {
                      await openAppSettings();
                      // Navigator.pop(context);
                    }
                  },
                  child: Text(
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? 'Proceed'
                        : 'grant_permission',
                  ).tr(),
                ),
              ),
              VSpace.lg,
              if (defaultTargetPlatform == TargetPlatform.android)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      //check if location is granted, else go there.
                      Navigator.pop(context);
                    },
                    child: const Text('later').tr(),
                  ),
                ),
            ],
          ),
        ),
        VSpace.lg,
      ],
    );
  }
}
