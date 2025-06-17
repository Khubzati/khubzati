part of 'restaurant_order_management_bloc.dart';

abstract class RestaurantOrderManagementEvent extends Equatable {
  const RestaurantOrderManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantOrders extends RestaurantOrderManagementEvent {
  final String status; // 'all', 'pending', 'in_progress', 'completed', 'cancelled'
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;

  const LoadRestaurantOrders({
    this.status = 'all',
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, startDate, endDate, page, limit];
}

class LoadRestaurantOrderDetails extends RestaurantOrderManagementEvent {
  final String orderId;

  const LoadRestaurantOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateRestaurantOrderStatus extends RestaurantOrderManagementEvent {
  final String orderId;
  final String newStatus; // 'accepted', 'preparing', 'ready', 'completed', 'cancelled'
  final String? cancellationReason; // Required if status is 'cancelled'

  const UpdateRestaurantOrderStatus({
    required this.orderId,
    required this.newStatus,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [orderId, newStatus, cancellationReason];
}

class SearchRestaurantOrders extends RestaurantOrderManagementEvent {
  final String query;

  const SearchRestaurantOrders(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterRestaurantOrdersByDate extends RestaurantOrderManagementEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterRestaurantOrdersByDate({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GenerateRestaurantOrderReport extends RestaurantOrderManagementEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String reportType; // 'daily', 'weekly', 'monthly', 'custom'

  const GenerateRestaurantOrderReport({
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });

  @override
  List<Object?> get props => [startDate, endDate, reportType];
}
