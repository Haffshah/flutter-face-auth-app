import 'package:objectbox/objectbox.dart';

@Entity()
class EmployeeEmbedding {
  @Id()
  int id = 0;

  int userId;

  @HnswIndex(dimensions: 192)
  @Property(type: PropertyType.floatVector)
  List<double> embedding;

  EmployeeEmbedding({required this.userId, required this.embedding});
}
