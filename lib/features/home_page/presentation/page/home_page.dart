import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/shared/app_card.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../../../../gen/assets.gen.dart';
import 'dart:ui';
import '../widget/tab_selector.dart';
import '../widget/order_card.dart';
import '../widget/previous_orders_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCurrentSelected = true;

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
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context
                            .tr(LocaleKeys.app_userTypeSelection_WelcomeText),
                        style: AppTextStyles.font24TextW700,
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        color: AppColors.pageBackground,
                        onPressed: () {
                          context.router.push(const NotificationRoute());
                        },
                      ),
                    ],
                  ),
                ),

                // Stats cards (scrollable)
                Container(
                  height: 100.h,
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Total Revenue
                      AppCard(
                        backgroundColor: AppColors.pageBackground,
                        borderRadius: 8.r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context
                                  .tr(LocaleKeys.app_home_stats_total_revenue),
                              style: AppTextStyles.font15TextW400,
                            ),
                            8.verticalSpace,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '1,278.67',
                                    style:
                                        AppTextStyles.font16textDarkBrownBold,
                                  ),
                                  TextSpan(
                                    text: ' د.أ',
                                    style: AppTextStyles.font15TextW400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Completed Orders
                      AppCard(
                        backgroundColor: AppColors.pageBackground,
                        borderRadius: 8.r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr(
                                  LocaleKeys.app_home_stats_completed_orders),
                              style: AppTextStyles.font15TextW400,
                            ),
                            8.verticalSpace,
                            Text(
                              '3240 / 3520',
                              style: AppTextStyles.font16textDarkBrownBold,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Incomplete Orders
                      AppCard(
                        backgroundColor: AppColors.pageBackground,
                        borderRadius: 8.r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr(
                                  LocaleKeys.app_home_stats_incomplete_orders),
                              style: AppTextStyles.font15TextW400,
                            ),
                            8.verticalSpace,
                            Text(
                              '16 / 350',
                              style: AppTextStyles.font16textDarkBrownBold,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),
                    ],
                  ),
                ),

                // Tab selector
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
                  child: TabSelector(
                    onChanged: (isCurrent) {
                      setState(() => _isCurrentSelected = isCurrent);
                    },
                  ),
                ),

                if (!_isCurrentSelected)
                  // Previous Orders Section per Figma
                  const PreviousOrdersSection(
                    titleText: 'الطلبات السابقة',
                    orders: [
                      {
                        'id': 10234,
                        'date': '10 يناير، 6 ص',
                        'status': 'مكتمل',
                        'total': '23.50',
                      },
                      {
                        'id': 10235,
                        'date': '9 يناير، 4 م',
                        'status': 'ملغي',
                        'total': '12.00',
                      },
                    ],
                  )
                else
                  // Current Orders list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 8.h,
                        left: 16.w,
                        right: 16.w,
                        bottom: 100.h, // Extra padding for bottom navbar
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: const OrderCard(
                            orderNumber: '12347897473',
                            status: 'غير مكتمل',
                            amount: '230.50',
                            date: '10 يناير، 6 ص',
                            location: 'عمان، الصويفية',
                            productQuantities: ['x67', 'x661', 'x67', 'x1'],
                          ),
                        );
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
