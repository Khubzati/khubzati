part of 'restaurant_owner_dashboard_bloc.dart';

abstract class RestaurantOwnerDashboardEvent extends Equatable {
  const RestaurantOwnerDashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial dashboard data
class LoadRestaurantOwnerDashboard extends RestaurantOwnerDashboardEvent {
  const LoadRestaurantOwnerDashboard();
}

/// Event to fetch sales statistics for a specific time range
class FetchRestaurantOwnerStats extends RestaurantOwnerDashboardEvent {
  final String timeRange; // e.g., 'today', 'week', 'month', 'year'

  const FetchRestaurantOwnerStats({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

/// Event to fetch recent orders
class FetchRestaurantOwnerRecentOrders extends RestaurantOwnerDashboardEvent {
  final int limit;
  final int page;

  const FetchRestaurantOwnerRecentOrders({this.limit = 10, this.page = 1});

  @override
  List<Object?> get props => [limit, page];
}

/// Event to fetch popular menu items
class FetchRestaurantOwnerPopularItems extends RestaurantOwnerDashboardEvent {
  final int limit;

  const FetchRestaurantOwnerPopularItems({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

/// Event to update the restaurant's open/closed status
class UpdateRestaurantOwnerStatus extends RestaurantOwnerDashboardEvent {
  final bool isOpen;

  const UpdateRestaurantOwnerStatus({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}

