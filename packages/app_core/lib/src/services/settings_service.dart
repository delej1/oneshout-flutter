import 'package:app_core/app_core.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

/// A cache access provider class for shared preferences using shared_preferences library
@injectable
class SettingsCacheService extends CacheProvider with UiLogger {
  final String keyName = 'app_preferences';
  final storage = GetStorage();
  //  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> init() async {}

  @override
  bool? containsKey(String key) {
    return storage.hasData(key);
  }

  @override
  bool? getBool(String key) {
    return storage.read<bool>(key);
  }

  @override
  double? getDouble(String key) {
    return storage.read<double>(key);
  }

  @override
  int? getInt(String key) {
    return storage.read<int>(key);
  }

  @override
  Set? getKeys() {
    return storage.getKeys();
  }

  @override
  String? getString(String key) {
    return storage.read<String>(key);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    if (storage.hasData(key)) {
      return storage.read<T>(key) as T;
    } else {
      storage.write(key, defaultValue);
    }
    return defaultValue;
  }

  @override
  Future<void> remove(String key) {
    return storage.remove(key);
  }

  @override
  Future<void> removeAll() {
    return storage.erase();
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue}) {
    return storage.write(key, value);
  }

  @override
  Future<void> setDouble(String key, double? value, {double? defaultValue}) {
    return storage.write(key, value);
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue}) {
    return storage.write(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return storage.write(key, value);
  }

  @override
  Future<void> setString(String key, String? value, {String? defaultValue}) {
    return storage.write(key, value);
  }
  //...
}
