import 'package:flutter/material.dart';
import 'package:khubzati/core/extenstions/context.dart';

class FavoritesFilterTabs extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;

  const FavoritesFilterTabs({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          _buildFilterTab(
            context,
            'all',
            'All',
            currentFilter == 'all',
          ),
          const SizedBox(width: 8),
          _buildFilterTab(
            context,
            'vendors',
            'Vendors',
            currentFilter == 'vendors',
          ),
          const SizedBox(width: 8),
          _buildFilterTab(
            context,
            'products',
            'Products',
            currentFilter == 'products',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    String filter,
    String label,
    bool isSelected,
  ) {
    final colorScheme = context.colorScheme;
    final theme = context.theme;

    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
