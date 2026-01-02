import 'package:objectbox/objectbox.dart';

@Entity()
class UserEntity {
  @Id()
  int id = 0;

  String name;
  String imagePath;

  UserEntity({required this.name, required this.imagePath});
}
