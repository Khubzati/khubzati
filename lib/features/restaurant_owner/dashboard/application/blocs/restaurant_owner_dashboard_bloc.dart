import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/data/services/restaurant_dashboard_service.dart';

part 'restaurant_owner_dashboard_event.dart';
part 'restaurant_owner_dashboard_state.dart';

class RestaurantOwnerDashboardBloc extends Bloc<RestaurantOwnerDashboardEvent, RestaurantOwnerDashboardState> {
  final RestaurantDashboardService restaurantDashboardService;

  RestaurantOwnerDashboardBloc({
    required this.restaurantDashboardService,
  }) : super(RestaurantOwnerDashboardInitial()) {
    on<LoadRestaurantOwnerDashboard>(_onLoadRestaurantOwnerDashboard);
    on<FetchRestaurantOwnerStats>(_onFetchRestaurantOwnerStats);
    on<FetchRestaurantOwnerRecentOrders>(_onFetchRestaurantOwnerRecentOrders);
    on<FetchRestaurantOwnerPopularItems>(_onFetchRestaurantOwnerPopularItems);
    on<UpdateRestaurantOwnerStatus>(_onUpdateRestaurantOwnerStatus);
  }

  Future<void> _onLoadRestaurantOwnerDashboard(LoadRestaurantOwnerDashboard event, Emitter<RestaurantOwnerDashboardState> emit) async {
    emit(RestaurantOwnerDashboardLoading());
    try {
      // Fetch all required data concurrently
      final results = await Future.wait([
        restaurantDashboardService.getDashboardSummary(),
        restaurantDashboardService.getSalesStatistics(period: 'today'),
        restaurantDashboardService.getRecentOrders(limit: 10),
        restaurantDashboardService.getTopSellingItems(limit: 5),
      ]);

      final restaurantInfo = results[0] as Map<String, dynamic>;
      final stats = results[1] as Map<String, dynamic>;
      final recentOrders = results[2] as List<Map<String, dynamic>>;
      final popularItems = results[3] as List<Map<String, dynamic>>;
      
      // Assuming 'isOpen' status is part of the summary or profile info
      final isOpen = restaurantInfo['is_open'] ?? true;

      emit(RestaurantOwnerDashboardLoaded(
        restaurantInfo: restaurantInfo,
        stats: stats,
        recentOrders: recentOrders,
        popularItems: popularItems,
        isOpen: isOpen,
        timeRange: 'today',
      ));
    } catch (e) {
      emit(RestaurantOwnerDashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onFetchRestaurantOwnerStats(FetchRestaurantOwnerStats event, Emitter<RestaurantOwnerDashboardState> emit) async {
    if (state is RestaurantOwnerDashboardLoaded) {
      final currentState = state as RestaurantOwnerDashboardLoaded;
      emit(RestaurantOwnerStatsLoading(event.timeRange));
      
      try {
        // Fetch stats for the requested time range
        final stats = await restaurantDashboardService.getSalesStatistics(period: event.timeRange);

        emit(currentState.copyWith(
          stats: stats,
          timeRange: event.timeRange,
        ));
      } catch (e) {
        emit(RestaurantOwnerDashboardError('Failed to fetch stats: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchRestaurantOwnerRecentOrders(FetchRestaurantOwnerRecentOrders event, Emitter<RestaurantOwnerDashboardState> emit) async {
    if (state is RestaurantOwnerDashboardLoaded) {
      final currentState = state as RestaurantOwnerDashboardLoaded;
      // Could emit a specific loading state for orders, but for simplicity using the main state
      
      try {
        // Fetch recent orders
        final recentOrders = await restaurantDashboardService.getRecentOrders(limit: event.limit, page: event.page);

        emit(currentState.copyWith(
          recentOrders: recentOrders,
        ));
      } catch (e) {
        emit(RestaurantOwnerDashboardError('Failed to fetch recent orders: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchRestaurantOwnerPopularItems(FetchRestaurantOwnerPopularItems event, Emitter<RestaurantOwnerDashboardState> emit) async {
    if (state is RestaurantOwnerDashboardLoaded) {
      final currentState = state as RestaurantOwnerDashboardLoaded;
      // Could emit a specific loading state for items, but for simplicity using the main state
      
      try {
        // Fetch popular items
        final popularItems = await restaurantDashboardService.getTopSellingItems(limit: event.limit);

        emit(currentState.copyWith(
          popularItems: popularItems,
        ));
      } catch (e) {
        emit(RestaurantOwnerDashboardError('Failed to fetch popular items: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateRestaurantOwnerStatus(UpdateRestaurantOwnerStatus event, Emitter<RestaurantOwnerDashboardState> emit) async {
    if (state is RestaurantOwnerDashboardLoaded) {
      final currentState = state as RestaurantOwnerDashboardLoaded;
      emit(RestaurantOwnerStatusUpdateInProgress());
      
      try {
        // In a real app, this would call a specific endpoint to update status
        // For now, we assume it's part of the profile update or a dedicated endpoint
        // await restaurantDashboardService.updateRestaurantStatus(isOpen: event.isOpen);
        
        // Placeholder: simulate API call
        await Future.delayed(const Duration(milliseconds: 500));
        
        final message = event.isOpen ? 'Restaurant is now open for orders' : 'Restaurant is now closed';
        emit(RestaurantOwnerStatusUpdateSuccess(isOpen: event.isOpen, message: message));
        
        // Update the main state
        emit(currentState.copyWith(isOpen: event.isOpen));
      } catch (e) {
        emit(RestaurantOwnerDashboardError('Failed to update restaurant status: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }
}

