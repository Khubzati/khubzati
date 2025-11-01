import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class SearchSuggestionsList extends StatelessWidget {
  final List<String> popularSearches;
  final List<String> searchHistory;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onHistoryCleared;

  const SearchSuggestionsList({
    super.key,
    required this.popularSearches,
    required this.searchHistory,
    required this.onSuggestionTap,
    required this.onHistoryCleared,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              LocaleKeys.app_search_search_history.tr(),
              onClear: onHistoryCleared,
            ),
            const SizedBox(height: 12),
            _buildSuggestionsList(context, searchHistory),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader(
            context,
            LocaleKeys.app_search_popular_searches.tr(),
          ),
          const SizedBox(height: 12),
          _buildSuggestionsList(context, popularSearches),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onClear,
  }) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: Text(
              LocaleKeys.app_search_clear_history.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestionsList(BuildContext context, List<String> suggestions) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        return _buildSuggestionChip(context, suggestion);
      }).toList(),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String suggestion) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: () => onSuggestionTap(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              suggestion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
