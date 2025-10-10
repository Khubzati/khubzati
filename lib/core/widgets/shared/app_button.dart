import 'package:flutter/material.dart';
import 'package:khubzati/core/extenstions/context.dart';

enum AppButtonType { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final textStyle = _getTextStyle(context);
    final height = _getHeight();

    Widget buttonChild = _buildButtonChild(textStyle);

    if (isFullWidth) {
      buttonChild = SizedBox(
        width: double.infinity,
        height: height,
        child: buttonChild,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: buttonChild,
    );
  }

  Widget _buildButtonChild(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: _getHeight() * 0.6,
        width: _getHeight() * 0.6,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: textStyle.fontSize),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final colorScheme = context.colorScheme;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: textColor ?? colorScheme.onPrimary,
          elevation: 4,
          shadowColor: colorScheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
          ),
          padding: _getPadding(),
          animationDuration: const Duration(milliseconds: 200),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withOpacity(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withOpacity(0.05);
            }
            return null;
          }),
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          foregroundColor: textColor ?? colorScheme.onSecondary,
          elevation: 4,
          shadowColor: colorScheme.secondary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
          ),
          padding: _getPadding(),
          animationDuration: const Duration(milliseconds: 200),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withOpacity(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withOpacity(0.05);
            }
            return null;
          }),
        );
      case AppButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? colorScheme.primary,
          elevation: 0,
          side: BorderSide(
            color: backgroundColor ?? colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
          ),
          padding: _getPadding(),
          animationDuration: const Duration(milliseconds: 200),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withOpacity(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withOpacity(0.05);
            }
            return null;
          }),
        );
      case AppButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? colorScheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          padding: _getPadding(),
          animationDuration: const Duration(milliseconds: 200),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withOpacity(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withOpacity(0.05);
            }
            return null;
          }),
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    switch (size) {
      case AppButtonSize.small:
        return theme.textTheme.labelMedium?.copyWith(
              color: textColor ??
                  (type == AppButtonType.outline || type == AppButtonType.text
                      ? colorScheme.primary
                      : colorScheme.onPrimary),
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle();
      case AppButtonSize.medium:
        return theme.textTheme.labelLarge?.copyWith(
              color: textColor ??
                  (type == AppButtonType.outline || type == AppButtonType.text
                      ? colorScheme.primary
                      : colorScheme.onPrimary),
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle();
      case AppButtonSize.large:
        return theme.textTheme.titleMedium?.copyWith(
              color: textColor ??
                  (type == AppButtonType.outline || type == AppButtonType.text
                      ? colorScheme.primary
                      : colorScheme.onPrimary),
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle();
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }
}
