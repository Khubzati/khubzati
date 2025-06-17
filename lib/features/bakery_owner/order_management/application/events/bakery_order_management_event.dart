part of 'bakery_order_management_bloc.dart';

abstract class BakeryOrderManagementEvent extends Equatable {
  const BakeryOrderManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadBakeryOrders extends BakeryOrderManagementEvent {
  final String status; // 'all', 'pending', 'in_progress', 'completed', 'cancelled'
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;

  const LoadBakeryOrders({
    this.status = 'all',
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, startDate, endDate, page, limit];
}

class LoadBakeryOrderDetails extends BakeryOrderManagementEvent {
  final String orderId;

  const LoadBakeryOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateBakeryOrderStatus extends BakeryOrderManagementEvent {
  final String orderId;
  final String newStatus; // 'accepted', 'preparing', 'ready_for_pickup', 'completed', 'cancelled'
  final String? cancellationReason; // Required if status is 'cancelled'

  const UpdateBakeryOrderStatus({
    required this.orderId,
    required this.newStatus,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [orderId, newStatus, cancellationReason];
}

class SearchBakeryOrders extends BakeryOrderManagementEvent {
  final String query;

  const SearchBakeryOrders(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterBakeryOrdersByDate extends BakeryOrderManagementEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterBakeryOrdersByDate({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GenerateBakeryOrderReport extends BakeryOrderManagementEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String reportType; // 'daily', 'weekly', 'monthly', 'custom'

  const GenerateBakeryOrderReport({
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });

  @override
  List<Object?> get props => [startDate, endDate, reportType];
}
