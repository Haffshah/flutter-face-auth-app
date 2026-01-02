#!/usr/bin/env dart

/// Script to update image references from .png to .webp in Dart files
/// Run this after converting images to WebP format

import 'dart:io';

void main() async {
  print('🔄 Updating image references from .png to .webp...\n');

  // Find all Dart files in the project
  final libDir = Directory('lib');
  final dartFiles = await libDir
      .list(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();

  int filesModified = 0;
  int referencesUpdated = 0;

  for (final file in dartFiles) {
    final content = await file.readAsString();
    final originalContent = content;

    // Replace .png with .webp in asset paths
    final updatedContent = content.replaceAllMapped(
      RegExp(r"'assets/project_mockup/([^']+)\.png'"),
      (match) {
        referencesUpdated++;
        return "'assets/project_mockup/${match.group(1)}.webp'";
      },
    );

    // Also handle double quotes
    final finalContent = updatedContent.replaceAllMapped(
      RegExp(r'"assets/project_mockup/([^"]+)\.png"'),
      (match) {
        referencesUpdated++;
        return '"assets/project_mockup/${match.group(1)}.webp"';
      },
    );

    if (finalContent != originalContent) {
      await file.writeAsString(finalContent);
      filesModified++;
      print('✓ Updated: ${file.path}');
    }
  }

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 Update Summary');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Files modified: $filesModified');
  print('References updated: $referencesUpdated');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  if (filesModified > 0) {
    print('✅ All image references updated to .webp!');
    print('\n⚠️  Next steps:');
    print('1. Run: flutter clean');
    print('2. Run: flutter build web');
    print('3. Test your website\n');
  } else {
    print('ℹ️  No .png references found in Dart files.');
  }
}
