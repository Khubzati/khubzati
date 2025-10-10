import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBurntOrange = Color(0xFFC25E3E);
  static const Color secondaryLightCream = Color(0xFFF9F2E4);
  static const Color creamColor = Color(0xFFF8F2E8);
  static const Color textDarkBrown = Color(0xFF67392A);
  static const Color tertiaryOliveGreen = Color(0xFF779B38);
  static const Color pageBackground = Color(0xFFF9F2E4);

  static const Color primary = Color(0xFF6B46C1); // Modern purple
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF553C9A);

  // Secondary Colors
  static const Color secondary = Color(0xFFF59E0B); // Amber
  static const Color secondaryLight = Color(0xFFFCD34D);
  static const Color secondaryDark = Color(0xFFD97706);

  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Emerald
  static const Color accentLight = Color(0xFF34D399);
  static const Color accentDark = Color(0xFF059669);

  // Neutral Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color background = Color(0xFFF1F5F9);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color onBackground = Color(0xFF0F172A);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border and Outline
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFF1F5F9);

  // Shadow Colors
  static const Color shadow = Color(0xFF000000);
  static const Color shadowLight = Color(0x1A000000);

  // Legacy Colors (for backward compatibility)
  // static const Color primaryBurntOrange = primary;
  // static const Color secondaryLightCream = surfaceVariant;
  // static const Color creamColor = background;
  // static const Color textDarkBrown = onSurface;
  // static const Color tertiaryOliveGreen = accent;
  // static const Color pageBackground = background;

  // Gradient Colors
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> secondaryGradient = [secondary, secondaryLight];
  static const List<Color> accentGradient = [accent, accentLight];
  static const List<Color> surfaceGradient = [surface, surfaceVariant];
}
