// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneshout/common/widgets/ripples/ripples.dart';
import 'package:oneshout/modules/contacts/contacts.dart';
import 'package:oneshout/modules/shout/shout.dart';

class ShoutPage extends StatelessWidget {
  const ShoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShoutCubit(
            networkConnectionBloc: context.read<NetworkConnectionBloc>(),
            shoutRepository: context.read<ShoutRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => ContactsCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: const ShoutView(),
    );
  }
}

class ShoutView extends StatefulWidget {
  const ShoutView({super.key});

  @override
  State<ShoutView> createState() => _ShoutViewState();
}

class _ShoutViewState extends State<ShoutView> with UiLogger {
  final focusNode = FocusNode();

  final nameTC = TextEditingController();
  int countdown = 5;
  late Timer t;
  late BuildContext ctx;
  late ShoutCubit cubit;

  @override
  void initState() {
    super.initState();
    setState(() {
      cubit = context.read<ShoutCubit>();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    startTimer();
  }

  void startTimer() {
    t = Timer.periodic(const Duration(seconds: 1), (_) => setCountdown());
  }

  void setCountdown() {
    setState(() {
      if (countdown == 1) {
        t.cancel();
        callShout();
      } else {
        countdown = countdown - 1;
      }
    });
  }

  Future<void> callShout() async {
    await ctx.read<ShoutCubit>().help();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    final cubit = context.read<ShoutCubit>();
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: cubit.onScreenTap,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          minimum:
              EdgeInsets.symmetric(vertical: Sizes.xl, horizontal: Sizes.xxl),
          child: SizedBox(
            width: double.infinity,
            child: BlocListener<ShoutCubit, ShoutState>(
              listener: (context, state) {
                if (state.status == ShoutStatus.endtracking) {
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<ShoutCubit, ShoutState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ShoutStatus.initial:
                      return _readyWidget();

                    case ShoutStatus.sending:
                      return _sendingShoutWidget();

                    case ShoutStatus.successful:
                      return _shoutCompletedWidget();

                    case ShoutStatus.tracking:
                      return _shoutTrackingWidget();

                    case ShoutStatus.failed:
                      return _shoutSendFailed();
                    case ShoutStatus.endtracking:
                      return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shoutSendFailed() {
    final cubit = context.read<ShoutCubit>();
    return Column(
      children: [
        Text(
          cubit.state.error,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget _readyWidget() {
    return Column(
      children: [
        VSpace.lg,
        const Spacer(),
        if (countdown > 0)
          RipplesAnimation(
            onPressed: () {},
            child: Text(
              countdown.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        const Spacer(),
        Text(
          'Sending a shout in $countdown',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
        VSpace.xxxl,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              t.cancel();
              Navigator.pop(context, null);
            },
            child: const Text('im_safe').tr(),
          ),
        ),
        VSpace.lg,
      ],
    );
  }

  Widget _sendingShoutWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          VSpace.lg,
          Text(
            'sending shout...',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          )
        ],
      ),
    );
  }

  Widget _shoutCompletedWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.check_circle_outline,
            color: Colors.grey.shade600,
            size: 60,
          ),
          VSpace.lg,
          Text(
            'Your shout has been sent successfully!',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          VSpace.xxxl,
          PrimaryBtn(
            onPressed: () {
              cubit.startTracking();
            },
            icon: Icons.location_searching,
            label: 'Enable Location Tracking',
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _shoutTrackingWidget() {
    final cubit = context.read<ShoutCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (cubit.state.screenStatus == ScreenStatus.busy)
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.xxl),
                child: OutlinedBtn(
                  onPressed: cubit.cancelShout,
                  label: 'im_safe'.tr(),
                ),
              ),
              VSpace.lg,
              Text(
                'im_safe_msg'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          )),
        SizedBox(
          width: 70,
          child: Stack(
            children: [
              RipplesAnimation(
                color: Colors.grey.shade800,
                size: 20,
                onPressed: () {},
              ),
              Positioned(
                // rect: Rect.fromCircle(center: Offset., radius: 12),
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey.shade700,
                  child: Text(
                    context.read<ShoutCubit>().state.watchers,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
