import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../gen/translations/locale_keys.g.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../core/routes/app_router.dart';
import '../widgets/history_header_widget.dart';
import '../widgets/history_search_widget.dart';
import '../widgets/history_date_widget.dart';
import '../widgets/history_order_list_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _orderHistory = [
    {
      'id': '12347897473',
      'price': '230.50',
      'restaurant': LocaleKeys.app_history_restaurant.tr(),
      'location': LocaleKeys.app_history_location.tr(),
      'timeRange': LocaleKeys.app_history_time_range.tr(),
      'status': 'completed',
    },
    {
      'id': '12347897473',
      'price': '230.50',
      'restaurant': LocaleKeys.app_history_restaurant.tr(),
      'location': LocaleKeys.app_history_location.tr(),
      'timeRange': LocaleKeys.app_history_time_range.tr(),
      'status': 'completed',
    },
    {
      'id': '12347897473',
      'price': '230.50',
      'restaurant': LocaleKeys.app_history_restaurant.tr(),
      'location': LocaleKeys.app_history_location.tr(),
      'timeRange': LocaleKeys.app_history_time_range.tr(),
      'status': 'cancelled',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image(
              image: Assets.images.background.provider(),
              fit: BoxFit.cover,
            ),
          ),
          // Blur and subtle dark overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: const Color(0x66000000),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header with notification bell and title
                const HistoryHeaderWidget(),

                // Search bar
                HistorySearchWidget(searchController: _searchController),

                // Date
                const HistoryDateWidget(),

                // Order list
                Expanded(
                  child: HistoryOrderListWidget(
                    orderHistory: _orderHistory,
                    onOrderTap: (order) {
                      // Navigate to order details screen with history flag
                      context.router.push(OrderDetailsRoute(
                        orderId: order['id'],
                        // isHistoryOrder: true,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
