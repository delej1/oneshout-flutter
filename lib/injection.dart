import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:oneshout/injection.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) {
  $initGetIt(getIt, environment: env);
}

abstract class Environment {
  static const dev = 'dev';
  static const prod = 'prod';
}
