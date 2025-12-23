import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/di/injection.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/blocs/restaurant_owner_home_bloc.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/blocs/restaurant_owner_home_event.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/blocs/restaurant_owner_home_state.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/data/services/restaurant_owner_home_service.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_search_filter.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_list.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_bottom_navigation.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/screens/cart_screen.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/features/restaurant_owner/favorites/presentation/screens/favorites_screen.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class RestaurantOwnerHomeScreen extends StatefulWidget {
  const RestaurantOwnerHomeScreen({super.key});

  @override
  State<RestaurantOwnerHomeScreen> createState() =>
      _RestaurantOwnerHomeScreenState();
}

class _RestaurantOwnerHomeScreenState extends State<RestaurantOwnerHomeScreen> {
  String _searchQuery = '';
  String _selectedFilter = '';
  int _selectedNavIndex = 0; // Home is selected by default (index 0)

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RestaurantOwnerHomeBloc(
            service: getIt<RestaurantOwnerHomeService>(),
          )..add(const LoadRestaurantOwnerHome()),
        ),
        BlocProvider(
          create: (context) => CartCubit()..loadCart(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _selectedNavIndex,
          children: [
            // Home Tab (Index 0)
            _buildHomeView(),
            // Cart Tab (Index 1)
            CartScreen(
              onNavigateToHome: () {
                setState(() {
                  _selectedNavIndex = 0; // Switch to home tab
                });
              },
            ),
            // Daily Tab (Index 2) - Placeholder
            _buildPlaceholderView(
                LocaleKeys.app_restaurant_owner_home_daily.tr()),
            // Favorites Tab (Index 3)
            const RestaurantOwnerFavoritesScreen(),
            // Menu Tab (Index 4) - Placeholder
            _buildPlaceholderView(
                LocaleKeys.app_restaurant_owner_home_menu.tr()),
          ],
        ),
        bottomNavigationBar: RestaurantBottomNavigation(
          selectedIndex: _selectedNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  void _onSearchChanged(BuildContext blocContext, String query) {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      blocContext.read<RestaurantOwnerHomeBloc>().add(SearchRestaurants(query));
    }
  }

  void _onFilterChanged(BuildContext blocContext, String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    blocContext.read<RestaurantOwnerHomeBloc>().add(FilterRestaurants(filter));
  }

  void _onSearchPressed(BuildContext blocContext) {
    if (_searchQuery.isNotEmpty) {
      blocContext
          .read<RestaurantOwnerHomeBloc>()
          .add(SearchRestaurants(_searchQuery));
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  Widget _buildHomeView() {
    return Stack(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.app_restaurant_owner_home_welcome_title
                                .tr(),
                            style: AppTextStyles.font32TextW700.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LocaleKeys
                                .app_restaurant_owner_home_welcome_subtitle
                                .tr(),
                            style: AppTextStyles.font16TextW500.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'عمان، الصويفية',
                                style: AppTextStyles.font16TextW500.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        context.router.push(const NotificationRoute());
                      },
                    ),
                  ],
                ),
              ),

              BlocBuilder<RestaurantOwnerHomeBloc, RestaurantOwnerHomeState>(
                builder: (blocContext, state) {
                  return RestaurantSearchFilter(
                    searchQuery: _searchQuery,
                    selectedFilter: _selectedFilter,
                    onSearchChanged: (context, query) =>
                        _onSearchChanged(context, query),
                    onFilterChanged: (context, filter) =>
                        _onFilterChanged(context, filter),
                    onSearchPressed: (context) => _onSearchPressed(context),
                  );
                },
              ),

              const Expanded(
                child: RestaurantList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64.sp,
            color: AppColors.textDarkBrown.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppTextStyles.font24Textbold.copyWith(
              color: AppColors.textDarkBrown.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Coming soon',
            style: AppTextStyles.font14TextW400OP8,
          ),
        ],
      ),
    );
  }
}
