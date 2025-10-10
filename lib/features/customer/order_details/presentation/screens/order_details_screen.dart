import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/gen/assets.gen.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../models/order_details_model.dart';
import '../widgets/bottom_actions.dart';
import '../widgets/order_details_header.dart';
import '../widgets/order_summary_section.dart';
import '../widgets/product_cards_section.dart';
import '../widgets/totals_section.dart';

@RoutePage()
class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Mock order data - in real app, this would come from a bloc/cubit
    final order = _getMockOrderData();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          // Main content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header section
                  OrderDetailsHeader(orderId: orderId),

                  // Order summary section
                  OrderSummarySection(order: order),

                  // Product cards
                  ProductCardsSection(products: order.products),

                  // Totals section
                  TotalsSection(order: order),

                  // Bottom spacing for fixed bottom bar
                  120.verticalSpace
                ],
              ),
            ),
          ),

          // Fixed bottom actions
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomActions(order: order),
          ),
        ],
      ),
    );
  }

  // Mock data - replace with actual data from API
  OrderDetailsModel _getMockOrderData() {
    return OrderDetailsModel(
      id: orderId,
      customerName: "مطعم السروات",
      orderValue: 230.50,
      date: "10 يناير، 6 ص",
      location: "عمان، الصويفية",
      status: "مكتمل",
      products: [
        OrderProduct(
          name: "خبز توست",
          price: 1.25,
          quantity: 60,
          total: 75.00,
          imageUrl: Assets.images.toastPng.path,
        ),
        OrderProduct(
          name: "خبز عربي",
          price: 2.50,
          quantity: 20,
          total: 50.00,
          imageUrl: Assets.images.toastPng.path,
        ),
      ],
      subtotal: 225.50,
      tax: 3.00,
      delivery: 2.00,
      total: 230.50,
      paymentMethod: "Visa",
    );
  }
}
