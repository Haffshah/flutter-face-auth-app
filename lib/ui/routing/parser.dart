import 'package:face_match/framework/utils/local_storage/session.dart';
import 'package:face_match/ui/routing/navigation_stack_item.dart';
import 'package:face_match/ui/routing/navigation_stack_keys.dart';
import 'package:face_match/ui/routing/route_manager.dart';
import 'package:face_match/ui/routing/stack.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainRouterInformationParser extends RouteInformationParser<NavigationStack> {
  WidgetRef ref;
  BuildContext context;

  MainRouterInformationParser(@factoryParam this.ref, @factoryParam this.context);

  ///Parse Screen from URL
  @override
  Future<NavigationStack> parseRouteInformation(RouteInformation routeInformation) async {
    List<String> queryParam = [];
    List<String> tempUrlList = routeInformation.uri.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    String mainUrl = '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    showLog('........URL......$mainUrl');
    final Uri uri = Uri.parse(mainUrl);
    final queryParams = uri.queryParameters;
    showLog('........queryParams....$queryParams');

    final items = <NavigationStackItem>[];
    showLog('Path Segments-> ${uri.pathSegments}');

    ///Will remove all the empty path from segments
    RouteManager.route.removeEmptyPath(uri.pathSegments);

    ///To add error page at the end and return no widget if error is found
    bool hasError = false;

    ///To add error page at the end and return no widget if error is found
    bool isAuthenticated = true;

    ///Will check validation for routes
    await RouteManager.route.checkPathValidation().then((value) async {
      if (SessionHelper.userAccessToken != '') {}
      showLog('${uri.pathSegments}');
      for (var i = 0; i < uri.pathSegments.length; i = i + 1) {
        ///To add error page at the end and return no widget if error is found

        hasError = !value.isRouteValid;
        isAuthenticated = value.isAuthenticated;
        if (kDebugMode) {
          showLog('$hasError');
        }
        if (kDebugMode) {
          showLog('$isAuthenticated');
        }
        final key = uri.pathSegments[i];
        switch (key) {
          case Keys.splash:
            items.add(const NavigationStackItem.splash());
            break;
          case Keys.userRegistration:
            items.add(const NavigationStackItem.userRegistration());
            break;
          case Keys.userList:
            items.add(const NavigationStackItem.userList());
            break;
          case Keys.faceScan:
            items.add(const NavigationStackItem.faceScan());
            break;

          default:
            items.add(NavigationStackItem.splash());
        } // for
      }
    });

    ///If have error then add 404 without passing any key so the path will not be shown in url
    // if (hasError) {
    //   items.add(const NavigationStackItem.error(errorType: ErrorType.error404));
    // } else if (!(isAuthenticated)) {
    //   items.add(const NavigationStackItem.error(errorType: ErrorType.error403));
    // }

    if (items.isEmpty) {
      const fallback = NavigationStackItem.splash();
      if (items.isNotEmpty && items.first is NavigationStackItemSplashPage) {
        items[0] = fallback;
      } else {
        items.insert(0, fallback);
      }
    }
    return NavigationStack(items);
  }

  ///THIS IS IMPORTANT: Here we restore the web history
  @override
  RouteInformation? restoreRouteInformation(NavigationStack configuration) {
    final location = configuration.items.fold<String>('', (previousValue, element) {
      return previousValue +
          element.when(
            splash: () => '/${Keys.splash}',
            userRegistration: (user) => '/${Keys.userRegistration}',
            userList: () => '/${Keys.userList}',
            faceScan: () => '/${Keys.faceScan}',
          );
    });
    List<String> queryParam = [];
    List<String> tempUrlList = location.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    String mainUrl = '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    Uri routeUrl = Uri.parse(mainUrl);
    return RouteInformation(uri: routeUrl);
  }
}
