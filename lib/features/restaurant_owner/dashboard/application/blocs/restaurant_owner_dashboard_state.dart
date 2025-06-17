part of 'restaurant_owner_dashboard_bloc.dart';

abstract class RestaurantOwnerDashboardState extends Equatable {
  const RestaurantOwnerDashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RestaurantOwnerDashboardInitial extends RestaurantOwnerDashboardState {}

/// State while loading dashboard data
class RestaurantOwnerDashboardLoading extends RestaurantOwnerDashboardState {}

/// State when dashboard data is successfully loaded
class RestaurantOwnerDashboardLoaded extends RestaurantOwnerDashboardState {
  final Map<String, dynamic> restaurantInfo;
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> recentOrders;
  final List<Map<String, dynamic>> popularItems;
  final bool isOpen;
  final String timeRange; // e.g., 'today', 'week', 'month'

  const RestaurantOwnerDashboardLoaded({
    required this.restaurantInfo,
    required this.stats,
    required this.recentOrders,
    required this.popularItems,
    required this.isOpen,
    required this.timeRange,
  });

  @override
  List<Object?> get props => [
        restaurantInfo,
        stats,
        recentOrders,
        popularItems,
        isOpen,
        timeRange,
      ];

  RestaurantOwnerDashboardLoaded copyWith({
    Map<String, dynamic>? restaurantInfo,
    Map<String, dynamic>? stats,
    List<Map<String, dynamic>>? recentOrders,
    List<Map<String, dynamic>>? popularItems,
    bool? isOpen,
    String? timeRange,
  }) {
    return RestaurantOwnerDashboardLoaded(
      restaurantInfo: restaurantInfo ?? this.restaurantInfo,
      stats: stats ?? this.stats,
      recentOrders: recentOrders ?? this.recentOrders,
      popularItems: popularItems ?? this.popularItems,
      isOpen: isOpen ?? this.isOpen,
      timeRange: timeRange ?? this.timeRange,
    );
  }
}

/// State while fetching updated stats
class RestaurantOwnerStatsLoading extends RestaurantOwnerDashboardState {
  final String timeRange;

  const RestaurantOwnerStatsLoading(this.timeRange);

  @override
  List<Object?> get props => [timeRange];
}

/// State while updating restaurant open/closed status
class RestaurantOwnerStatusUpdateInProgress extends RestaurantOwnerDashboardState {}

/// State when restaurant status update is successful
class RestaurantOwnerStatusUpdateSuccess extends RestaurantOwnerDashboardState {
  final bool isOpen;
  final String message;

  const RestaurantOwnerStatusUpdateSuccess({required this.isOpen, required this.message});

  @override
  List<Object?> get props => [isOpen, message];
}

/// State when an error occurs
class RestaurantOwnerDashboardError extends RestaurantOwnerDashboardState {
  final String message;

  const RestaurantOwnerDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

