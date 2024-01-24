// import 'package:app_auth/app_auth.dart';
// ignore_for_file: strict_raw_type

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneshout/modules/profile/cubit/profile_edit_cubit.dart';
import 'package:oneshout/modules/profile/view/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'auth.my_profile'.tr(),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(Insets.offset),
        child: BlocProvider<ProfileEditCubit>(
          create: (_) => ProfileEditCubit(
            context.read<AuthenticationRepository>(),
          ),
          child: const ProfileForm(),
        ),
      ),
    );
  }
}
