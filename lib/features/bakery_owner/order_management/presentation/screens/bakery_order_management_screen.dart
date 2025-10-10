import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/homepage_header.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'dart:ui';

// TODO: Implement BakeryOrderManagementBloc for state management and API calls
// TODO: Implement UI for Listing Orders (with status updates, view details)
// TODO: Implement navigation to Order Detail Screen for vendors

class BakeryOrderManagementScreen extends StatelessWidget {
  static const String routeName = '/bakery-owner-order-management';

  const BakeryOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch orders using BakeryOrderManagementBloc
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
          SafeArea(
            child: Column(
              children: [
                // Header
                HomepageHeader(
                  title:
                      LocaleKeys.app_bakery_owner_order_management_title.tr(),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // TODO: Implement Search Bar and Filter Options
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.6)),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  LocaleKeys
                                      .app_bakery_owner_order_management_order_id_placeholder
                                      .tr(),
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: context.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // TODO: Implement Orders List (ListView.builder with OrderCard)
                        // Placeholder for orders list
                        Expanded(
                          child: ListView.builder(
                            itemCount: 10, // Replace with actual orders count
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                child: ListTile(
                                  title: Text(
                                      "${LocaleKeys.app_bakery_owner_order_management_customer_name_placeholder.tr()}: Customer ${index + 1}"),
                                  subtitle: Text(
                                      "${LocaleKeys.app_bakery_owner_order_management_order_status_placeholder.tr()}: Pending"),
                                  trailing:
                                      Text("SAR ${100 + (index * 25)}.00"),
                                  onTap: () {
                                    // TODO: Navigate to order details
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
