import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class FavoritesEmptyState extends StatelessWidget {
  final String filter;

  const FavoritesEmptyState({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    String title;
    String subtitle;
    String description;

    switch (filter) {
      case 'vendors':
        title = 'No Favorite Vendors';
        subtitle = 'Start adding your favorite vendors';
        description =
            'Tap the heart icon on any vendor to add it to your favorites';
        break;
      case 'products':
        title = 'No Favorite Products';
        subtitle = 'Start adding your favorite products';
        description =
            'Tap the heart icon on any product to add it to your favorites';
        break;
      default:
        title = LocaleKeys.app_favorites_empty_title.tr();
        subtitle = LocaleKeys.app_favorites_empty_subtitle.tr();
        description = LocaleKeys.app_favorites_empty_description.tr();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
