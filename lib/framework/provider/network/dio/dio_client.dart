import 'package:dio/dio.dart';
import 'package:face_match/framework/utils/local_storage/session.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  /// Get Headers
  Map<String, dynamic> getHeaders() {
    ///Basic Headers
    Map<String, dynamic> headers = {
      'Accept': 'application/json',
      'contentType': 'application/json',
      'Accept-Language': SessionHelper.appLanguage,
    };

    ///Authorization Header
    String token = SessionHelper.userAccessToken;
    if (token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer ${SessionHelper.userAccessToken}'});
    }
    return headers;
  }

  /*
  * ----GET Request
  * */
  Future<dynamic> getRequest(String endPoint, {bool isBytes = false}) async {
    try {
      _dio.options.headers = getHeaders();

      if (isBytes) {
        return await _dio.get(Uri.encodeFull(endPoint), options: Options(responseType: ResponseType.bytes));
      } else {
        return await _dio.get(Uri.encodeFull(endPoint));
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request
  * */
  Future<dynamic> postRequest(String endPoint, String requestBody, {bool isBytes = false}) async {
    try {
      _dio.options.headers = getHeaders();

      if (isBytes) {
        return await _dio.post(
          Uri.encodeFull(endPoint),
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(Uri.encodeFull(endPoint), data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request FormData
  * */
  Future<dynamic> postRequestFormData(String endPoint, FormData requestBody, {bool isBytes = false}) async {
    try {
      _dio.options.headers = {...getHeaders(), 'Content-Type': 'multipart/form-data'};

      if (isBytes) {
        return await _dio.post(
          Uri.encodeFull(endPoint),
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(Uri.encodeFull(endPoint), data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PATCH Request
  * */
  Future<dynamic> patchRequest(String endPoint, FormData requestBody, {bool isBytes = false}) async {
    try {
      _dio.options.headers = getHeaders();

      if (isBytes) {
        return await _dio.patch(
          Uri.encodeFull(endPoint),
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.patch(Uri.encodeFull(endPoint), data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PATCH Request FormData
  * */
  Future<dynamic> patchRequestFormData(String endPoint, FormData requestBody, {bool isBytes = false}) async {
    try {
      _dio.options.headers = getHeaders();

      if (isBytes) {
        return await _dio.patch(
          Uri.encodeFull(endPoint),
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.patch(Uri.encodeFull(endPoint), data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request
  * */
  Future<dynamic> putRequest(String endPoint, String? requestBody) async {
    try {
      _dio.options.headers = getHeaders();
      return await _dio.put(Uri.encodeFull(endPoint), data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request FormData
  * */
  Future<dynamic> putRequestFormData(String endPoint, FormData requestBody) async {
    try {
      _dio.options.headers = getHeaders();
      return await _dio.put(Uri.encodeFull(endPoint), data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----DELETE Request
  * */
  Future<dynamic> deleteRequest(String endPoint, String? requestBody) async {
    try {
      _dio.options.headers = getHeaders();

      return await _dio.delete(Uri.encodeFull(endPoint), data: requestBody);
    } catch (e) {
      rethrow;
    }
  }
}
