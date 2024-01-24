import 'package:app_core/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/features/locators/cubit/locator_states.dart';
import 'package:oneshout/modules/locator/locator.dart';

class LocatorRequestPage extends StatelessWidget {
  const LocatorRequestPage({
    super.key,
    required this.phone,
    required this.name,
  });
  final String phone;
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocatorCubit(locatorRepository: context.read<LocatorRepository>()),
      child: BlocBuilder<LocatorCubit, LocatorState>(
        builder: (context, state) {
          final cubit = context.read<LocatorCubit>();
          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                width: double.infinity,
                padding: EdgeInsets.all(Insets.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.location_history,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Text(
                      'location_request',
                      textAlign: TextAlign.center,
                    ).tr().h3(),
                    VSpace.xxl,
                    Text(
                      '$name ($phone) ${'view_location_request_msg'.tr()}',
                      textAlign: TextAlign.center,
                    ),
                    VSpace.xxl,
                    const Spacer(),
                    PrimaryBtn(
                      onPressed: () async {
                        final ctx = Navigator.of(context);
                        final canPop =
                            await cubit.grantLocatorRequest(phone: phone);
                        if (canPop) ctx.pop();
                      },
                      label: 'accept'.tr(),
                    ),
                    VSpace.lg,
                    OutlinedBtn(
                      onPressed: () async {
                        final ctx = Navigator.of(context);
                        final canPop = await cubit.respondToLocatorRequest(
                          phone: phone,
                          accept: false,
                        );
                        if (canPop) ctx.pop();
                      },
                      label: 'reject'.tr(),
                    ),
                    VSpace.xxl,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
