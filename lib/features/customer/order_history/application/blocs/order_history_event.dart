part of 'order_history_bloc.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderHistory extends OrderHistoryEvent {
  final String? status; // Optional filter by status
  final DateTime? startDate; // Optional filter by date range
  final DateTime? endDate;

  const FetchOrderHistory({
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [status, startDate, endDate];
}

class LoadMoreOrders extends OrderHistoryEvent {}

class FilterOrdersByStatus extends OrderHistoryEvent {
  final String status; // "all", "completed", "cancelled", "in_progress"

  const FilterOrdersByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class ViewOrderDetails extends OrderHistoryEvent {
  final String orderId;

  const ViewOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ReorderItems extends OrderHistoryEvent {
  final String orderId;

  const ReorderItems(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class SearchOrders extends OrderHistoryEvent {
  final String searchTerm;
  final DateTime? startDate;
  final DateTime? endDate;

  const SearchOrders({
    required this.searchTerm,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [searchTerm, startDate, endDate];
}
