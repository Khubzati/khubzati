import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_text_field.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/customer/vendor_listing/application/blocs/vendor_listing_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage()
class VendorListingScreen extends StatefulWidget {
  final String? categoryId;

  const VendorListingScreen({
    super.key,
    this.categoryId,
  });

  @override
  State<VendorListingScreen> createState() => _VendorListingScreenState();
}

class _VendorListingScreenState extends State<VendorListingScreen> {
  final _searchController = TextEditingController();
  String _selectedSortBy = 'rating';
  String _selectedSortOrder = 'desc';
  String _selectedPriceRange = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TODO: Load vendors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Loading vendors for category: ${widget.categoryId ?? 'all'}'),
          backgroundColor: context.colorScheme.primary,
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.app_vendor_listing_title.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context),

          // Vendor List
          Expanded(
            child: BlocBuilder<VendorListingBloc, VendorListingState>(
              builder: (context, state) {
                if (state is VendorListingLoading) {
                  return const AppLoadingWidget(
                    message: 'Loading vendors...',
                  );
                }

                if (state is VendorListingError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<VendorListingBloc>().add(
                            FetchVendorsByCategory(
                              categoryId: widget.categoryId ?? 'all',
                            ),
                          );
                    },
                  );
                }

                if (state is VendorListingLoaded ||
                    state is VendorListingFiltered) {
                  final vendors = state is VendorListingLoaded
                      ? state.vendors
                      : (state as VendorListingFiltered).vendors;

                  if (vendors.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return _buildVendorList(context, vendors, state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          AppTextField(
            controller: _searchController,
            hint: LocaleKeys.app_search_hint.tr(),
            prefixIcon: const Icon(Icons.search),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                // TODO: Implement search
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Searching for: $value'),
                    backgroundColor: context.colorScheme.primary,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),

          // Quick Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  context,
                  'Rating',
                  _selectedSortBy == 'rating'
                      ? 'High to Low'
                      : 'Sort by Rating',
                  () => _setSortBy('rating'),
                  isSelected: _selectedSortBy == 'rating',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  context,
                  'Delivery',
                  _selectedSortBy == 'delivery_time'
                      ? 'Fastest'
                      : 'Sort by Delivery',
                  () => _setSortBy('delivery_time'),
                  isSelected: _selectedSortBy == 'delivery_time',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  context,
                  'Price',
                  _selectedPriceRange == 'all' ? 'All Prices' : 'Price Range',
                  () => _showPriceFilter(),
                  isSelected: _selectedPriceRange != 'all',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, String value, VoidCallback onTap,
      {bool isSelected = false}) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorList(
    BuildContext context,
    List<Map<String, dynamic>> vendors,
    VendorListingState state,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: vendors.length +
          (state is VendorListingLoaded && !state.hasReachedMax ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == vendors.length) {
          // Load more indicator
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final vendor = vendors[index];
        return _buildVendorCard(context, vendor);
      },
    );
  }

  Widget _buildVendorCard(BuildContext context, Map<String, dynamic> vendor) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        // TODO: Navigate to vendor detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigate to vendor: ${vendor['name']}'),
            backgroundColor: context.colorScheme.primary,
          ),
        );
      },
      child: Row(
        children: [
          // Vendor Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: vendor['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      vendor['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.restaurant,
                          color: colorScheme.onSurfaceVariant,
                          size: 32,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.restaurant,
                    color: colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
          ),
          const SizedBox(width: 16),

          // Vendor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  vendor['cuisine_type'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),

                // Rating and Delivery Time
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${vendor['rating'] ?? 0.0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${vendor['delivery_time'] ?? 0} min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price Range
                Text(
                  '${vendor['price_range'] ?? '\$\$'} • ${vendor['delivery_fee'] ?? 'Free delivery'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: vendor['is_open'] == true
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              vendor['is_open'] == true ? 'Open' : 'Closed',
              style: theme.textTheme.labelSmall?.copyWith(
                color: vendor['is_open'] == true ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No vendors found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Clear Filters',
              onPressed: () {
                // TODO: Clear filters
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Clear filters'),
                    backgroundColor: context.colorScheme.primary,
                  ),
                );
              },
              type: AppButtonType.outline,
            ),
          ],
        ),
      ),
    );
  }

  void _setSortBy(String sortBy) {
    setState(() {
      _selectedSortBy = sortBy;
    });

    // TODO: Apply sort
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sorting by: $sortBy'),
        backgroundColor: context.colorScheme.primary,
      ),
    );
  }

  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPriceFilterBottomSheet(context),
    );
  }

  Widget _buildPriceFilterBottomSheet(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...['all', 'low', 'medium', 'high'].map((range) {
            return RadioListTile<String>(
              title: Text(range == 'all'
                  ? 'All Prices'
                  : '${range.toUpperCase()} Price'),
              value: range,
              groupValue: _selectedPriceRange,
              onChanged: (value) {
                setState(() {
                  _selectedPriceRange = value!;
                });
                Navigator.pop(context);

                // TODO: Apply filter
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Price range: $value'),
                    backgroundColor: context.colorScheme.primary,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(context),
    );
  }

  Widget _buildFilterBottomSheet(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Sort By
          Text(
            'Sort By',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...['rating', 'delivery_time', 'name'].map((sort) {
            return RadioListTile<String>(
              title: Text(sort == 'rating'
                  ? 'Rating'
                  : sort == 'delivery_time'
                      ? 'Delivery Time'
                      : 'Name'),
              value: sort,
              groupValue: _selectedSortBy,
              onChanged: (value) {
                setState(() {
                  _selectedSortBy = value!;
                });
              },
            );
          }),

          const SizedBox(height: 16),

          // Sort Order
          Text(
            'Sort Order',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...['asc', 'desc'].map((order) {
            return RadioListTile<String>(
              title: Text(order == 'asc' ? 'Ascending' : 'Descending'),
              value: order,
              groupValue: _selectedSortOrder,
              onChanged: (value) {
                setState(() {
                  _selectedSortOrder = value!;
                });
              },
            );
          }),

          const SizedBox(height: 24),

          // Apply Button
          AppButton(
            text: 'Apply Filters',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Apply filters
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Applying filters...'),
                  backgroundColor: context.colorScheme.primary,
                ),
              );
            },
            type: AppButtonType.primary,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
