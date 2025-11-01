import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'history_order_card_widget.dart';

class HistoryOrderListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orderHistory;
  final Function(Map<String, dynamic> order)? onOrderTap;

  const HistoryOrderListWidget({
    super.key,
    required this.orderHistory,
    this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: orderHistory.length,
      itemBuilder: (context, index) {
        final order = orderHistory[index];
        return HistoryOrderCardWidget(
          order: order,
          onTap: onOrderTap != null ? () => onOrderTap!(order) : null,
        );
      },
    );
  }
}
