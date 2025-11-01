import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/product_management/application/blocs/restaurant_product_management_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class RestaurantProductManagementScreen extends StatelessWidget {
  const RestaurantProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantProductManagementBloc(
        productManagementService: context.read(),
      )..add(const LoadRestaurantProducts()),
      child: const _RestaurantProductManagementView(),
    );
  }
}

class _RestaurantProductManagementView extends StatefulWidget {
  const _RestaurantProductManagementView();

  @override
  State<_RestaurantProductManagementView> createState() =>
      _RestaurantProductManagementViewState();
}

class _RestaurantProductManagementViewState
    extends State<_RestaurantProductManagementView> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_restaurant_owner_products_title.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: LocaleKeys.app_restaurant_owner_products_add_item.tr(),
            onPressed: () => _addNewItem(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context),

          // Category Filter
          _buildCategoryFilter(context),

          // Products List
          Expanded(
            child: BlocBuilder<RestaurantProductManagementBloc,
                RestaurantProductManagementState>(
              builder: (context, state) {
                if (state is RestaurantProductsLoading) {
                  return const AppLoadingWidget(
                    message: 'Loading products...',
                  );
                }

                if (state is RestaurantProductManagementError) {
                  return _buildErrorWidget(context, state.message);
                }

                if (state is RestaurantProductsLoaded) {
                  if (state.products.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildProductsList(context, state.products);
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    LocaleKeys.app_restaurant_owner_products_search_items.tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          context.read<RestaurantProductManagementBloc>().add(
                                const LoadRestaurantProducts(),
                              );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.isNotEmpty) {
                  // TODO: Implement search functionality
                  // context.read<RestaurantProductManagementBloc>().add(
                  //   SearchRestaurantProducts(query: value),
                  // );
                } else {
                  context.read<RestaurantProductManagementBloc>().add(
                        const LoadRestaurantProducts(),
                      );
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryBurntOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = [
      {
        'key': 'all',
        'label': LocaleKeys.app_restaurant_owner_products_all_categories.tr()
      },
      {'key': 'appetizers', 'label': 'Appetizers'},
      {'key': 'mains', 'label': 'Main Courses'},
      {'key': 'desserts', 'label': 'Desserts'},
      {'key': 'beverages', 'label': 'Beverages'},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category['label']!),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category['key']!;
                  });
                  // TODO: Filter products by category
                  context.read<RestaurantProductManagementBloc>().add(
                        const LoadRestaurantProducts(),
                      );
                }
              },
              selectedColor: AppColors.primaryBurntOrange.withOpacity(0.2),
              checkmarkColor: AppColors.primaryBurntOrange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsList(
      BuildContext context, List<Map<String, dynamic>> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product['name'] ?? 'Unnamed Product',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildAvailabilityChip(product['is_available'] ?? true),
              ],
            ),
            const SizedBox(height: 8),

            // Product Description
            if (product['description'] != null)
              Text(
                product['description'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 8),

            // Product Details
            Row(
              children: [
                Icon(Icons.attach_money,
                    size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  'SAR ${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBurntOrange,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.category,
                    size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  product['category'] ?? 'Uncategorized',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text:
                        LocaleKeys.app_restaurant_owner_products_edit_item.tr(),
                    onPressed: () => _editItem(context, product),
                    type: AppButtonType.outline,
                    size: AppButtonSize.small,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    text: LocaleKeys.app_restaurant_owner_products_delete_item
                        .tr(),
                    onPressed: () => _deleteItem(context, product),
                    type: AppButtonType.outline,
                    size: AppButtonSize.small,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    textColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityChip(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable
            ? LocaleKeys.app_restaurant_owner_products_item_available.tr()
            : LocaleKeys.app_restaurant_owner_products_item_unavailable.tr(),
        style: TextStyle(
          color: isAvailable ? Colors.green[800] : Colors.red[800],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.app_restaurant_owner_products_no_items_found.tr(),
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first menu item',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: LocaleKeys.app_restaurant_owner_products_add_new_item.tr(),
            onPressed: () => _addNewItem(context),
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading products',
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: () {
              context.read<RestaurantProductManagementBloc>().add(
                    const LoadRestaurantProducts(),
                  );
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterBottomSheet(context),
    );
  }

  Widget _buildFilterBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.app_restaurant_owner_products_filter_by_category.tr(),
            style: context.theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // Add category filter options here
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              AppButton(
                text: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(context);
                  // Apply filters logic
                },
                type: AppButtonType.primary,
                size: AppButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewItem(BuildContext context) {
    // TODO: Navigate to add item screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(LocaleKeys.app_restaurant_owner_products_add_new_item.tr()),
        backgroundColor: AppColors.primaryBurntOrange,
      ),
    );
  }

  void _editItem(BuildContext context, Map<String, dynamic> product) {
    // TODO: Navigate to edit item screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${LocaleKeys.app_restaurant_owner_products_edit_item.tr()} ${product['name']}'),
        backgroundColor: AppColors.primaryBurntOrange,
      ),
    );
  }

  void _deleteItem(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.app_restaurant_owner_products_delete_item.tr()),
        content: Text(
            LocaleKeys.app_restaurant_owner_products_delete_confirmation.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Delete',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
              context.read<RestaurantProductManagementBloc>().add(
                    DeleteRestaurantProduct(productId: product['id']),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys
                      .app_restaurant_owner_products_item_deleted
                      .tr()),
                  backgroundColor: Colors.green,
                ),
              );
            },
            type: AppButtonType.primary,
            backgroundColor: Colors.red,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }
}
