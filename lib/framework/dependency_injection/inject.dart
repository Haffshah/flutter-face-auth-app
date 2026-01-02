import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:face_match/framework/dependency_injection/inject.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureMainDependencies({required String environment}) async => GetItInjectableX(getIt).init(environment: environment);

abstract class Env {
  static const dev = 'development';
  static const prod = 'production';
}
