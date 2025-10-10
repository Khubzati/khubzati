// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/core/widgets/app_custom_scroll_view.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/features/onboarding/application/blocs/role_selection_bloc.dart';

// Role data for carousel - will be localized in the widget
final List<Map<String, dynamic>> roleData = [
  // {
  //   "role": "customer",
  //   "image": Assets.images.driver,
  //   "titleKey": LocaleKeys.app_roles_customer,
  //   "subtitle": "Order Food", // This will be localized in the widget
  //   "description":
  //       "Browse restaurants, place orders, and enjoy fresh food delivered to your door",
  // },
  {
    "role": "bakery_owner",
    "image": Assets.images.baker,
    "titleKey": LocaleKeys.app_roles_bakery_owner,
    "subtitle": "Sell Products",
    "description":
        "Manage your bakery, track orders, and grow your business with fresh bread",
  },
  {
    "role": "restaurant_owner",
    "image": Assets.images.resturant,
    "titleKey": LocaleKeys.app_roles_restaurant_owner,
    "subtitle": "Manage Menu",
    "description":
        "Manage your restaurant menu, orders, and build customer relationships",
  },
  {
    "role": "driver",
    "image": Assets.images.driver,
    "titleKey": "app_roles_driver", // TODO: Add to locale keys
    "subtitle": "Deliver Orders",
    "description":
        "Accept delivery requests, pick up orders, and earn money by delivering food",
  },
];

@RoutePage()
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoleSelectionBloc(
        appPreferences: context.read(),
      ),
      child: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatefulWidget {
  const _RoleSelectionView();

  @override
  State<_RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<_RoleSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBurntOrange,
      body: Stack(
        children: [
          AppCustomScrollView(
            padding: const EdgeInsets.all(0),
            children: [
              Center(
                child: Column(
                  children: [
                    110.verticalSpace,
                    SvgPicture.asset(
                      Assets.images.appIcon,
                      width: 170.w,
                      height: 100.w,
                    ),
                    10.verticalSpace,
                    Text(
                      LocaleKeys.app_onboarding_select_role_title.tr(),
                      style: AppTextStyles.font47TextW700,
                    ),
                    68.verticalSpace,
                    Text(
                      LocaleKeys.app_onboarding_select_role_subheading.tr(),
                      style: AppTextStyles.font24TextW700,
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  LocaleKeys.app_userTypeSelection_createAccountHint.tr(),
                  style: AppTextStyles.font20TextW500,
                ),
              ),
              40.verticalSpace,
              BlocBuilder<RoleSelectionBloc, RoleSelectionState>(
                builder: (context, state) {
                  if (state is RoleSelectionInProgress) {
                    return const AppLoadingWidget(
                      message: 'Loading roles...',
                    );
                  }

                  if (state is RoleSelectionFailure) {
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<RoleSelectionBloc>().add(
                              const LoadSelectedRole(),
                            );
                      },
                    );
                  }

                  return Column(
                    children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          disableCenter: false,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.1,
                          autoPlay: false,
                          height: 280.h,
                        ),
                        itemCount: roleData.length,
                        itemBuilder: (context, index, realIndex) {
                          final item = roleData[index];
                          return _buildRoleCard(
                            context,
                            role: item['role'],
                            image: item['image'],
                            title: _getLocalizedTitle(item['titleKey']),
                            subtitle: item['subtitle'],
                            description: item['description'],
                            isSelected: false, // Not needed anymore
                          );
                        },
                      ),
                      30.verticalSpace,
                      _buildCircleIndicators(),
                    ],
                  );
                },
              ),
              40.verticalSpace,
            ],
          ),
          // Language switcher in top right
          Positioned(
            top: 50.h,
            right: 20.w,
            child: _buildLanguageSwitcher(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String role,
    required String image,
    required String title,
    required String subtitle,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        // Add haptic feedback for better UX
        // HapticFeedback.lightImpact();

        // Navigate directly to authentication with selected role
        _navigateToAuthentication(context, role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 25.w),
        decoration: BoxDecoration(
          color: AppColors.secondaryLightCream,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.transparent,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                image,
                height: 100.h,
                fit: BoxFit.contain,
              ),
            ),
            15.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkBrown,
              ),
            ),
            8.verticalSpace,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkBrown.withOpacity(0.7),
              ),
            ),
            5.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: AppColors.tertiaryOliveGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Tap to continue',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.tertiaryOliveGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        roleData.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryLightCream,
          ),
        ),
      ),
    );
  }

  void _navigateToAuthentication(BuildContext context, String role) {
    // Store the selected role in preferences for later use
    context.read<RoleSelectionBloc>().add(SelectRole(role: role));

    // Navigate directly to login screen
    context.router.push(const LoginRoute());
  }

  String _getLocalizedTitle(String titleKey) {
    switch (titleKey) {
      case LocaleKeys.app_roles_customer:
        return LocaleKeys.app_roles_customer.tr();
      case LocaleKeys.app_roles_bakery_owner:
        return LocaleKeys.app_roles_bakery_owner.tr();
      case LocaleKeys.app_roles_restaurant_owner:
        return LocaleKeys.app_roles_restaurant_owner.tr();
      default:
        return titleKey;
    }
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        final newLocale = isArabic ? const Locale('en') : const Locale('ar');
        context.setLocale(newLocale);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              isArabic ? 'EN' : 'عربي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
