/// Central mapping for bread types to asset image paths.
/// Add/adjust types here and ensure the corresponding asset exists under `assets/images/`.
class BreadAssets {
  static const String defaultBreadSvg = 'assets/images/loginBread.svg';
  static const String fallbackSvg = 'assets/images/baker.svg';

  /// Known bread types list (display names or keys used in the app/state).
  static const List<String> knownTypes = <String>[
    'baguette',
    'pita',
    'toast',
    'sourdough',
    'croissant',
    'rye',
    'whole_wheat',
    'ciabatta',
    'brioche',
    'flatbread',
    'multigrain',
    'naan',
    'tortilla',
  ];

  /// Map type key -> asset path. Currently pointing to a generic bread image.
  /// Swap values to more specific assets when available.
  static const Map<String, String> typeToAsset = <String, String>{
    'baguette': defaultBreadSvg,
    'pita': defaultBreadSvg,
    'toast': defaultBreadSvg,
    'sourdough': defaultBreadSvg,
    'croissant': defaultBreadSvg,
    'rye': defaultBreadSvg,
    'whole_wheat': defaultBreadSvg,
    'ciabatta': defaultBreadSvg,
    'brioche': defaultBreadSvg,
    'flatbread': defaultBreadSvg,
    'multigrain': defaultBreadSvg,
    'naan': defaultBreadSvg,
    'tortilla': defaultBreadSvg,
  };

  /// Returns the best asset path for a given bread [type].
  /// Falls back to a generic icon if the type is unknown.
  static String assetForType(String? type) {
    if (type == null || type.trim().isEmpty) return fallbackSvg;
    final key = type.trim().toLowerCase();
    return typeToAsset[key] ?? defaultBreadSvg;
  }
}
