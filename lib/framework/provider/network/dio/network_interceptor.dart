import 'package:face_match/framework/provider/network/network.dart';
import 'package:face_match/ui/routing/delegate.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';

bool enableLogoutDialog = true;

InterceptorsWrapper networkInterceptor() {
  CancelToken cancelToken = CancelToken();
  return InterceptorsWrapper(
    onRequest: (request, handler) async {
      request.cancelToken = cancelToken;
      handler.next(request);
    },
    onResponse: (response, handler) {
      List<String> whiteListAPIs = [];
      try {
        if ((whiteListAPIs.contains(response.realUri.path)) &&
            (response.data is Map || (response.data is String && response.data.toString().isNotEmpty))) {
          showLog('Network Interceptor On Success ${response.statusCode}');
          if (response.statusCode != ApiEndPoints.apiStatus_200) {
            if (globalNavigatorKey.currentState?.context != null) {
              showMessageDialog(globalNavigatorKey.currentState!.context, response.statusMessage ?? '', null);
              return;
            }
          }
        }
        handler.next(response);
      } catch (e, s) {
        showLog('stacktrace $s');
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: const NetworkExceptions.unexpectedError(),
          ),
          false,
        );
      }
    },
    onError: (error, handler) {
      final response = error.response;
      showLog('Network Interceptor ON Error ${response?.statusCode}');

      if (response?.statusCode == ApiEndPoints.apiStatus_401) {
        if (globalNavigatorKey.currentState?.context != null) {
          sessionExpiredDialog(globalNavigatorKey.currentState!.context);
          return;
        }
      }
      handler.next(error);
    },
  );
}
