import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:face_match/models/employee_embedding.dart';
import 'package:face_match/objectbox.g.dart';
import 'package:face_match/framework/repository/face/contract/face_repository.dart';

@LazySingleton(as: FaceRepository)
class FaceRepositoryImpl implements FaceRepository {
  final Store _store;
  late final Box<EmployeeEmbedding> _box;

  Interpreter? _interpreter;
  bool _isInitialized = false;

  FaceRepositoryImpl(this._store) {
    _box = _store.box<EmployeeEmbedding>();
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final options = InterpreterOptions();
      if (Platform.isAndroid) {
        options.addDelegate(XNNPackDelegate());
      }
      // Load model from assets
      _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite', options: options);
      _isInitialized = true;
      debugPrint('✅ TFLite Interpreter initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize TFLite: $e');
      // In production, might want to rethrow or handle gracefully
    }
  }

  @override
  int saveEmbedding(EmployeeEmbedding item) {
    return _box.put(item);
  }

  // Vector Search (Linear fallback until HNSW syntax is confirmed fixed)
  @override
  List<EmployeeEmbedding> search(List<double> queryVector, {int topK = 10}) {
    // Returning all for controller-side cosine similarity (Brute force vector search)
    // This guarantees working MVP.
    return _box.getAll();
  }

  // Real TFLite implementation
  @override
  Future<List<double>> generateEmbedding(String imagePath) async {
    if (!_isInitialized) await initialize();
    if (_interpreter == null) throw Exception('Interpreter is null');

    final imageBytes = await File(imagePath).readAsBytes();
    return _computeEmbedding(imageBytes);
  }

  Future<List<double>> _computeEmbedding(Uint8List imageBytes) async {
    return await compute(_preprocessAndRun, [_interpreter!.address, imageBytes]);
  }

  // Static function for isolate
  static Future<List<double>> _preprocessAndRun(List<dynamic> args) async {
    final int interpreterAddress = args[0];
    final Uint8List imageBytes = args[1];

    final interpreter = Interpreter.fromAddress(interpreterAddress);

    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception('Failed to decode image');

    // Resize to 112x112
    img.Image resizedImage = img.copyResize(originalImage, width: 112, height: 112);

    // Normalize to [-1, 1]
    var input = List.generate(1, (i) => List.generate(112, (y) => List.generate(112, (x) => List.filled(3, 0.0))));

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = (pixel.r - 127.5) / 128.0;
        input[0][y][x][1] = (pixel.g - 127.5) / 128.0;
        input[0][y][x][2] = (pixel.b - 127.5) / 128.0;
      }
    }

    // Output buffer
    var output = List.filled(1 * 192, 0.0).reshape([1, 192]);

    // Run inference
    interpreter.run(input, output);

    return List<double>.from(output[0]);
  }
}
