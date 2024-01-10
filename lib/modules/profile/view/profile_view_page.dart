// import 'package:app_auth/app_auth.dart';
import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/modules/home/home_routes.dart';
import 'package:oneshout/modules/profile/cubit/profile_cubit.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage>
    with AutomaticKeepAliveClientMixin<ProfileViewPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          // SizedBox(
          //   width: 36,
          //   child: IconBtn(
          //     Icons.edit,
          //     onPressed: () {
          //       context.push(profileRoute);
          //     },
          //   ),
          // ),
          // HSpace.lg,
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(Insets.offset),
        child: BlocProvider<ProfileCubit>.value(
          value: ProfileCubit(
            context.read<AuthenticationRepository>(),
          ),
          child: const ProfileView(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = context.read<AuthBloc>().state.user;

        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // VSpace.l,
              Avatar(photo: user.photo, radius: 40),

              VSpace.xl,
              Text(
                '${user.firstname} ${user.lastname}',
              ).h3(),
              VSpace.sm,
              Text('${user.phone}').subtitle(),
              Text('${user.email}').subtitle(),
              VSpace.xxl,

              const Spacer(),
              // VSpace.xxl,
              PrimaryBtn(
                onPressed: () {
                  context.push('/change_password');
                },
                label: 'Change Password',
              )
            ],
          ),
        );
      },
    );
  }

  TableRow _row(String label, String value) {
    return TableRow(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(label),
            )
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ],
    );
  }
}
