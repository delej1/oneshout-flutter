/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/ani.json
  String get ani => 'assets/animations/ani.json';
}

class $AssetsGoogleFontsGen {
  const $AssetsGoogleFontsGen();

  /// File path: assets/google_fonts/Poppins-Black.ttf
  String get poppinsBlack => 'assets/google_fonts/Poppins-Black.ttf';

  /// File path: assets/google_fonts/Poppins-BlackItalic.ttf
  String get poppinsBlackItalic =>
      'assets/google_fonts/Poppins-BlackItalic.ttf';

  /// File path: assets/google_fonts/Poppins-Bold.ttf
  String get poppinsBold => 'assets/google_fonts/Poppins-Bold.ttf';

  /// File path: assets/google_fonts/Poppins-BoldItalic.ttf
  String get poppinsBoldItalic => 'assets/google_fonts/Poppins-BoldItalic.ttf';

  /// File path: assets/google_fonts/Poppins-ExtraBold.ttf
  String get poppinsExtraBold => 'assets/google_fonts/Poppins-ExtraBold.ttf';

  /// File path: assets/google_fonts/Poppins-ExtraBoldItalic.ttf
  String get poppinsExtraBoldItalic =>
      'assets/google_fonts/Poppins-ExtraBoldItalic.ttf';

  /// File path: assets/google_fonts/Poppins-ExtraLight.ttf
  String get poppinsExtraLight => 'assets/google_fonts/Poppins-ExtraLight.ttf';

  /// File path: assets/google_fonts/Poppins-ExtraLightItalic.ttf
  String get poppinsExtraLightItalic =>
      'assets/google_fonts/Poppins-ExtraLightItalic.ttf';

  /// File path: assets/google_fonts/Poppins-Italic.ttf
  String get poppinsItalic => 'assets/google_fonts/Poppins-Italic.ttf';

  /// File path: assets/google_fonts/Poppins-Light.ttf
  String get poppinsLight => 'assets/google_fonts/Poppins-Light.ttf';

  /// File path: assets/google_fonts/Poppins-LightItalic.ttf
  String get poppinsLightItalic =>
      'assets/google_fonts/Poppins-LightItalic.ttf';

  /// File path: assets/google_fonts/Poppins-Medium.ttf
  String get poppinsMedium => 'assets/google_fonts/Poppins-Medium.ttf';

  /// File path: assets/google_fonts/Poppins-MediumItalic.ttf
  String get poppinsMediumItalic =>
      'assets/google_fonts/Poppins-MediumItalic.ttf';

  /// File path: assets/google_fonts/Poppins-Regular.ttf
  String get poppinsRegular => 'assets/google_fonts/Poppins-Regular.ttf';

  /// File path: assets/google_fonts/Poppins-SemiBold.ttf
  String get poppinsSemiBold => 'assets/google_fonts/Poppins-SemiBold.ttf';

  /// File path: assets/google_fonts/Poppins-SemiBoldItalic.ttf
  String get poppinsSemiBoldItalic =>
      'assets/google_fonts/Poppins-SemiBoldItalic.ttf';

  /// File path: assets/google_fonts/Poppins-Thin.ttf
  String get poppinsThin => 'assets/google_fonts/Poppins-Thin.ttf';

  /// File path: assets/google_fonts/Poppins-ThinItalic.ttf
  String get poppinsThinItalic => 'assets/google_fonts/Poppins-ThinItalic.ttf';
}

class $AssetsI18nGen {
  const $AssetsI18nGen();

  /// File path: assets/i18n/en.json
  String get en => 'assets/i18n/en.json';

  /// File path: assets/i18n/es.json
  String get es => 'assets/i18n/es.json';

  /// File path: assets/i18n/fr.json
  String get fr => 'assets/i18n/fr.json';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/apple_logo.png
  AssetGenImage get appleLogo =>
      const AssetGenImage('assets/images/apple_logo.png');

  /// File path: assets/images/bloc_logo_small.png
  AssetGenImage get blocLogoSmall =>
      const AssetGenImage('assets/images/bloc_logo_small.png');

  /// File path: assets/images/google_logo.png
  AssetGenImage get googleLogo =>
      const AssetGenImage('assets/images/google_logo.png');

  /// File path: assets/images/vgv.png
  AssetGenImage get vgv => const AssetGenImage('assets/images/vgv.png');
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const String appConfig = 'assets/app_config.yaml';
  static const $AssetsGoogleFontsGen googleFonts = $AssetsGoogleFontsGen();
  static const $AssetsI18nGen i18n = $AssetsI18nGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  String get path => _assetName;

  String get keyName => _assetName;
}
