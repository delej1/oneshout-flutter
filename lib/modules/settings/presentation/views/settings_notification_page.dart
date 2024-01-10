// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneshout/core.dart' show config, core;
import 'package:oneshout/modules/settings/settings.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'settings.notifications'.tr(),
      subtitle: 'settings.newsletter_updates'.tr(),
      leading: const IconWidget(
        icon: Icons.notifications,
        color: Colors.redAccent,
      ),
      child: SettingsScreen(
        title: 'settings.notifications'.tr(),
        children: [
          if (config.enabled<bool>(
            core.keys.ck_settings_notification_latest_news,
          )) ...[
            buildNews(),
          ],
          if (config.enabled<bool>(
            core.keys.ck_settings_notification_account_activity,
          )) ...[
            buildActivity(),
          ],
          if (config.enabled<bool>(
            core.keys.ck_settings_notification_newsletter,
          )) ...[
            buildNewsletter(),
          ],
          if (config.enabled<bool>(
            core.keys.ck_settings_notification_app_updates,
          )) ...[
            buildAppUpdates(),
          ],
        ],
      ),
    );
  }

  Widget buildNews() => SwitchSettingsTile(
        settingKey: keyNotificationNews,
        title: 'settings.local_news'.tr(),
        leading: const IconWidget(
          icon: Icons.message,
          color: Colors.blue,
        ),
        onChange: (value) {},
      );

  Widget buildActivity() => SwitchSettingsTile(
        settingKey: keyNotificationAccountActivity,
        title: 'settings.account_activity'.tr(),
        leading: const IconWidget(icon: Icons.person, color: Colors.orange),
        onChange: (value) {},
      );

  Widget buildNewsletter() => SwitchSettingsTile(
        settingKey: keyNotificationNewsletter,
        title: 'settings.newsletter'.tr(),
        leading: const IconWidget(
          icon: Icons.text_snippet,
          color: Colors.red,
        ),
        onChange: (value) {},
      );

  Widget buildAppUpdates() => SwitchSettingsTile(
        settingKey: keyNotificationAppUpdate,
        title: 'settings.app_updates'.tr(),
        leading: const IconWidget(
          icon: Icons.update,
          color: Colors.teal,
        ),
        onChange: (value) {},
      );
}
