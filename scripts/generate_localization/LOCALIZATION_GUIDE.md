# Keyify

This directory contains `generate_localization.dart`, a powerful script that automates the process of internationalizing your Flutter app.

## 🚀 Features

*   **Automated Extraction**: Scans `lib/` for hardcoded UI strings in `Text widgets`, named arguments (e.g., `hintText`, `label`), and validators.
*   **Smart Filtering**: Automatically ignores dates, times, numbers, symbols, and developer-defined patterns.
*   **Key Generation**: Converts "Hello World" -> `keyHelloWorld` automatically.
*   **Code Replacement**: Replaces original strings in your Dart code with `LocaleKeys.keyName.localized` and adds necessary imports (`string_extension.dart`, `app_strings.g.dart`).
*   **Dynamic Package Detection**: Automatically detects your package name from `pubspec.yaml` to ensure correct imports.
*   **Conflict Prevention**: Checks for existing keys in `en.json` to prevent duplicates.
*   **Ignored Strings Logging**: Outputs a sorted list of all ignored strings to the console for transparency.
*   **Auto-Build**: Automatically runs `codogen` commands after updating strings.

## 🛠 Configuration

You can customize what the script specifically ignores by editing **`localization_config.json`** in this folder.

### `localization_config.json` Options

| Field | Description | Example |
| :--- | :--- | :--- |
| **`ignored_files`** | List of file paths or substrings to skip entirely. | `["lib/ui/debug/", "mock_data.dart"]` |
| **`ignored_strings`** | List of exact strings to specificially ignore. | `["FaceSDK", "v1.0.0"]` |
| **`ignored_patterns`** | List of Regex patterns to ignore. | `["^User_\\d+"]` |

**Example Config:**

```json
{
  "ignored_files": [
    "lib/ui/utils/theme/app_strings.g.dart",
    "lib/generated/"
  ],
  "ignored_strings": [
    "Unix timestamp",
    "yyyy-MM-dd"
  ],
  "ignored_patterns": [
    "^\\d+$" 
  ]
}
```

## ▶️ How to Run

Execute the script from the project root:

```bash
dart run generate_localization/generate_localization.dart
```

The script will:
1.  Read `assets/lang/en.json`.
2.  Scan all `.dart` files in `lib/` (skipping ignored ones).
3.  Update `en.json` with new strings.
4.  Modify your `.dart` files to use the new keys.
5.  Run `flutter clean`, `build_runner`, `easy_localization`, `dart pub global activate flutter_gen`, and `fluttergen` automatically.

## 🛑 Ignoring Files

If you have files that should **never** be scanned (e.g., internal debug tools, generated code usually skipped automatically but sometimes not), add their path or partial name to `ignored_files` in `localization_config.json`.
