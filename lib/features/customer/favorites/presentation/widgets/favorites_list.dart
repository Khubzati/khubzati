import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../domain/models/favorite_item.dart';
import 'favorite_item_card.dart';

class FavoritesList extends StatelessWidget {
  final List<FavoriteItem> favorites;
  final ValueChanged<String> onItemTap;
  final ValueChanged<String> onItemRemoved;

  const FavoritesList({
    super.key,
    required this.favorites,
    required this.onItemTap,
    required this.onItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FavoriteItemCard(
            favorite: favorite,
            onTap: () => onItemTap(favorite.id),
            onRemove: () => onItemRemoved(favorite.id),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

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
              LocaleKeys.app_favorites_empty_title.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.app_favorites_empty_subtitle.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.app_favorites_empty_description.tr(),
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
