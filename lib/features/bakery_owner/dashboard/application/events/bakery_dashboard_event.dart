part of 'bakery_dashboard_bloc.dart';

abstract class BakeryDashboardEvent extends Equatable {
  const BakeryDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadBakeryDashboard extends BakeryDashboardEvent {}

class FetchBakeryStats extends BakeryDashboardEvent {
  final String timeRange; // 'today', 'week', 'month', 'year'

  const FetchBakeryStats({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

class FetchRecentOrders extends BakeryDashboardEvent {
  final int limit;
  final int page;

  const FetchRecentOrders({this.limit = 10, this.page = 1});

  @override
  List<Object?> get props => [limit, page];
}

class FetchPopularProducts extends BakeryDashboardEvent {
  final int limit;

  const FetchPopularProducts({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

class UpdateBakeryStatus extends BakeryDashboardEvent {
  final bool isOpen;

  const UpdateBakeryStatus({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}
