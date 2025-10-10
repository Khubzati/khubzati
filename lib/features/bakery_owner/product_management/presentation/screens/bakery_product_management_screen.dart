import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/homepage_header.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'dart:ui';

// TODO: Implement BakeryProductManagementBloc for state management and API calls
// TODO: Implement UI for Listing Products (with edit/delete options)
// TODO: Implement navigation to Add/Edit Product Screen

class BakeryProductManagementScreen extends StatelessWidget {
  static const String routeName = '/bakery-owner-product-management';

  const BakeryProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch products using BakeryProductManagementBloc
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
                      LocaleKeys.app_bakery_owner_product_management_title.tr(),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: LocaleKeys
                          .app_bakery_owner_product_management_add_product_button
                          .tr(),
                      onPressed: () {
                        // TODO: Navigate to AddProductScreen
                      },
                    ),
                  ],
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
                                      .app_bakery_owner_product_management_product_name_placeholder
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

                        // TODO: Implement Products List (ListView.builder with ProductCard)
                        // Placeholder for products list
                        Expanded(
                          child: ListView.builder(
                            itemCount: 10, // Replace with actual products count
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                child: ListTile(
                                  leading: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                      "${LocaleKeys.app_bakery_owner_product_management_product_name_placeholder.tr()}: Product ${index + 1}"),
                                  subtitle: Text(
                                      "${LocaleKeys.app_bakery_owner_product_management_product_price_placeholder.tr()}: SAR ${20 + (index * 5)}.00"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: context.colorScheme.primary),
                                        onPressed: () {
                                          // TODO: Navigate to edit product
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: context.colorScheme.error),
                                        onPressed: () {
                                          // TODO: Show delete confirmation dialog
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // TODO: Navigate to product details
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
