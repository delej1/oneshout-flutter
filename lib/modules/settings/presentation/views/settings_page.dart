// ignore_for_file: lines_longer_than_80_chars

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:oneshout/bootstrap.dart';
import 'package:oneshout/common/common.dart' as c;
import 'package:oneshout/core.dart' show config, core;
import 'package:oneshout/modules/home/home_routes.dart';
import 'package:oneshout/modules/settings/settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white, //Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('settings.settings').tr(),
        // toolbarHeight: 80,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ClippedContainer(
                padding: EdgeInsets.all(Insets.lg),
                child: const ResponsiveWidget(
                  mobile: _SettingsPageWidget(),
                  desktop: Center(
                    child: SizedBox(width: 500, child: _SettingsPageWidget()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPageWidget extends StatelessWidget {
  const _SettingsPageWidget();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingsGroup(
          title: '',
          children: [
            if (config
                .enabled<bool>(core.keys.ck_settings_account_userProfile)) ...[
              buildUser(context),
              VSpace.sm,
            ],
          ],
        ),
        SettingsGroup(
          title: 'settings.shout'.tr().toUpperCase(),
          children: [
            VSpace.sm,
            if (config.enabled<bool>(core.keys.ck_settings_shout)) ...[
              buildTracking(context),
            ],
          ],
        ),
        //..................................................................................
        SettingsGroup(
          title: 'SUBSCRIPTION',
          children: [
            VSpace.sm,
            buildRestoreSub()
          ],
        ),
        //..................................................................................
        SettingsGroup(
          title: 'settings.general'.tr().toUpperCase(),
          children: [
            VSpace.sm,
            if (config.enabled<bool>(core.keys.ck_settings_darkMode)) ...[
              buildDarkMode(context),
            ],
            if (config.enabled<bool>(core.keys.ck_settings_account)) ...[
              const AccountPage(),
            ],
            if (config.enabled<bool>(core.keys.ck_settings_notification)) ...[
              const NotificationPage(),
            ],
            if (config.enabled<bool>(core.keys.ck_settings_account_logout)) ...[
              buildLogout(context),
            ],
            //..................................................................................
            buildDeleteAccount(context),
            //..................................................................................
            // if (config.enabled<bool>(
            //   core.keys.ck_settings_account_delete_account,
            // )) ...[
            //   buildDeleteAccount(context),
            // ],
          ],
        ),
        if (config.enabled<bool>(core.keys.ck_settings_feedback)) ...[
          VSpace.lg,
          SettingsGroup(
            title: 'settings.feedback'.tr().toUpperCase(),
            children: [
              VSpace.sm,
              if (config.enabled<bool>(
                core.keys.ck_settings_feedback_report_bug,
              )) ...[
                buildReportBug(),
              ],
              if (config.enabled<bool>(
                core.keys.ck_settings_feedback_send_feedback,
              )) ...[
                buildSendFeedback(),
              ],
            ],
          ),
        ],
        VSpace.xxl,
        Text(
          'Version: ${packageInfo?.version}', //\nBuild Number: ${packageInfo?.buildNumber}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildUser(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final box = GetStorage();
    final name = box.read<String>('name');

    return CustomSimpleSettingsTile(
      showDivider: false,
      customListTile: ListTile(
        onTap: () => context.push(profileViewRoute),
        title: Row(
          children: [
            Avatar(photo: user.photo, radius: 40),
            HSpace.lg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstname} ${user.lastname}',
                    style: Theme.of(context).textTheme.headline2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    user.email ?? '',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///DarkMode
  Widget buildTracking(BuildContext context) => SwitchSettingsTile(
        settingKey: core.keys.ck_settings_shout_tracking,
        title: 'settings.tracking'.tr(),
        subtitle: 'Only active when you send a shout.',
        leading: const IconWidget(
          icon: Icons.location_searching,
          color: Colors.red,
        ),
        // onChange: (value) {},
      );

  ///DarkMode
  Widget buildDarkMode(BuildContext context) => SwitchSettingsTile(
        settingKey: core.keys.ck_settings_darkMode,
        title: 'settings.dark_mode'.tr(),
        leading: IconWidget(
          icon: Icons.dark_mode,
          color: c.ThemeService().dark.colorScheme.primary,
        ),
        onChange: (value) {
          value
              ? AdaptiveTheme.of(context).setDark()
              : AdaptiveTheme.of(context).setLight();
        },
      );

  ///Logout
  Widget buildLogout(BuildContext context) => SimpleSettingsTile(
        title: 'settings.logout'.tr(),
        subtitle: '',
        leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
        onTap: () {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        },
      );

  ///Delete Account
  Widget buildDeleteAccount(BuildContext context){
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return SimpleSettingsTile(
      title: 'settings.delete_account'.tr(),
      subtitle: '',
      leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
      onTap: () {
        //..................................................................................
        showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text("Delete Account", style: TextStyle(color: Colors.black),),
          content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text("Are you sure you want to delete account and associated details? \n(Note that account deletion may take up to 30 minutes for completion)",)
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async{
                deleteUser(user.firstname, user.lastname, user.email, user.phone).then((value){
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  notify.toast("Account will be deleted within 30 minutes");
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              //return false when click on "NO"
              child: const Text('Delete'),
            ),
          ],
        ));
        //..................................................................................
      },
    );
  }

  ///Report Bug
  Widget buildReportBug() => SimpleSettingsTile(
        title: 'settings.report_a_bug'.tr(),
        subtitle: '',
        leading: const IconWidget(icon: Icons.bug_report, color: Colors.teal),
        onTap: () async {
          final mail = Uri.parse(
            'mailto:economicbusinessstrategies@gmail.com?subject=Reporting a Bug on One Shout&body=',
          );
          await launchUrl(mail);
        },
      );

  ///Send Feedback
  Widget buildSendFeedback() => SimpleSettingsTile(
        title: 'settings.send_feedback'.tr(),
        subtitle: '',
        leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: () async {
          final mail = Uri.parse(
            'mailto:economicbusinessstrategies@gmail.com?subject=Feedback on One Shout&body=',
          );
          await launchUrl(mail);
        },
      );

  //..................................................................................
  ///Restore Sub
  Widget buildRestoreSub() => SimpleSettingsTile(
    title: 'Restore Subscription',
    subtitle: '',
    leading: const IconWidget(icon: Icons.restore, color: Colors.brown),
    onTap: () async{
      try {
        CustomerInfo customerInfo = await Purchases.restorePurchases();
        List activeSubs = customerInfo.activeSubscriptions;
        // ... check restored purchaserInfo to see if entitlement is now active
        activeSubs.isEmpty?
        notify.toast("No active subscriptions"):notify.toast("Sub: ${activeSubs.toString()}");
      } on PlatformException catch (e) {
        // Error restoring purchases
        notify.toast(e.toString());
      }
    },
  );
  //..................................................................................

  //..................................................................................
  Future deleteUser(firstname, lastname, email, phone) async{
    final collection = FirebaseFirestore.instance.collection('delete_request');
    await collection.doc().set({
      'first_name': firstname,
      'last_name': lastname,
      'user_email': email,
      'phone': phone,
      'request': "Please delete my account"});
  }
//..................................................................................
}