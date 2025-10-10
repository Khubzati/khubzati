import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/data/services/restaurant_dashboard_service.dart';
import 'package:khubzati/features/restaurant_owner/order_management/data/services/restaurant_order_management_service.dart';

part 'restaurant_dashboard_event.dart';
part 'restaurant_dashboard_state.dart';

class RestaurantDashboardBloc
    extends Bloc<RestaurantDashboardEvent, RestaurantDashboardState> {
  final RestaurantDashboardService restaurantDashboardService;
  final RestaurantOrderManagementService orderService;

  RestaurantDashboardBloc({
    required this.restaurantDashboardService,
    required this.orderService,
  }) : super(RestaurantDashboardInitial()) {
    on<LoadRestaurantDashboard>(_onLoadRestaurantDashboard);
    on<FetchRestaurantStats>(_onFetchRestaurantStats);
    on<FetchRecentOrders>(_onFetchRecentOrders);
    on<FetchPopularDishes>(_onFetchPopularDishes);
    on<UpdateRestaurantStatus>(_onUpdateRestaurantStatus);
  }

  Future<void> _onLoadRestaurantDashboard(LoadRestaurantDashboard event,
      Emitter<RestaurantDashboardState> emit) async {
    emit(RestaurantDashboardLoading());
    try {
      // Fetch dashboard summary data
      final dashboardSummary =
          await restaurantDashboardService.getDashboardSummary();
      final stats =
          await restaurantDashboardService.getSalesStatistics(period: 'daily');
      final recentOrders =
          await restaurantDashboardService.getRecentOrders(limit: 10);
      final popularDishes =
          await restaurantDashboardService.getTopSellingItems(limit: 5);

      // Extract restaurant info from dashboard summary
      final restaurantInfo = {
        'id': dashboardSummary['restaurant']['id'],
        'name': dashboardSummary['restaurant']['name'],
        'address': dashboardSummary['restaurant']['address'],
        'phone': dashboardSummary['restaurant']['phone'],
        'email': dashboardSummary['restaurant']['email'],
        'logo': dashboardSummary['restaurant']['logo'],
        'rating': dashboardSummary['restaurant']['rating'],
        'reviewCount': dashboardSummary['restaurant']['review_count'],
        'cuisineType': dashboardSummary['restaurant']['cuisine_type'],
      };

      final isOpen = dashboardSummary['restaurant']['is_open'] ?? true;

      emit(RestaurantDashboardLoaded(
        restaurantInfo: restaurantInfo,
        stats: stats,
        recentOrders: recentOrders,
        popularDishes: popularDishes,
        isOpen: isOpen,
        timeRange: 'today',
      ));
    } catch (e) {
      emit(RestaurantDashboardError(
          'Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onFetchRestaurantStats(FetchRestaurantStats event,
      Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      emit(RestaurantStatsLoading(event.timeRange));

      try {
        final stats = await restaurantDashboardService.getSalesStatistics(
          period: event.timeRange,
        );

        emit(currentState.copyWith(
          stats: stats,
          timeRange: event.timeRange,
        ));
      } catch (e) {
        emit(
            RestaurantDashboardError('Failed to fetch stats: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchRecentOrders(
      FetchRecentOrders event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;

      try {
        final recentOrders = await restaurantDashboardService.getRecentOrders(
          limit: event.limit,
        );

        emit(currentState.copyWith(
          recentOrders: recentOrders,
        ));
      } catch (e) {
        emit(RestaurantDashboardError(
            'Failed to fetch recent orders: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchPopularDishes(
      FetchPopularDishes event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;

      try {
        final popularDishes =
            await restaurantDashboardService.getTopSellingItems(
          limit: event.limit,
        );

        emit(currentState.copyWith(
          popularDishes: popularDishes,
        ));
      } catch (e) {
        emit(RestaurantDashboardError(
            'Failed to fetch popular dishes: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateRestaurantStatus(UpdateRestaurantStatus event,
      Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      emit(RestaurantStatusUpdateInProgress());

      try {
        await restaurantDashboardService.updateRestaurantStatus(event.isOpen);

        final message = event.isOpen
            ? 'Restaurant is now open for orders'
            : 'Restaurant is now closed';
        emit(RestaurantStatusUpdateSuccess(
            isOpen: event.isOpen, message: message));

        // Update the main state
        emit(currentState.copyWith(isOpen: event.isOpen));
      } catch (e) {
        emit(RestaurantDashboardError(
            'Failed to update restaurant status: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }
}
