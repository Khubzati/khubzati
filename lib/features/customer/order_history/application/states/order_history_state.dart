part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  // final List<OrderModel> orders;
  final List<Map<String, dynamic>> orders;
  final bool hasReachedMax;
  final String currentFilter; // "all", "completed", "cancelled", "in_progress"
  final int totalOrders;

  const OrderHistoryLoaded({
    required this.orders,
    this.hasReachedMax = false,
    this.currentFilter = "all",
    this.totalOrders = 0,
  });

  OrderHistoryLoaded copyWith({
    List<Map<String, dynamic>>? orders,
    bool? hasReachedMax,
    String? currentFilter,
    int? totalOrders,
  }) {
    return OrderHistoryLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentFilter: currentFilter ?? this.currentFilter,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }

  @override
  List<Object?> get props => [orders, hasReachedMax, currentFilter, totalOrders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderDetailsLoading extends OrderHistoryState {}

class OrderDetailsLoaded extends OrderHistoryState {
  // final OrderModel order;
  final Map<String, dynamic> order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class ReorderInProgress extends OrderHistoryState {}

class ReorderSuccess extends OrderHistoryState {
  final String message;

  const ReorderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReorderFailure extends OrderHistoryState {
  final String message;

  const ReorderFailure(this.message);

  @override
  List<Object?> get props => [message];
}
