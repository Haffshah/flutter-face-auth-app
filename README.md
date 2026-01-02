# Flutter Face Match 🚀

A cutting-edge Flutter application showcasing high-performance **Face Recognition and Matching** using a hybrid approach combining TensorFlow Lite and Regula FaceSDK.

## ✨ Key Features

- 👤 **User Management**:
    - **Registration**: Register users with their name and face image.
    - **Editing**: Update user names or retake profile photos seamlessly.
- 📸 **Dual Capture Modes**: 
    - **Guided Camera**: Capture faces with precise guidance using Regula FaceSDK.
    - **Gallery Import**: Pick existing photos for registration.
- 🔍 **Hybrid Matching Engine**: 
    - **Fast Track**: Real-time identification using Cosine Similarity on TFLite embeddings.
    - **Verification Track**: High-precision 1:1 face verification using SDK-level matching for absolute confirmation.
- 📱 **Premium UI**: Modern dark-themed design with glassmorphism, smooth animations, and responsive layouts.
- 📂 **Local-First**: High-speed user data and embedding storage using **ObjectBox**.

## 🛠 Technical Stack

### Core Technologies
- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Database**: [ObjectBox](https://objectbox.io) (Persistence) & [Hive](https://hivedb.dev) (Settings/Cache)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it) & [Injectable](https://pub.dev/packages/injectable)

### Face Recognition Logic
- **Regula FaceSDK (`flutter_face_api`)**: 
    - Handles high-quality **Face Capture** with UI guidance.
    - Performs **1:1 Face Verification** (`matchFaces`) to resolve ambiguous matches (Threshold: 0.75+).
- **TensorFlow Lite (`tflite_flutter`)**: 
    - Runs the **MobileFaceNet** model on-device.
    - **Input**: 112x112 normalized image.
    - **Output**: 192-dimensional face embedding.
- **Inference Optimization**: Uses `compute` (Isolates) and `XNNPackDelegate` for smooth, non-blocking performance.

## 🚀 Getting Started

### Prerequisites
- Flutter Channel stable, 3.10+
- Android Studio / Xcode
- Physical device recommended (required for Camera/Face SDK functionality).

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Haffshah/flutter-face-auth-app.git
   cd flutter-face-auth-app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Boilerplate**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Localization Setup**:
   ```bash
   dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart
   ```

5. **Run the App**:
   ```bash
   flutter run
   ```

## ⚡ Development Commands

Use these commands to streamline your workflow.

### Full Rebuild & Generation
Clean, install dependencies, and regenerate all code (BuildRunner, Localization, Assets):
```bash
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs && dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart && dart pub global activate flutter_gen && fluttergen
```

### Fix Lint Issues
Apply dart fixes automatically:
```bash
dart fix --dry-run && dart fix --apply
```

### iOS Setup
Install Pods:
```bash
cd ios && pod install && cd ..
```

## 🛠 Utility Scripts & Automation

For full documentation and advanced configuration, see [**scripts/README.md**](scripts/README.md).

### 🌍 Automated Localization
**What it does**: Scans `lib/` for hardcoded strings, updates `en.json`, and generates type-safe keys to streamline internationalization.
**Full Guide**: [generate_localization/LOCALIZATION_GUIDE.md](scripts/generate_localization/LOCALIZATION_GUIDE.md)
**Command**:
```bash
dart run scripts/generate_localization/generate_localization.dart
```

### 🎨 Opacity Converter
**What it does**: Optimizes rendering performance by converting expensive `.withOpacity()` calls to `.withAlpha()`.
**Command**:
```bash
dart run scripts/opacity_converter.dart
```


## 🏗 Project Structure

- `lib/ui`: Screens, routing, and design systems.
- `lib/framework`: Controllers, Repositories (Contracts & Implementations), and Utils.
- `lib/models`: Data entities and ObjectBox schemas.
- `assets/`: 
    - `mobilefacenet.tflite`: The core AI model.
    - `lang/`: Localization files.
    - `images/` & `svgs/`: UI assets.

## 📖 How it Works (The Hybrid Approach)

1. **Capture**: Users are registered or scanned using the guided FaceSDK interface.
2. **Pre-process**: The image is resized to 112x112 and normalized to `[-1, 1]`.
3. **Embed**: The TFLite engine generates a 192-length vector (embedding) representing the face.
4. **Fast Search**: 
   - The app performs a linear search in ObjectBox.
   - It calculates **Cosine Similarity** between the new embedding and stored ones.
5. **Verify**:
   - **Score > 0.85**: Instant match confirmed via TFLite.
   - **Score 0.70 - 0.85**: The app leverages Regula FaceSDK's high-precision 1:1 check to confirm identity.
   - **Score < 0.70**: No match found.

---
Built with ❤️ by [Harsh Shah](https://github.com/Haffshah)
