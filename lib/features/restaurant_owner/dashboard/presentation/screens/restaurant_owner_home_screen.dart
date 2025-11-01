import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/di/injection.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_bloc.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_event.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_state.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/data/services/restaurant_owner_home_service.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_home_header.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_search_filter.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_list.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_bottom_navigation.dart';

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
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantOwnerHomeBloc(
        service: getIt<RestaurantOwnerHomeService>(),
      )..add(const LoadRestaurantOwnerHome()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const RestaurantHomeHeader(),
              BlocBuilder<RestaurantOwnerHomeBloc, RestaurantOwnerHomeState>(
                builder: (context, state) {
                  return RestaurantSearchFilter(
                    searchQuery: _searchQuery,
                    selectedFilter: _selectedFilter,
                    onSearchChanged: _onSearchChanged,
                    onFilterChanged: _onFilterChanged,
                    onSearchPressed: _onSearchPressed,
                  );
                },
              ),
              const Expanded(
                child: RestaurantList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: RestaurantBottomNavigation(
          selectedIndex: _selectedNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      context.read<RestaurantOwnerHomeBloc>().add(SearchRestaurants(query));
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    context.read<RestaurantOwnerHomeBloc>().add(FilterRestaurants(filter));
  }

  void _onSearchPressed() {
    if (_searchQuery.isNotEmpty) {
      context
          .read<RestaurantOwnerHomeBloc>()
          .add(SearchRestaurants(_searchQuery));
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    // TODO: Handle navigation based on index
  }
}
