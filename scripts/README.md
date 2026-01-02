# 🛠️ Utility Scripts & Automation Tools

Welcome to the automation hub of the **Face Match** project. This directory contains scripts designed to streamline development, optimize assets, and maintain code quality.

## 📋 Available Tools

| Tool | Type | Directory | Purpose |
| :--- | :--- | :--- | :--- |
| **Localization Generator** | Dart | `generate_localization/` | Automates internationalization (i18n) and key generation. |
| **Image Optimizer** | Bash/Dart | `image_optimization/` | Compresses images to WebP and updates code references. |
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

## 🖼️ 2. Image Optimization

**Directory**: `scripts/image_optimization/`

### 📂 File Structure & Purpose
- **`optimize_images.sh`**: A Bash script that uses `cwebp` to convert high-res PNGs into optimized WebP format.
- **`update_image_refs.dart`**: A Dart script that scans your `lib/` folder and updates all file path references (e.g., sticking `.png` -> `.webp`).
- **`check_images.sh`**: A helper script to analyze image sizes before/after optimization.
- **`IMAGE_OPTIMIZATION_GUIDE.md`**: Comprehensive guide on how to use these tools.

### ⚙️ Setup & File Placement
1.  **Input Images**: Place your raw, high-quality PNG images in `assets/project_mockup/` (or modify the script path).
2.  **Output**: The script replaces these files with optimized `.webp` versions and creates a **backup** of originals in `assets/project_mockup_backup_<date>/`.

### 🚀 Usage
Perform the optimization in two steps:

**Step 1: Compress Images**
```bash
# Make executable (first time only)
chmod +x scripts/image_optimization/optimize_images.sh

# Run optimization
./scripts/image_optimization/optimize_images.sh
```

**Step 2: Update Code References**
```bash
dart run scripts/image_optimization/update_image_refs.dart
```

[👉 **Read the Full Image Optimization Guide**](image_optimization/IMAGE_OPTIMIZATION_GUIDE.md)

---

## 🎨 3. Opacity Converter

**File**: `scripts/opacity_converter.dart`

### 📂 Purpose
This is a standalone performance utility. It scans your Flutter code for `.withOpacity(double)` calls (which can be expensive for the raster thread) and converts them to the more efficient `.withAlpha(int)` equivalent.

### ⚙️ Setup
- Just ensure you are in the project root. The script targets the `lib/` folder automatically.

### 🚀 Usage
```bash
dart run scripts/opacity_converter.dart
```




