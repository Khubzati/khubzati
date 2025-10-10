import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/injection.dart';
import '../services/app_preferences.dart';
import 'styles/app_button_style.dart';
import 'styles/app_colors.dart';
import 'styles/app_input_style.dart';
import 'styles/app_text_style.dart';

ThemeData get appThemeData {
  final isAr = getIt<AppPreferences>().isAr;

  return ThemeData(
    useMaterial3: true,
    fontFamily: isAr ? 'GE Dinar One' : 'Lato',
    elevatedButtonTheme: appElevatedButtonTheme,
    textTheme: appTextTheme,
    inputDecorationTheme: appInputDecorationTheme,

    // Enhanced Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryBurntOrange,
      brightness: Brightness.light,
      primary: AppColors.primaryBurntOrange,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surface,
      surfaceVariant: AppColors.surfaceVariant,
      background: AppColors.background,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      onBackground: AppColors.onBackground,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outline,
      shadow: AppColors.shadow,
    ),

    // Enhanced App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        fontFamily: isAr ? 'GE Dinar One' : 'Lato',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Enhanced Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Enhanced Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryBurntOrange,
      unselectedItemColor: AppColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Enhanced Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBurntOrange,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Enhanced Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 1,
    ),

    // Enhanced Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.onSurface,
      size: 24,
    ),

    // Enhanced Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryBurntOrange,
      linearTrackColor: AppColors.outline,
      circularTrackColor: AppColors.outline,
    ),

    // Enhanced Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryBurntOrange;
        }
        return AppColors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryBurntOrange.withOpacity(0.3);
        }
        return AppColors.outline;
      }),
    ),

    // Enhanced Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryBurntOrange;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColors.outline, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Enhanced Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryBurntOrange;
        }
        return AppColors.outline;
      }),
    ),

    // Enhanced Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryBurntOrange,
      inactiveTrackColor: AppColors.outline,
      thumbColor: AppColors.primaryBurntOrange,
      overlayColor: AppColors.primaryBurntOrange.withOpacity(0.2),
      valueIndicatorColor: AppColors.primaryBurntOrange,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Enhanced Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primaryBurntOrange,
      labelStyle: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Enhanced Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        fontFamily: isAr ? 'GE Dinar One' : 'Lato',
      ),
      contentTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        fontFamily: isAr ? 'GE Dinar One' : 'Lato',
      ),
    ),

    // Enhanced Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Enhanced Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.onSurface,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // Enhanced Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),

    // Enhanced Scaffold Background
    scaffoldBackgroundColor: AppColors.background,
  );
}
