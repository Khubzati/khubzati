// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:khubzati/core/extenstions/context.dart';

import '../../domain/models/search_result.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final VoidCallback onTap;
  final void Function(String, bool) onFavoriteToggle;

  const SearchResultCard({
    super.key,
    required this.result,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildImage(context),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContent(context),
                ),
                _buildFavoriteButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: result.image.isNotEmpty
            ? Image.network(
                result.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderIcon(context);
                },
              )
            : _buildPlaceholderIcon(context),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Icon(
      result.type == 'vendor' ? Icons.store : Icons.shopping_bag,
      color: colorScheme.onSurfaceVariant,
      size: 24,
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.name,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          result.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (result.rating != null) ...[
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                result.rating!.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (result.price != null) ...[
              Text(
                '${result.price!.toStringAsFixed(2)} JOD',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (result.category != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.category!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    final colorScheme = context.colorScheme;

    return IconButton(
      onPressed: () => onFavoriteToggle(result.id, !result.isFavorite),
      icon: Icon(
        result.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: result.isFavorite
            ? Colors.red
            : colorScheme.onSurface.withOpacity(0.6),
        size: 20,
      ),
    );
  }
}
