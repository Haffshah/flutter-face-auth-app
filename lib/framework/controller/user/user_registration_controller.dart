import 'dart:io';
import 'package:face_match/framework/controller/user/user_list_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_face_api/flutter_face_api.dart'; // FaceSDK
import 'package:injectable/injectable.dart';
import 'package:face_match/framework/repository/face/contract/face_repository.dart';
import 'package:face_match/framework/repository/user/contract/user_repository.dart';
import 'package:face_match/models/user_entity.dart';
import 'package:face_match/models/employee_embedding.dart';
import 'package:face_match/ui/routing/stack.dart';

@injectable
class UserRegistrationController extends ChangeNotifier {
  final UserRepository _userRepository;
  final FaceRepository _faceRepository;
  // FaceSDK
  var faceSdk = FaceSDK.instance;
  bool isInitialized = true; // Temporary fix to unblock UI
  bool isProcessing = false;

  // Edit mode
  UserEntity? existingUser;

  UserRegistrationController(this._userRepository, this._faceRepository);

  Future<void> init({UserEntity? user}) async {
    existingUser = user;
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

  Future<void> onCaptureInfo(WidgetRef ref, String name, void Function(String, bool) showSnackBar) async {
    if (name.isEmpty) {
      showSnackBar('Please enter a name', true);
      return;
    }
    await _captureAndProcess(ref, name, showSnackBar);
  }

  Future<void> onGalleryImageSelected(
    WidgetRef ref,
    String name,
    String imagePath,
    void Function(String, bool) showSnackBar,
  ) async {
    if (name.isEmpty) {
      showSnackBar('Please enter a name', true);
      return;
    }
    await _processGalleryImage(ref, name, imagePath, showSnackBar);
  }

  Future<void> _processGalleryImage(
    WidgetRef ref,
    String name,
    String imagePath,
    void Function(String, bool) showSnackBar,
  ) async {
    if (!isInitialized) {
      showSnackBar('Face SDK not initialized', true);
      return;
    }
    if (isProcessing) return;

    isProcessing = true;
    notifyListeners();

    try {
      // Copy to permanent location
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'user_${DateTime.now().millisecondsSinceEpoch}.png';
      final permanentFile = await File(imagePath).copy('${appDir.path}/$fileName');

      // Generate Embedding (Real TFLite)
      final embedding = await _faceRepository.generateEmbedding(permanentFile.path);

      // Save or Update User
      final user = UserEntity(name: name, imagePath: permanentFile.path);
      if (existingUser != null) {
        user.id = existingUser!.id; // Update existing user
      }
      final userId = _userRepository.saveUser(user);

      // Save Embedding
      final employeeEmbedding = EmployeeEmbedding(userId: userId, embedding: embedding);
      _faceRepository.saveEmbedding(employeeEmbedding);

      showSnackBar(existingUser != null ? 'User Updated Successfully!' : 'User Registered Successfully!', false);

      // Navigate back
      ref.read(navigationStackController).pop();
      ref.read(userListControllerProvider).loadUsers();
    } catch (e) {
      debugPrint('Error: $e');
      showSnackBar('Error processing image: $e', true);
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> _captureAndProcess(WidgetRef ref, String name, void Function(String, bool) showSnackBar) async {
    if (!isInitialized) {
      showSnackBar('Face SDK not initialized', true);
      return;
    }
    if (isProcessing) return;

    isProcessing = true;
    notifyListeners();

    try {
      // Step 1: Capture Face using FaceSDK UI
      var captureConfig = FaceCaptureConfig(holdStillDuration: 0.5, timeout: 30.0);
      var result = await faceSdk.startFaceCapture(config: captureConfig);

      final image = result.image?.image;

      if (image == null) {
        showSnackBar('Capture cancelled or failed', true);
        return;
      }

      // Save permanent file
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'user_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('${appDir.path}/$fileName').create();
      await file.writeAsBytes(image);

      // Generate Embedding (Real TFLite)
      final embedding = await _faceRepository.generateEmbedding(file.path);

      // Save or Update User
      final user = UserEntity(name: name, imagePath: file.path);
      if (existingUser != null) {
        user.id = existingUser!.id; // Update existing user
      }
      final userId = _userRepository.saveUser(user);

      // Save Embedding
      final employeeEmbedding = EmployeeEmbedding(userId: userId, embedding: embedding);
      _faceRepository.saveEmbedding(employeeEmbedding);

      showSnackBar(existingUser != null ? 'User Updated Successfully!' : 'User Registered Successfully!', false);

      // Refresh User List
      // Since UserListController is autoDispose, it might reset, but to be sure we can trigger a reload if it's alive or rely on init.
      // However, ref.read(userListControllerProvider) will create a new one if disposed.
      // Better approach: When UserListScreen appears (pop returns), it should reload.
      // OR: ref.read(userListControllerProvider).loadUsers();

      // We will perform reload in UserListScreen on re-focus or just trigger it here if the provider is kept alive.
      // Given autoDispose, re-init in UserListScreen.initState/didChangeDependencies is key.
      // But assuming stack push/pop keeps UserListScreen alive below:

      // Force refresh if the controller is active in the background
      // ref.read(userListControllerProvider).loadUsers(); // This would require importing UserListController which causes circular dependency if not careful.
      // Instead, we can return a result or use a shared visible provider.

      // Simplest: pass true to pop

      // Navigate back
      ref.read(navigationStackController).pop();
      // We'll handle reload in UserListScreen by listning to route changes or just refresh.
      // Actually, let's just create a global provider/Stream or use a callback.

      // Or simply:
      ref.read(userListControllerProvider).loadUsers();
    } catch (e) {
      debugPrint('Error: $e');
      showSnackBar('Error capturing face: $e', true);
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}
