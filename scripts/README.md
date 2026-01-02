# 🛠️ Utility Scripts & Automation Tools

Welcome to the automation hub of the **Face Match** project. This directory contains scripts designed to streamline development, optimize assets, and maintain code quality.

## 📋 Available Tools

| Tool | Type | Directory | Purpose |
| :--- | :--- | :--- | :--- |
| **Localization Generator** | Dart | `generate_localization/` | Automates internationalization (i18n) and key generation. |
| **Opacity Converter** | Dart | Root of `scripts/` | Optimizes UI performance by replacing opacity calls. |

---

## 🌍 1. Automated Localization

**Directory**: `scripts/generate_localization/`

### 📂 File Structure & Purpose
- **`generate_localization.dart`**: The main execution script. It scans your code, updates `en.json`, and triggers code generation.
- **`localization_config.json`**: Configuration file. Use this to **ignore** specific files, strings, or regex patterns that shouldn't be localized.
- **`LOCALIZATION_GUIDE.md`**: Detailed documentation and troubleshooting guide.

### ⚙️ Setup & File Placement
1.  **Source File**: Ensure your primary language file exists at `assets/lang/en.json`.
2.  **Target Code**: The script scans the `lib/` directory.

### 🚀 Usage
Run this command from the project root to generate keys and update translation files:
```bash
dart run scripts/generate_localization/generate_localization.dart
```

[👉 **Read the Full Localization Guide**](generate_localization/LOCALIZATION_GUIDE.md)

---

## 🎨 2. Opacity Converter

**File**: `scripts/opacity_converter.dart`

### 📂 Purpose
This is a standalone performance utility. It scans your Flutter code for `.withOpacity(double)` calls (which can be expensive for the raster thread) and converts them to the more efficient `.withAlpha(int)` equivalent.

### ⚙️ Setup
- Just ensure you are in the project root. The script targets the `lib/` folder automatically.

### 🚀 Usage
```bash
dart run scripts/opacity_converter.dart
```






