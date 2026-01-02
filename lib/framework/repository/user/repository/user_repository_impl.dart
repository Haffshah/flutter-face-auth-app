import 'package:injectable/injectable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:face_match/models/user_entity.dart';
import 'package:face_match/framework/repository/user/contract/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final Store _store;
  late final Box<UserEntity> _userBox;

  UserRepositoryImpl(this._store) {
    _userBox = _store.box<UserEntity>();
  }

  @override
  int saveUser(UserEntity user) {
    return _userBox.put(user);
  }

  @override
  List<UserEntity> getAllUsers() {
    return _userBox.getAll();
  }

  @override
  UserEntity? getUser(int id) {
    return _userBox.get(id);
  }

  @override
  bool deleteUser(int id) {
    return _userBox.remove(id);
  }

  @override
  bool updateUser(UserEntity user) {
    _userBox.put(user);
    return true;
  }
}
