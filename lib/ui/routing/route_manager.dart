import 'package:face_match/ui/routing/delegate.dart';
import 'package:face_match/ui/routing/navigation_stack_keys.dart';
import 'package:face_match/framework/utils/extension/context_extension.dart';

class RouteManager {
  ///Singleton Class for [RouteManger]
  RouteManager._();

  ///Instance [route] to call methods for [RouteManager]
  static RouteManager route = RouteManager._();

  ///Path Segments to display a path after removing empty paths
  List<String> pathSegments = [];

  ///To remove any empty path after [/] in Path Segments
  void removeEmptyPath(List<String> segments) {
    pathSegments = segments.toList();
    pathSegments.removeWhere((element) => element.trim().isEmpty);
  }

  ///To check if the current route is valid
  Future<RouteValidator> checkPathValidation() {
    ///If mobile then always return true
    if (globalNavigatorKey.currentContext?.isMobileScreen ?? false) {
      return Future.value(RouteValidator(isAuthenticated: true, isRouteValid: true));
    }

    ///If empty then always return true
    if (pathSegments.isEmpty) {
      return Future.value(RouteValidator(isAuthenticated: true, isRouteValid: true));
    }

    ///Create a path without any parameters
    String path = pathSegments.join('/');

    ///Will check authentication
    bool isAuthenticated = true;

    ///Will check validation and return accordingly
    switch (pathSegments.last) {
      /// Splash
      case Keys.splash:
        String validationPath = Keys.splash;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      default:
        return Future.value(RouteValidator(isAuthenticated: true, isRouteValid: true));
    }
  }
}

class RouteValidator {
  bool isRouteValid;
  bool isAuthenticated;

  RouteValidator({
    this.isRouteValid = false,
    this.isAuthenticated = false,
  });
}
