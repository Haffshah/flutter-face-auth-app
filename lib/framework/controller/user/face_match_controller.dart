import 'dart:io';
import 'dart:math' as math;

import 'package:face_match/framework/repository/face/contract/face_repository.dart';
import 'package:face_match/framework/repository/user/contract/user_repository.dart';
import 'package:face_match/models/employee_embedding.dart';
import 'package:face_match/models/user_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_face_api/flutter_face_api.dart'; // FaceSDK
import 'package:injectable/injectable.dart';

@injectable
class FaceMatchController extends ChangeNotifier {
  final UserRepository _userRepository;
  final FaceRepository _faceRepository;

  var faceSdk = FaceSDK.instance;
  bool isInitialized = false;
  bool isProcessing = false;

  UserEntity? matchedUser;
  double? confidence;

  FaceMatchController(this._userRepository, this._faceRepository);

  Future<void> init() async {
    await _faceRepository.initialize(); // TFLite
    // Init FaceSDK
    var (success, error) = await faceSdk.initialize();
    if (!success) {
      debugPrint('FaceSDK Init Failed: ${error?.message}');
    } else {
      isInitialized = true;
      debugPrint('FaceSDK Initialized');
    }
    notifyListeners();
  }

  Future<void> onScan(void Function(String, bool) showSnackBar) async {
    if (!isInitialized) return;
    if (isProcessing) return;

    isProcessing = true;
    matchedUser = null;
    confidence = null;
    notifyListeners();

    try {
      // Step 1: Capture Face using FaceSDK UI (or Liveness)
      // Reference uses startLiveness or startFaceCapture
      // Using faceCapture for standard flow
      var captureConfig = FaceCaptureConfig(holdStillDuration: 0.5, timeout: 30.0);
      var result = await faceSdk.startFaceCapture(config: captureConfig);

      final image = result.image?.image;
      if (image == null) {
        showSnackBar('Capture cancelled', true);
        return;
      }

      // Save temp file for TFLite
      final directory = await Directory.systemTemp.createTemp();
      final File file = await File('${directory.path}/temp_probe.png').create();
      await file.writeAsBytes(image);

      // Step 2: Generate embedding (TFLite)
      final embedding = await _faceRepository.generateEmbedding(file.path);

      // Step 3: Fast Search (ObjectBox/HNSW/Linear)
      // Reference: Hybrid Matching
      final allEmbeddings = _faceRepository.search(embedding); // Currently returns all

      double maxScore = 0.0;
      EmployeeEmbedding? bestMatch;

      for (final emp in allEmbeddings) {
        final score = _cosineSimilarity(embedding, emp.embedding);
        if (score > maxScore) {
          maxScore = score;
          bestMatch = emp;
        }
      }

      // Step 4: Hybrid Verification Logic
      // Thresholds: Early Exit > 0.95, Fast > 0.85, Verify > 0.80 (if ambiguous)

      if (bestMatch != null && maxScore > 0.85) {
        // Fast Match
        matchedUser = _userRepository.getUser(bestMatch.userId);
        confidence = maxScore;
        showSnackBar('Match Found (Fast): ${matchedUser?.name} (${(maxScore * 100).toStringAsFixed(1)}%)', false);
      } else if (bestMatch != null && maxScore > 0.70) {
        // Candidate for SDK Verification
        // SDK Verify
        showSnackBar('Verifying candidate...', false);
        final verified = await _verifyWithSdk(image, bestMatch.userId); // Load saved image of user

        if (verified) {
          matchedUser = _userRepository.getUser(bestMatch.userId);
          confidence = 0.99; // SDK confirmed
          showSnackBar('Match Confirmed (SDK): ${matchedUser?.name}', false);
        } else {
          showSnackBar('Verification Failed (Score: ${(maxScore * 100).toStringAsFixed(1)}%)', true);
        }
      } else {
        showSnackBar('No match found', true);
      }
    } catch (e) {
      showSnackBar('Error: $e', true);
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  // Future<bool> _verifyWithSdk(Uint8List probeImage, int userId) async {
  //    // Load candidate image
  //    final user = _userRepository.getUser(userId);
  //    if (user == null) return false;
  //
  //    final userImageBytes = await File(user.imagePath).readAsBytes();
  //
  //    final probe = MatchFacesImage(probeImage, ImageType.LIVE);
  //    final candidate = MatchFacesImage(userImageBytes, ImageType.PRINTED);
  //
  //    final request = MatchFacesRequest([probe, candidate]);
  //    final response = await faceSdk.matchFaces(request);
  //
  //    final split = await faceSdk.splitComparedFaces(response.results, 0.75);
  //    return split.matchedFaces.isNotEmpty;
  // }
  //
  // Writing real implementation:

  Future<bool> _verifyWithSdk(Uint8List probeImage, int userId) async {
    final user = _userRepository.getUser(userId);
    if (user == null) return false;

    final userImageBytes = await File(user.imagePath).readAsBytes();

    final probe = MatchFacesImage(probeImage, ImageType.LIVE);
    final candidate = MatchFacesImage(userImageBytes, ImageType.PRINTED);

    final request = MatchFacesRequest([probe, candidate]);
    final response = await faceSdk.matchFaces(request);

    // Simple highest similarity check
    double paramsScore = 0.0;
    if (response.results.isNotEmpty) {
      for (var res in response.results) {
        if (res.similarity > paramsScore) {
          paramsScore = res.similarity;
        }
      }
    }

    return paramsScore > 0.75;
  }

  double _cosineSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != v2.length) return 0.0;
    double dot = 0.0;
    double mag1 = 0.0;
    double mag2 = 0.0;
    for (int i = 0; i < v1.length; i++) {
      dot += v1[i] * v2[i];
      mag1 += v1[i] * v1[i];
      mag2 += v2[i] * v2[i];
    }
    if (mag1 == 0 || mag2 == 0) return 0.0;
    return dot / (math.sqrt(mag1) * math.sqrt(mag2));
  }
}
