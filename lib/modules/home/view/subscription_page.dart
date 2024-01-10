// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NameFormWidget();
  }
}

class NameFormWidget extends StatelessWidget {
  NameFormWidget({super.key});
  final focusNode = FocusNode();
  final nameTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final cubit = BlocProvider.of<PermissionCubit>(context);

    return Scaffold(
      appBar: AppBar(
          // title: Text('your_name'.tr()),
          // toolbarHeight: 40,
          ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.all(Sizes.lg),
        bottom: false,
        child: Column(
          children: [
            const Text(
              'Subscription Expired',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Text(
              'Your subscription is expired. \nPlease contact your organisation for more information.',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () => save(context),
            //     child: const Text('save').tr(),
            //   ),
            // ),
            VSpace.lg,
          ],
        ),
      ),
    );
  }

  Future<void> save(BuildContext context) async {
    if (nameTC.text.isEmpty) {
      notify.toast('Name field can not be empty.');
      return;
    }
    final name = nameTC.text;
    final box = GetStorage();
    await box.write('name', name);

    Navigator.pop(context, name);
  }
}
