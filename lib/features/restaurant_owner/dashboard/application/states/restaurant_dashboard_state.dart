part of 'restaurant_dashboard_bloc.dart';

abstract class RestaurantDashboardState extends Equatable {
  const RestaurantDashboardState();

  @override
  List<Object?> get props => [];
}

class RestaurantDashboardInitial extends RestaurantDashboardState {}

class RestaurantDashboardLoading extends RestaurantDashboardState {}

class RestaurantDashboardLoaded extends RestaurantDashboardState {
  final Map<String, dynamic> restaurantInfo;
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> recentOrders;
  final List<Map<String, dynamic>> popularDishes;
  final bool isOpen;
  final String timeRange; // 'today', 'week', 'month', 'year'

  const RestaurantDashboardLoaded({
    required this.restaurantInfo,
    required this.stats,
    required this.recentOrders,
    required this.popularDishes,
    required this.isOpen,
    this.timeRange = 'today',
  });

  RestaurantDashboardLoaded copyWith({
    Map<String, dynamic>? restaurantInfo,
    Map<String, dynamic>? stats,
    List<Map<String, dynamic>>? recentOrders,
    List<Map<String, dynamic>>? popularDishes,
    bool? isOpen,
    String? timeRange,
  }) {
    return RestaurantDashboardLoaded(
      restaurantInfo: restaurantInfo ?? this.restaurantInfo,
      stats: stats ?? this.stats,
      recentOrders: recentOrders ?? this.recentOrders,
      popularDishes: popularDishes ?? this.popularDishes,
      isOpen: isOpen ?? this.isOpen,
      timeRange: timeRange ?? this.timeRange,
    );
  }

  @override
  List<Object?> get props => [restaurantInfo, stats, recentOrders, popularDishes, isOpen, timeRange];
}

class RestaurantStatsLoading extends RestaurantDashboardState {
  final String timeRange;

  const RestaurantStatsLoading(this.timeRange);

  @override
  List<Object?> get props => [timeRange];
}

class RestaurantStatusUpdateInProgress extends RestaurantDashboardState {}

class RestaurantStatusUpdateSuccess extends RestaurantDashboardState {
  final bool isOpen;
  final String message;

  const RestaurantStatusUpdateSuccess({
    required this.isOpen,
    required this.message,
  });

  @override
  List<Object?> get props => [isOpen, message];
}

class RestaurantDashboardError extends RestaurantDashboardState {
  final String message;

  const RestaurantDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
