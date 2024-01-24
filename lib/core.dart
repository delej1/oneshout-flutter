import 'package:app_core/app_core.dart';
import 'package:oneshout/common/common.dart' as c;
import 'package:oneshout/common/common.dart';
import 'package:oneshout/injection.dart';

AppConfig config = AppConfig();
late AppCore core;
late HttpNetworkController httpNetworkController;
late c.ThemeService themes;

String jwt = '';
bool isGroupTarget = false;

Future<void> loadAppCore() async {
  core = await AppCore().init();
  themes = await getIt.getAsync<c.ThemeService>();
  config = await getIt.getAsync<AppConfig>();
  httpNetworkController = getIt.get<HttpNetworkController>();
  httpNetworkController.setup(baseUrl: c.Urls.baseApi);
  isGroupTarget = const bool.fromEnvironment(Keys.appConfigTarget);
}
