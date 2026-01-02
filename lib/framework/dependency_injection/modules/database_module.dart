import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:face_match/objectbox.g.dart'; // Will be generated

@module
abstract class DatabaseModule {
  @preResolve
  Future<Store> get store async {
    final docsDir = await getApplicationDocumentsDirectory();
    final storePath = '${docsDir.path}/objectbox';
    if (Directory(storePath).existsSync()) {
      // Optional: Logic to wipe DB if needed, but for now we keep it
    }
    return openStore(directory: storePath);
  }
}
