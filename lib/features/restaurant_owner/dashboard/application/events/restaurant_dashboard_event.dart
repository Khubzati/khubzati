part of 'restaurant_dashboard_bloc.dart';

abstract class RestaurantDashboardEvent extends Equatable {
  const RestaurantDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDashboard extends RestaurantDashboardEvent {}

class FetchRestaurantStats extends RestaurantDashboardEvent {
  final String timeRange; // 'today', 'week', 'month', 'year'

  const FetchRestaurantStats({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

class FetchRecentOrders extends RestaurantDashboardEvent {
  final int limit;
  final int page;

  const FetchRecentOrders({this.limit = 10, this.page = 1});

  @override
  List<Object?> get props => [limit, page];
}

class FetchPopularDishes extends RestaurantDashboardEvent {
  final int limit;

  const FetchPopularDishes({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

class UpdateRestaurantStatus extends RestaurantDashboardEvent {
  final bool isOpen;

  const UpdateRestaurantStatus({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}
