import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

import '../../domain/models/search_result.dart';
import 'search_result_card.dart';

class SearchResultsList extends StatelessWidget {
  final List<SearchResult> results;
  final String query;
  final bool hasMore;
  final ValueChanged<String> onResultTap;
  final void Function(String, bool) onFavoriteToggle;
  final VoidCallback onLoadMore;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.query,
    required this.hasMore,
    required this.onResultTap,
    required this.onFavoriteToggle,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildResultsHeader(context),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == results.length) {
                return _buildLoadMoreButton(context);
              }

              final result = results[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SearchResultCard(
                  result: result,
                  onTap: () => onResultTap(result.id),
                  onFavoriteToggle: onFavoriteToggle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            LocaleKeys.app_search_search_results.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${results.length}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          if (query.isNotEmpty)
            Text(
              '"$query"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: onLoadMore,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            LocaleKeys.app_common_load_more.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
