import 'package:dio/dio.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/dio/dio_client.dart';
import 'package:face_match/framework/provider/network/dio/dio_logger.dart';
import 'package:face_match/framework/provider/network/dio/network_interceptor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @LazySingleton(env: [Env.prod])
  DioClient getProductionDioClient(DioLogger dioLogger) {
    final dio = Dio(BaseOptions(baseUrl: 'Add your url '));
    dio.interceptors.add(networkInterceptor());
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }

  @LazySingleton(env: [Env.dev])
  DioClient getDebugDioClient(DioLogger dioLogger) {
    final dio = Dio(BaseOptions(baseUrl: 'Add your url'));
    dio.interceptors.add(networkInterceptor());
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }
}
