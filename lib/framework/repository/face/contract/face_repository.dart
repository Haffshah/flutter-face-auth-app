import 'package:face_match/models/employee_embedding.dart';

abstract class FaceRepository {
  Future<void> initialize();
  int saveEmbedding(EmployeeEmbedding item);
  List<EmployeeEmbedding> search(List<double> queryVector, {int topK = 10});
  Future<List<double>> generateEmbedding(String imagePath);
}
