import 'package:face_match/models/user_entity.dart';

abstract class UserRepository {
  int saveUser(UserEntity user);
  List<UserEntity> getAllUsers();
  UserEntity? getUser(int id);
  bool deleteUser(int id);
  bool updateUser(UserEntity user);
}
