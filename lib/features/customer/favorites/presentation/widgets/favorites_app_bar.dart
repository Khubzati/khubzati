import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClearAll;

  const FavoritesAppBar({
    super.key,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppBar(
      title: Text(
        LocaleKeys.app_favorites_title.tr(),
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'clear_all':
                onClearAll();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(
                    Icons.clear_all,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.app_favorites_clear_all.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
