// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneshout/core.dart' show config, core;
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'settings.account_settings'.tr(),
      subtitle: 'settings.privacy_security_language'.tr(),
      leading: const IconWidget(
        icon: Icons.person,
        color: Colors.green,
      ),
      child: SettingsScreen(
        title: 'settings.account_settings'.tr(),
        children: [
          if (config.enabled<bool>(core.keys.ck_settings_language))
            buildLanguage(context),
          if (config.enabled<bool>(core.keys.ck_settings_location)) ...[
            buildLocation(context),
          ],
          if (config.enabled<bool>(core.keys.ck_settings_privacy)) ...[
            buildPrivacy(context),
          ],
          if (config.enabled<bool>(core.keys.ck_settings_security)) ...[
            buildSecurity(context),
          ],
          // if (config.enabled<bool>(core.keys.ck_settings_account_info)) ...[
          //   buildAccountInfo(context),
          // ],
        ],
      ),
    );
  }

  Widget buildLanguage(BuildContext context) {
    // core.settings.remove(core.keys.ck_settings_language);
    // core.settings
    // .setObject<Language>(core.keys.ck_settings_language, Language());
    // core.settings
    //     .getValue<Language>(core.keys.ck_settings_language, Language());
    // return Container();
    // final defaultValue = Language();
    // final storeValue = core.settings.getValue<Map<String, dynamic>>(
    // core.keys.ck_settings_language, defaultValue.toJson());
    final storeValue =
        core.settings.getValue<String>(core.keys.ck_settings_language, 'en');
    // final selectedMap = storeValue is Language
    //     ? storeValue
    //     : Language.fromJson(storeValue as Map<String, dynamic>);
    // Language.fromJson(storeValue);

    return LanguageSettingsTile<String>(
      settingKey: core.keys.ck_settings_language,
      title: 'settings.language'.tr(),
      leading: const IconWidget(
        icon: Icons.language,
        color: Colors.orange,
      ),
      locales: context.supportedLocales,
      defaultValue: storeValue,
      onChange: (value) {
        // setState(() {});
        EasyLocalization.of(context)
            ?.setLocale(Locale(value.languageCode, value.countryCode));
      },
    );
  }

  Widget buildLocation(BuildContext context) {
    // final _countryList = countries.toList();
    // final _filteredCountries = _countryList;
    final subtitle =
        core.settings.getValue<String>(core.keys.ck_settings_location, '');
    return CountrySettingsTile<String>(
      settingKey: core.keys.ck_settings_location,
      title: 'settings.location'.tr(),
      defaultValue:
          core.settings.getValue<String>(core.keys.ck_settings_location, ''),
      subtitle: subtitle,
      leading: const IconWidget(
        icon: Icons.location_city,
        color: Colors.green,
      ),
      onChange: (value) {
        setState(() {});
      },
    );
  }

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
        title: 'settings.privacy'.tr(),
        subtitle: '',
        leading: const IconWidget(icon: Icons.lock, color: Colors.blue),
        onTap: () {
          launchUrl(
            Uri.parse(
              'https://one-shout.netlify.app/',
            ),
          );
        },
      );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: 'settings.security'.tr(),
        subtitle: '',
        leading: const IconWidget(
          icon: Icons.security,
          color: Colors.red,
        ),
        onTap: () {},
      );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
        title: 'settings.account_info'.tr(),
        subtitle: '',
        leading: const IconWidget(
          icon: Icons.text_snippet,
          color: Colors.purple,
        ),
        onTap: () {},
      );
}
