import 'package:app_core/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getItCore = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => $initGetIt(getItCore);
