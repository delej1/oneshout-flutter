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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/modules/home/cubit/permission_cubit.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PermissionCubit(),
        ),
        // BlocProvider(
        //   create: (context) => HomeCubit(),
        // ),
      ],
      child: const PermissionsViewer(),
    );
  }
}

class PermissionsViewer extends StatelessWidget {
  const PermissionsViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PermissionCubit>(context);

    return Scaffold(
      appBar: AppBar(
          // title: Text('app_title'.tr()),
          // toolbarHeight: 40,
          ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ClippedContainer(
                child: BlocBuilder<PermissionCubit, int>(
                  builder: (context, state) {
                    // print(state);
                    if (state == 0) {
                      return const LocationRequest();
                    }
                    // if (state == 1 &&
                    //     defaultTargetPlatform == TargetPlatform.android) {
                    //   return const SMSRequest();
                    // }
                    return const Center(
                      child: Text('There are no new permissions to grant.'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SMSRequest extends StatelessWidget {
//   const SMSRequest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = BlocProvider.of<PermissionCubit>(context);
//     // final homeCubit = BlocProvider.of<HomeCubit>(context);

//     final perm = cubit.perms[cubit.state];
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         VSpace.lg,
//         const Text('sms_permission').tr().h5(),
//         const Spacer(),
//         Icon(Icons.message_outlined, size: 120, color: Colors.grey.shade300),
//         VSpace.lg,
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             'sms_permission_msg'.tr(),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const Spacer(),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final navigator = Navigator.of(context);
//                   await cubit.requestLocationPermissions();
//                   navigator.pop();
//                 },
//                 child: const Text('grant_permission').tr(),
//               ),
//             ),
//             VSpace.lg,
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () async {
//                   //check if location is granted, else go there.
//                   Navigator.pop(context);
//                 },
//                 child: const Text('later').tr(),
//               ),
//             ),
//           ],
//         ),
//         VSpace.lg,
//       ],
//     );
//   }
// }

class LocationRequest extends StatelessWidget {
  const LocationRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PermissionCubit>(context);
    // final homeCubit = BlocProvider.of<HomeCubit>(context);

    final perm = cubit.perms[cubit.state];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VSpace.lg,
        const Text('location_permission').tr().h5(),
        const Spacer(),
        Icon(
          Icons.location_on_outlined,
          size: 120,
          color: Colors.grey.shade300,
        ),
        VSpace.lg,
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'location_permission_msg'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await cubit.requestLocationPermissions().then((value) async {
                    Navigator.pop(context);
                  });
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
                    final box = GetStorage();
                    await box.write('shown_location_request', true);
                    Navigator.pop(context);
                  },
                  child: const Text('later').tr(),
                ),
              ),
          ],
        ),
        VSpace.lg,
      ],
    );
  }
}
