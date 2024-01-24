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

class NamePage extends StatelessWidget {
  const NamePage({super.key});

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
        title: Text('your_name'.tr()),
        // toolbarHeight: 40,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.all(Sizes.lg),
        bottom: false,
        child: Column(
          children: [
            TextField(
              // focusNode: focusNode,
              controller: nameTC,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'What is your first name?',
                // labelText: 'First Name',
                helperText:
                    'Use your real name; a name your emergency contacts will recognize you by.',
                helperMaxLines: 5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => save(context),
                child: const Text('save').tr(),
              ),
            ),
            VSpace.lg,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('cancel').tr(),
              ),
            ),
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
