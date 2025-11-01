import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/order_management/application/blocs/restaurant_order_management_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class RestaurantOrderManagementScreen extends StatelessWidget {
  const RestaurantOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantOrderManagementBloc(
        orderManagementService: context.read(),
      )..add(const LoadRestaurantOrders()),
      child: const _RestaurantOrderManagementView(),
    );
  }
}

class _RestaurantOrderManagementView extends StatefulWidget {
  const _RestaurantOrderManagementView();

  @override
  State<_RestaurantOrderManagementView> createState() =>
      _RestaurantOrderManagementViewState();
}

class _RestaurantOrderManagementViewState
    extends State<_RestaurantOrderManagementView> {
  String _selectedStatus = 'all';
  String _searchQuery = '';
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
        title: Text(LocaleKeys.app_restaurant_owner_orders_title.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context),

          // Status Tabs
          _buildStatusTabs(context),

          // Orders List
          Expanded(
            child: BlocBuilder<RestaurantOrderManagementBloc,
                RestaurantOrderManagementState>(
              builder: (context, state) {
                if (state is RestaurantOrdersLoading) {
                  return const AppLoadingWidget(
                    message: 'Loading orders...',
                  );
                }

                if (state is RestaurantOrderManagementError) {
                  return _buildErrorWidget(context, state.message);
                }

                if (state is RestaurantOrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildOrdersList(context, state.orders);
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
                    LocaleKeys.app_restaurant_owner_orders_search_orders.tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          context.read<RestaurantOrderManagementBloc>().add(
                                const LoadRestaurantOrders(),
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
                  context.read<RestaurantOrderManagementBloc>().add(
                        SearchRestaurantOrders(query: value),
                      );
                } else {
                  context.read<RestaurantOrderManagementBloc>().add(
                        const LoadRestaurantOrders(),
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

  Widget _buildStatusTabs(BuildContext context) {
    final statuses = [
      {
        'key': 'all',
        'label': LocaleKeys.app_restaurant_owner_orders_all_orders.tr()
      },
      {
        'key': 'pending',
        'label': LocaleKeys.app_restaurant_owner_orders_pending.tr()
      },
      {
        'key': 'processing',
        'label': LocaleKeys.app_restaurant_owner_orders_processing.tr()
      },
      {
        'key': 'ready',
        'label': LocaleKeys.app_restaurant_owner_orders_ready.tr()
      },
      {
        'key': 'completed',
        'label': LocaleKeys.app_restaurant_owner_orders_completed.tr()
      },
      {
        'key': 'cancelled',
        'label': LocaleKeys.app_restaurant_owner_orders_cancelled.tr()
      },
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status['label']!),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedStatus = status['key']!;
                  });
                  context.read<RestaurantOrderManagementBloc>().add(
                        LoadRestaurantOrders(status: status['key']!),
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

  Widget _buildOrdersList(
      BuildContext context, List<Map<String, dynamic>> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
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
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${LocaleKeys.app_restaurant_owner_orders_order_id.tr()} ${order['id']}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order['status']),
              ],
            ),
            const SizedBox(height: 8),

            // Customer Info
            Row(
              children: [
                Icon(Icons.person,
                    size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  '${LocaleKeys.app_restaurant_owner_orders_customer.tr()}: ${order['customer_name'] ?? 'N/A'}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Order Total
            Row(
              children: [
                Icon(Icons.attach_money,
                    size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  '${LocaleKeys.app_restaurant_owner_orders_total.tr()}: SAR ${order['total_amount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Order Time
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  '${LocaleKeys.app_restaurant_owner_orders_time.tr()}: ${_formatDateTime(order['created_at'])}',
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
                    text: LocaleKeys.app_restaurant_owner_orders_view_details
                        .tr(),
                    onPressed: () => _viewOrderDetails(context, order),
                    type: AppButtonType.outline,
                    size: AppButtonSize.small,
                  ),
                ),
                const SizedBox(width: 8),
                if (order['status'] == 'pending' ||
                    order['status'] == 'processing')
                  Expanded(
                    child: AppButton(
                      text: LocaleKeys.app_restaurant_owner_orders_update_status
                          .tr(),
                      onPressed: () => _updateOrderStatus(context, order),
                      type: AppButtonType.primary,
                      size: AppButtonSize.small,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange[800]!;
        label = LocaleKeys.app_restaurant_owner_orders_pending.tr();
        break;
      case 'processing':
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue[800]!;
        label = LocaleKeys.app_restaurant_owner_orders_processing.tr();
        break;
      case 'ready':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green[800]!;
        label = LocaleKeys.app_restaurant_owner_orders_ready.tr();
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green[800]!;
        label = LocaleKeys.app_restaurant_owner_orders_completed.tr();
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red[800]!;
        label = LocaleKeys.app_restaurant_owner_orders_cancelled.tr();
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[800]!;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
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
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.app_restaurant_owner_orders_no_orders_found.tr(),
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
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
            'Error loading orders',
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
              context.read<RestaurantOrderManagementBloc>().add(
                    const LoadRestaurantOrders(),
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
            LocaleKeys.app_restaurant_owner_orders_filter_by_date.tr(),
            style: context.theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // Add date filter options here
          Text(
            LocaleKeys.app_restaurant_owner_orders_filter_by_status.tr(),
            style: context.theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // Add status filter options here
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

  void _viewOrderDetails(BuildContext context, Map<String, dynamic> order) {
    // TODO: Navigate to order details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View order details for order ${order['id']}'),
        backgroundColor: AppColors.primaryBurntOrange,
      ),
    );
  }

  void _updateOrderStatus(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => _buildStatusUpdateDialog(context, order),
    );
  }

  Widget _buildStatusUpdateDialog(
      BuildContext context, Map<String, dynamic> order) {
    return AlertDialog(
      title:
          Text(LocaleKeys.app_restaurant_owner_orders_update_order_status.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select new status for order ${order['id']}'),
          const SizedBox(height: 16),
          // Add status selection options
          ListTile(
            title: Text(LocaleKeys.app_restaurant_owner_orders_processing.tr()),
            onTap: () {
              Navigator.pop(context);
              _updateOrderStatusAction(context, order['id'], 'processing');
            },
          ),
          ListTile(
            title: Text(LocaleKeys.app_restaurant_owner_orders_ready.tr()),
            onTap: () {
              Navigator.pop(context);
              _updateOrderStatusAction(context, order['id'], 'ready');
            },
          ),
          ListTile(
            title: Text(LocaleKeys.app_restaurant_owner_orders_completed.tr()),
            onTap: () {
              Navigator.pop(context);
              _updateOrderStatusAction(context, order['id'], 'completed');
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _updateOrderStatusAction(
      BuildContext context, String orderId, String newStatus) {
    context.read<RestaurantOrderManagementBloc>().add(
          UpdateRestaurantOrderStatus(
            orderId: orderId,
            newStatus: newStatus,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(LocaleKeys.app_restaurant_owner_orders_status_updated.tr()),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateTime);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
