import 'package:face_match/framework/repository/face/contract/face_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:face_match/ui/routing/stack.dart';
import 'package:face_match/ui/routing/navigation_stack_item.dart';

@injectable
class SplashController extends ChangeNotifier {
  final FaceRepository _faceRepository;

  SplashController(this._faceRepository);

  Future<void> init(WidgetRef ref) async {
    // 1. Initialize TFLite (FaceRepository)
    await _faceRepository.initialize();

    // 2. Artificial delay for branding (optional, but requested for "proper initialization")
    // Also gives time to see the splash
    await Future.delayed(const Duration(seconds: 2));

    // 3. Request Camera Permission upfront?
    // It's good UX to ask later, but for an MVP kiosk app, asking upfront is fine too.
    // Let's stick to doing it in screens to handle denials gracefully there.

    // 4. Navigate
    ref.read(navigationStackController).pushRemove(const NavigationStackItem.userList());
  }
}
