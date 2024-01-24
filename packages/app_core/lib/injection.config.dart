// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'app_core.dart' as _i4;
import 'src/network/network_client.dart' as _i7;
import 'src/services/app_config.dart' as _i3;
import 'src/services/connectivity_service.dart' as _i9;
import 'src/services/firebase_analytics_service.dart' as _i6;
import 'src/services/firebase_iam_service.dart' as _i8;
import 'src/services/notifications/notifications_service.dart' as _i5;
import 'src/services/settings_service.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singletonAsync<_i3.AppConfig>(() => _i3.AppConfig.init());
  gh.singleton<_i4.AppCore>(_i4.AppCore());
  // gh.singleton<_i5.AppNotificationService>(_i5.AppNotificationService());
  gh.factory<_i3.ConfigKeys>(() => _i3.ConfigKeys());
  gh.singleton<_i6.FirebaseAnalyticsService>(_i6.FirebaseAnalyticsService());
  gh.singleton<_i7.HttpNetworkController>(_i7.HttpNetworkController());
  gh.singleton<_i8.InAppMessagingService>(_i8.InAppMessagingService());
  // gh.singleton<_i9.NetworkConnectionBloc>(_i9.NetworkConnectionBloc());
  gh.factory<_i10.SettingsCacheService>(() => _i10.SettingsCacheService());
  return get;
}
