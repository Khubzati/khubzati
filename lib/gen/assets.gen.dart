/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsGifGen {
  const $AssetsGifGen();

  /// File path: assets/gif/ar_gif.gif
  AssetGenImage get arGif => const AssetGenImage('assets/gif/ar_gif.gif');

  /// List of all assets
  List<AssetGenImage> get values => [arGif];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/appIcon.svg
  String get appIcon => 'assets/images/appIcon.svg';

  /// File path: assets/images/ar_gif.gif
  AssetGenImage get arGif => const AssetGenImage('assets/images/ar_gif.gif');

  /// File path: assets/images/ar_logo.svg
  String get arLogo => 'assets/images/ar_logo.svg';

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/baker.svg
  String get baker => 'assets/images/baker.svg';

  /// File path: assets/images/closedToast.svg
  String get closedToast => 'assets/images/closedToast.svg';

  /// File path: assets/images/customAppBackground.jpg
  AssetGenImage get customAppBackground =>
      const AssetGenImage('assets/images/customAppBackground.jpg');

  /// File path: assets/images/customAppBarBackground.svg
  String get customAppBarBackground =>
      'assets/images/customAppBarBackground.svg';

  /// File path: assets/images/driver.svg
  String get driver => 'assets/images/driver.svg';

  /// File path: assets/images/editSuccessfully.svg
  String get editSuccessfully => 'assets/images/editSuccessfully.svg';

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// File path: assets/images/loginBread.jpg
  AssetGenImage get loginBreadJpg =>
      const AssetGenImage('assets/images/loginBread.jpg');

  /// File path: assets/images/loginBread.svg
  String get loginBreadSvg => 'assets/images/loginBread.svg';

  /// File path: assets/images/otp.svg
  String get otp => 'assets/images/otp.svg';

  /// File path: assets/images/prepainrBaker.svg
  String get prepainrBaker => 'assets/images/prepainrBaker.svg';

  /// File path: assets/images/resturant.svg
  String get resturant => 'assets/images/resturant.svg';

  /// File path: assets/images/success_message.svg
  String get successMessage => 'assets/images/success_message.svg';

  /// File path: assets/images/sucessfullBakery.svg
  String get sucessfullBakery => 'assets/images/sucessfullBakery.svg';

  /// File path: assets/images/toast.svg
  String get toast => 'assets/images/toast.svg';

  /// File path: assets/images/toastBread.svg
  String get toastBread => 'assets/images/toastBread.svg';

  /// File path: assets/images/toastPng.png
  AssetGenImage get toastPng =>
      const AssetGenImage('assets/images/toastPng.png');

  /// List of all assets
  List<dynamic> get values => [
    appIcon,
    arGif,
    arLogo,
    background,
    baker,
    closedToast,
    customAppBackground,
    customAppBarBackground,
    driver,
    editSuccessfully,
    icon,
    loginBreadJpg,
    loginBreadSvg,
    otp,
    prepainrBaker,
    resturant,
    successMessage,
    sucessfullBakery,
    toast,
    toastBread,
    toastPng,
  ];
}

class $AssetsSplashGen {
  const $AssetsSplashGen();

  /// File path: assets/splash/splash_ar.json
  String get splashAr => 'assets/splash/splash_ar.json';

  /// File path: assets/splash/splash_en.json
  String get splashEn => 'assets/splash/splash_en.json';

  /// List of all assets
  List<String> get values => [splashAr, splashEn];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class Assets {
  const Assets._();

  static const $AssetsGifGen gif = $AssetsGifGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSplashGen splash = $AssetsSplashGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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
