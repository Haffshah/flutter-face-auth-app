import 'dart:io';
import 'dart:convert';

void main() {
  print('Starting localization extraction and replacement...');

  final rootDir = Directory.current.path;
  final libDir = Directory('lib');
  final langFile = File('assets/lang/en.json');

  if (!libDir.existsSync()) {
    print('Error: lib/ directory not found in $rootDir');
    return;
  }

  // 1. Load configuration
  List<String> configIgnoredFiles = [];
  List<String> configIgnoredStrings = [];
  List<String> configIgnoredPatterns = [];

  final configFile = File('scripts/localization_config.json');
  if (configFile.existsSync()) {
    try {
      final configJson = json.decode(configFile.readAsStringSync());
      if (configJson['ignored_files'] != null) {
        configIgnoredFiles = List<String>.from(configJson['ignored_files']);
      }
      if (configJson['ignored_strings'] != null) {
        configIgnoredStrings = List<String>.from(configJson['ignored_strings']);
      }
      if (configJson['ignored_patterns'] != null) {
        configIgnoredPatterns = List<String>.from(configJson['ignored_patterns']);
      }
      print('Loaded configuration from ${configFile.path}');
    } catch (e) {
      print('Error parsing localization_config.json: $e');
    }
  }

  // 2. Load existing localization
  Map<String, dynamic> currentJson = {};
  if (langFile.existsSync()) {
    try {
      final content = langFile.readAsStringSync();
      if (content.trim().isNotEmpty) {
        currentJson = json.decode(content);
      }
    } catch (e) {
      print('Error parsing existing en.json: $e');
      return;
    }
  }

  final Map<String, String> valueToKey = {};
  currentJson.forEach((key, value) {
    if (value is String) {
      valueToKey[value] = key;
    }
  });

  // 2. Define Ignore Patterns
  final List<RegExp> ignorePatterns = [
    RegExp(r'^\d{4}-\d{2}-\d{2}$'),
    RegExp(r'^\d{2}-\d{2}-\d{4}$'),
    RegExp(r'^\d{2}/\d{2}/\d{4}$'),
    RegExp(r'^\d{2}-\d{2}-\d{2}$'),
    RegExp(r'^\d{4}/\d{2}/\d{2}$'),
    RegExp(r'^\d{8}$'),
    RegExp(r'^\d{4}\.\d{2}\.\d{2}$'),
    RegExp(r'^\d{1,2}\s+[a-zA-Z]{3,}\s+\d{4}$'),
    RegExp(r'^[a-zA-Z]{3,}\s+\d{1,2},?\s+\d{4}$'),
    RegExp(r'^\d{1,2}\s+[a-zA-Z]{3,}$'),
    RegExp(r'^[a-zA-Z]{3,}\s+\d{4}$'),
    RegExp(r'^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}(:\d{2})?(\.\d+)?(Z)?$'),
    RegExp(r'^\d{2}:\d{2}(:\d{2})?$'),
    RegExp(r'^\d{1,2}:\d{2}\s?(AM|PM|am|pm)$'),
    RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.*$'),
    RegExp(r'^[a-zA-Z]+,\s+\d{1,2}\s+[a-zA-Z]+\s+\d{4}$'),
    RegExp(r'^[a-zA-Z]+,\s+[a-zA-Z]+\s+\d{1,2}(,\s+\d{4})?$'),
    RegExp(r'^(Today|Yesterday|Tomorrow|Just now)$', caseSensitive: false),
    RegExp(r'^\d+\s+(minutes|hours|days|weeks|months|years)\s+ago$'),
    RegExp(r'^(Week|W)\s?\d{2}.*$'),
    RegExp(r'^Q[1-4].*$'),
    RegExp(r'^FY\s?\d{2,4}.*$'),
    RegExp(r'^[\₹\$\%\&\(\)\/\{\}\\<\>\?\;\:\+\_\-\=\*\^\#\@\!\s\d\.]+$'),
    RegExp(r'^[\₹\$\%\&\(\)\/\{\}\\<\>\?\;\:\+\_\-\=\*\^\#\@\!]+$'),
    RegExp(r'^https?://'),
    RegExp(r'^assets/'),
    RegExp(r'^package:'),
    RegExp(r'^lib/'),

    // Date Format Patterns
    RegExp(r'dd MMM yyyy'),
    RegExp(r'h:mm\s?a'),
    RegExp(r'HH:mm'),
    RegExp(r'yyyy'),
    RegExp(r'MMM d'),
  ];

  final List<String> exactIgnore = ['Unix timestamp'];
  exactIgnore.addAll(configIgnoredStrings);
  // Add config patterns
  for (var p in configIgnoredPatterns) {
    try {
      ignorePatterns.add(RegExp(p));
    } catch (e) {
      print('Invalid regex in config: $p');
    }
  }

  // Patterns
  // 1. Text('string') or Text("string")
  final textPattern = RegExp(r"Text\(\s*(?:'([^'\\]*(?:\\.[^'\\]*)*)'|" + '"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")');
  // 2. Named Args including buttonText
  final namedArgPattern = RegExp(
    r"(?:text|hintText|labelText|errorText|label|title|subtitle|tooltip|message|semanticLabel|buttonText|description)\s*:\s*(?:'([^'\\]*(?:\\.[^'\\]*)*)'|" +
        '"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")',
  );
  // 3. Return string literals (validation)
  final returnPattern = RegExp(r"return\s+(?:'([^'\\]*(?:\\.[^'\\]*)*)'|" + '"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")');
  // 4. Null coalescing strings: ?? 'string'
  final nullCoalescingPattern = RegExp(r"\?\?\s*(?:'([^'\\]*(?:\\.[^'\\]*)*)'|" + '"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")');

  int totalFound = 0;
  int totalAdded = 0;
  int totalIgnored = 0;
  int totalReplaced = 0;

  void processFile(File file) {
    String content = file.readAsStringSync();
    List<Replacement> replacements = [];

    // Combine matches
    final allMatches = [
      ...textPattern.allMatches(content).map((m) => MatchInfo(m, true)),
      ...namedArgPattern.allMatches(content).map((m) => MatchInfo(m, false)),
      ...returnPattern.allMatches(content).map((m) => MatchInfo(m, false)),
      ...nullCoalescingPattern.allMatches(content).map((m) => MatchInfo(m, false)),
    ];

    for (final info in allMatches) {
      final match = info.match;
      String? rawString = match.group(1) ?? match.group(2);

      if (rawString == null || rawString.isEmpty) continue;

      if (rawString.contains(r'$')) continue; // Ignore interpolation

      String processed = rawString;
      if (match.group(1) != null) {
        processed = processed.replaceAll(r"\'", "'");
      } else {
        processed = processed.replaceAll(r'\"', '"');
      }

      totalFound++;

      // Filters
      if (processed.trim().isEmpty || processed.length < 2) {
        totalIgnored++;
        continue;
      }
      bool ignore = false;
      for (final r in ignorePatterns) {
        if (r.hasMatch(processed)) {
          ignore = true;
          break;
        }
      }
      if (exactIgnore.contains(processed)) ignore = true;
      if (processed.contains('/')) {
        if (processed.startsWith('assets/') || processed.startsWith('lib/') || processed.contains('.')) {
          if (!processed.contains(' ')) ignore = true;
        }
      }

      if (ignore) {
        totalIgnored++;
        continue;
      }

      // Generate Key
      String key;
      if (valueToKey.containsKey(processed)) {
        key = valueToKey[processed]!;
      } else {
        key = generateKey(processed);
        // Check Conflict
        if (currentJson.containsKey(key)) {
          if (currentJson[key] != processed) {
            print('[Conflict] Key "$key" exists with different value. Skipping "$processed"');
            continue;
          }
        } else {
          currentJson[key] = processed;
          valueToKey[processed] = key;
          totalAdded++;
          print('[Added] "$key": "$processed"');
        }
      }

      // Calculate string literal range for replacement
      int contentLen = (match.group(1) ?? match.group(2))!.length;
      int literalLen = contentLen + 2;
      int stringEnd = match.end;
      int stringStart = stringEnd - literalLen;

      // Safety check: verify content matches file (optional but good)
      // String check = content.substring(stringStart, stringEnd);
      // if (!check.contains(processed)) print('Warning: Range mismatch for $processed');

      // Add Replacement
      String replacementCode = 'LocaleKeys.$key.localized';
      replacements.add(Replacement(stringStart, stringEnd, replacementCode));
      totalReplaced++;

      // Check for const if it is a Text widget match
      if (info.isTextWidget) {
        // Check preceding text for 'const'
        int searchPos = match.start - 1;
        while (searchPos >= 0 &&
            (content[searchPos] == ' ' || content[searchPos] == '\t' || content[searchPos] == '\n')) {
          searchPos--;
        }
        if (searchPos >= 4) {
          String check = content.substring(searchPos - 4, searchPos + 1);
          if (check == 'const') {
            bool distinct = true;
            if (searchPos - 5 >= 0) {
              String charBefore = content[searchPos - 5];
              if (RegExp(r'[a-zA-Z0-9_]').hasMatch(charBefore)) {
                distinct = false;
              }
            }
            if (distinct) {
              replacements.add(Replacement(searchPos - 4, searchPos + 1, ''));
            }
          }
        }
      }
    }

    // Apply replacements
    if (replacements.isNotEmpty) {
      // Sort desc based on start index
      replacements.sort((a, b) => b.start.compareTo(a.start));

      String newContent = content;
      bool changed = false;
      for (final r in replacements) {
        newContent = newContent.replaceRange(r.start, r.end, r.text);
        changed = true;
      }

      if (changed) {
        newContent = addImports(newContent);
        file.writeAsStringSync(newContent);
        print('Modified ${file.path}');
      }
    }
  }

  // 4. Run Scan
  final files = libDir.listSync(recursive: true).whereType<File>();
  for (final file in files) {
    if (file.path.endsWith('.dart') &&
        !file.path.endsWith('.g.dart') &&
        !file.path.endsWith('.freezed.dart') &&
        !file.path.contains('generated')) {
      // Config ignored files check
      bool skip = false;
      for (final ignoredPath in configIgnoredFiles) {
        if (file.path.contains(ignoredPath)) {
          skip = true;
          break;
        }
      }
      if (skip) continue;

      processFile(file);
    }
  }

  // 5. Save JSON
  if (totalAdded > 0) {
    const encoder = JsonEncoder.withIndent('  ');
    langFile.writeAsStringSync(encoder.convert(currentJson));
    print('Updated ${langFile.path}');
  }

  print('Summary:');
  print('  Found Strings: $totalFound');
  print('  Added:         $totalAdded');
  print('  Ignored:       $totalIgnored');
  print('  Replaced:      $totalReplaced (in code)');

  // 6. Run Build Commands
  runBuildCommands();
}

void runBuildCommands() {
  print('\n--------------------------------------------------');
  print('Running Build Commands...');
  print('--------------------------------------------------');

  final commands = [
    'flutter clean',
    'flutter pub get',
    'dart run build_runner build --delete-conflicting-outputs',
    'dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart',
    'dart pub global activate flutter_gen',
    'fluttergen',
  ];

  for (final command in commands) {
    print('Running: $command');
    final parts = command.split(' ');
    final executable = parts[0];
    final arguments = parts.sublist(1);

    // Run synchronously to ensure order
    final result = Process.runSync(executable, arguments, runInShell: true);

    // Print output
    if (result.stdout.toString().trim().isNotEmpty) {
      print(result.stdout);
    }
    if (result.stderr.toString().trim().isNotEmpty) {
      // Some tools output to stderr for info (like flutter pub get), so we just print it.
      print(result.stderr);
    }

    if (result.exitCode != 0) {
      print('Command failed with exit code ${result.exitCode}. Stopping execution.');
      exit(result.exitCode);
    }
  }
  print('All commands executed successfully.');
}

String addImports(String content) {
  bool hasUtils = content.contains('string_extension.dart');
  bool hasKeys = content.contains('app_strings.g.dart');

  if (hasUtils && hasKeys) return content;

  int lastImportEnd = content.lastIndexOf('import ');
  if (lastImportEnd != -1) {
    int lineEnd = content.indexOf(';', lastImportEnd);
    if (lineEnd != -1) {
      String existing = content.substring(0, lineEnd + 1);
      String remainder = content.substring(lineEnd + 1);

      StringBuffer insertions = StringBuffer();
      if (!hasUtils)
        insertions.writeln("\nimport 'package:face_match/framework/utils/extension/string_extension.dart';");
      if (!hasKeys) insertions.writeln("import 'package:face_match/ui/utils/theme/app_strings.g.dart';");

      return existing + insertions.toString() + remainder;
    }
  } else {
    StringBuffer insertions = StringBuffer();
    if (!hasUtils) insertions.writeln("import 'package:face_match/framework/utils/extension/string_extension.dart';");
    if (!hasKeys) insertions.writeln("import 'package:face_match/ui/utils/theme/app_strings.g.dart';");
    return insertions.toString() + content;
  }
  return content;
}

String generateKey(String text) {
  String cleaned = text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  List<String> words = cleaned.split(RegExp(r'\s+'));
  StringBuffer sb = StringBuffer();
  sb.write('key');
  for (var word in words) {
    if (word.isEmpty) continue;
    sb.write(capitalize(word));
  }
  return sb.toString();
}

String capitalize(String s) {
  if (s.isEmpty) return '';
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class Replacement {
  final int start;
  final int end;
  final String text;
  Replacement(this.start, this.end, this.text);
}

class MatchInfo {
  final Match match;
  final bool isTextWidget;
  MatchInfo(this.match, this.isTextWidget);
}
