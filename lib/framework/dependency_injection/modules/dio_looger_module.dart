import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/dio/dio_logger.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioLoggerModule {
  @LazySingleton(env: [Env.dev, Env.prod])
  DioLogger getDioLogger() {
    final dioLogger = DioLogger();
    return dioLogger;
  }
}
