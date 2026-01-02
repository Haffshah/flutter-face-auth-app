import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/repository/user/contract/user_repository.dart';
import 'package:face_match/models/user_entity.dart';
import 'package:face_match/ui/routing/navigation_stack_item.dart';
import 'package:face_match/ui/routing/stack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final userListControllerProvider = ChangeNotifierProvider.autoDispose<UserListController>(
  (ref) => getIt<UserListController>(),
);

@injectable
class UserListController extends ChangeNotifier {
  final UserRepository _userRepository;
  UserListController(this._userRepository);

  List<UserEntity> users = [];
  bool isLoading = false;

  void loadUsers() {
    isLoading = true;
    notifyListeners();

    // Fetch from ObjectBox
    users = _userRepository.getAllUsers();

    isLoading = false;
    notifyListeners();
  }

  void deleteUser(int userId) {
    _userRepository.deleteUser(userId);
    loadUsers(); // Reload the list
  }

  void editUser(WidgetRef ref, UserEntity user) {
    // Navigate to registration screen with user data for editing
    ref.read(navigationStackController).push(NavigationStackItem.userRegistration(user: user));
  }

  void navigateToRegistration(WidgetRef ref) {
    ref.read(navigationStackController).push(const NavigationStackItem.userRegistration());
  }

  void navigateToFaceScan(WidgetRef ref) {
    ref.read(navigationStackController).push(const NavigationStackItem.faceScan());
  }
}
