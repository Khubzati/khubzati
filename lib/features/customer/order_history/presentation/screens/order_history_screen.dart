import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/features/customer/order_history/application/blocs/order_history_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../widgets/order_search_bar.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const String routeName = '/order-history';

  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_order_history_title.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            const OrderSearchBar(),

            // Order List
            Expanded(
              child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
                builder: (context, state) {
                  if (state is OrderHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderHistoryLoaded) {
                    if (state.orders.isEmpty) {
                      return Center(
                        child: Text(
                          LocaleKeys.app_order_history_empty_message.tr(),
                          style: context.theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.receipt_long_outlined,
                              size: 40,
                              color: context.colorScheme.primary,
                            ),
                            title: Text(
                              "${LocaleKeys.app_order_history_order_id_placeholder.tr()} #${order['id'] ?? 'N/A'}",
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${LocaleKeys.app_order_history_date_placeholder.tr()}: ${order['created_at'] ?? 'N/A'}",
                                ),
                                Text(
                                  "${LocaleKeys.app_order_history_status_placeholder.tr()}: ${order['status'] ?? 'N/A'}",
                                  style: TextStyle(
                                    color: _getStatusColor(order['status']),
                                  ),
                                ),
                                Text(
                                  "${LocaleKeys.app_order_history_total_placeholder.tr()}: SAR ${order['total'] ?? '0.00'}",
                                ),
                              ],
                            ),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16),
                            isThreeLine: true,
                            onTap: () {
                              context.read<OrderHistoryBloc>().add(
                                    ViewOrderDetails(
                                        order['id']?.toString() ?? ''),
                                  );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is OrderHistoryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: context.theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<OrderHistoryBloc>().add(
                                    const FetchOrderHistory(),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      case 'processing':
      case 'in_progress':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
