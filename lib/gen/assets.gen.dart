// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/ic_app_logo.png
  AssetGenImage get icAppLogo =>
      const AssetGenImage('assets/images/ic_app_logo.png');

  /// File path: assets/images/ic_business_person.png
  AssetGenImage get icBusinessPerson =>
      const AssetGenImage('assets/images/ic_business_person.png');

  /// File path: assets/images/ic_refresh.png
  AssetGenImage get icRefresh =>
      const AssetGenImage('assets/images/ic_refresh.png');

  /// File path: assets/images/ic_service_women.png
  AssetGenImage get icServiceWomen =>
      const AssetGenImage('assets/images/ic_service_women.png');

  /// File path: assets/images/ic_success.png
  AssetGenImage get icSuccess =>
      const AssetGenImage('assets/images/ic_success.png');

  /// File path: assets/images/image_placeholder.png
  AssetGenImage get imagePlaceholder =>
      const AssetGenImage('assets/images/image_placeholder.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    icAppLogo,
    icBusinessPerson,
    icRefresh,
    icServiceWomen,
    icSuccess,
    imagePlaceholder,
  ];
}

class $AssetsLangGen {
  const $AssetsLangGen();

  /// File path: assets/lang/en.json
  String get en => 'assets/lang/en.json';

  /// List of all assets
  List<String> get values => [en];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/svg_add.svg
  String get svgAdd => 'assets/svgs/svg_add.svg';

  /// File path: assets/svgs/svg_back_icon.svg
  String get svgBackIcon => 'assets/svgs/svg_back_icon.svg';

  /// File path: assets/svgs/svg_check.svg
  String get svgCheck => 'assets/svgs/svg_check.svg';

  /// File path: assets/svgs/svg_check_green.svg
  String get svgCheckGreen => 'assets/svgs/svg_check_green.svg';

  /// File path: assets/svgs/svg_empty_check.svg
  String get svgEmptyCheck => 'assets/svgs/svg_empty_check.svg';

  /// File path: assets/svgs/svg_forgot_password.svg
  String get svgForgotPassword => 'assets/svgs/svg_forgot_password.svg';

  /// File path: assets/svgs/svg_hide_pasword_eye.svg
  String get svgHidePaswordEye => 'assets/svgs/svg_hide_pasword_eye.svg';

  /// File path: assets/svgs/svg_login_bg.svg
  String get svgLoginBg => 'assets/svgs/svg_login_bg.svg';

  /// File path: assets/svgs/svg_otp_verification.svg
  String get svgOtpVerification => 'assets/svgs/svg_otp_verification.svg';

  /// File path: assets/svgs/svg_password_eye.svg
  String get svgPasswordEye => 'assets/svgs/svg_password_eye.svg';

  /// File path: assets/svgs/svg_reset_pasword.svg
  String get svgResetPasword => 'assets/svgs/svg_reset_pasword.svg';

  /// List of all assets
  List<String> get values => [
    svgAdd,
    svgBackIcon,
    svgCheck,
    svgCheckGreen,
    svgEmptyCheck,
    svgForgotPassword,
    svgHidePaswordEye,
    svgLoginBg,
    svgOtpVerification,
    svgPasswordEye,
    svgResetPasword,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLangGen lang = $AssetsLangGen();
  static const String mobilefacenet = 'assets/mobilefacenet.tflite';
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();

  /// List of all assets
  static List<String> get values => [mobilefacenet];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
