part of 'restaurant_dashboard_bloc.dart';

abstract class RestaurantDashboardEvent extends Equatable {
  const RestaurantDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDashboard extends RestaurantDashboardEvent {
  const LoadRestaurantDashboard();
}

class FetchRestaurantStats extends RestaurantDashboardEvent {
  final String timeRange;

  const FetchRestaurantStats({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

class FetchRecentOrders extends RestaurantDashboardEvent {
  final int limit;
  final int page;

  const FetchRecentOrders({
    required this.limit,
    required this.page,
  });

  @override
  List<Object?> get props => [limit, page];
}

class FetchPopularDishes extends RestaurantDashboardEvent {
  final int limit;

  const FetchPopularDishes({required this.limit});

  @override
  List<Object?> get props => [limit];
}

class UpdateRestaurantStatus extends RestaurantDashboardEvent {
  final bool isOpen;

  const UpdateRestaurantStatus({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}