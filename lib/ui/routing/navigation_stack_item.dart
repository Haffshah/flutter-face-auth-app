import 'package:face_match/models/user_entity.dart';

// Wrapper for NavigationStackItem to replace Freezed union
abstract class NavigationStackItem {
  const NavigationStackItem();

  const factory NavigationStackItem.splash() = NavigationStackItemSplashPage;
  const factory NavigationStackItem.userRegistration({UserEntity? user}) = NavigationStackItemUserRegistrationPage;
  const factory NavigationStackItem.userList() = NavigationStackItemUserListPage;
  const factory NavigationStackItem.faceScan() = NavigationStackItemFaceScanPage;

  T when<T>({
    required T Function() splash,
    required T Function(UserEntity? user) userRegistration,
    required T Function() userList,
    required T Function() faceScan,
  });
}

class NavigationStackItemSplashPage extends NavigationStackItem {
  const NavigationStackItemSplashPage();

  @override
  T when<T>({
    required T Function() splash,
    required T Function(UserEntity? user) userRegistration,
    required T Function() userList,
    required T Function() faceScan,
  }) {
    return splash();
  }

  @override
  bool operator ==(Object other) => other is NavigationStackItemSplashPage;

  @override
  int get hashCode => 0;
}

class NavigationStackItemUserRegistrationPage extends NavigationStackItem {
  final UserEntity? user;

  const NavigationStackItemUserRegistrationPage({this.user});

  @override
  T when<T>({
    required T Function() splash,
    required T Function(UserEntity? user) userRegistration,
    required T Function() userList,
    required T Function() faceScan,
  }) {
    return userRegistration(user);
  }

  @override
  bool operator ==(Object other) => other is NavigationStackItemUserRegistrationPage && other.user == user;

  @override
  int get hashCode => user.hashCode;
}

class NavigationStackItemUserListPage extends NavigationStackItem {
  const NavigationStackItemUserListPage();

  @override
  T when<T>({
    required T Function() splash,
    required T Function(UserEntity? user) userRegistration,
    required T Function() userList,
    required T Function() faceScan,
  }) {
    return userList();
  }

  @override
  bool operator ==(Object other) => other is NavigationStackItemUserListPage;

  @override
  int get hashCode => 2;
}

class NavigationStackItemFaceScanPage extends NavigationStackItem {
  const NavigationStackItemFaceScanPage();

  @override
  T when<T>({
    required T Function() splash,
    required T Function(UserEntity? user) userRegistration,
    required T Function() userList,
    required T Function() faceScan,
  }) {
    return faceScan();
  }

  @override
  bool operator ==(Object other) => other is NavigationStackItemFaceScanPage;

  @override
  int get hashCode => 3;
}
