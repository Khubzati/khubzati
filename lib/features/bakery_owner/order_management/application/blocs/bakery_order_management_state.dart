part of 'bakery_order_management_bloc.dart';

abstract class BakeryOrderManagementState extends Equatable {
  const BakeryOrderManagementState();

  @override
  List<Object?> get props => [];
}

class BakeryOrderManagementInitial extends BakeryOrderManagementState {}

class BakeryOrdersLoading extends BakeryOrderManagementState {}

class BakeryOrdersLoaded extends BakeryOrderManagementState {
  final List<Map<String, dynamic>> orders;
  final bool hasReachedMax;
  final int currentPage;
  final String currentStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const BakeryOrdersLoaded({
    required this.orders,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentStatus = 'all',
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  BakeryOrdersLoaded copyWith({
    List<Map<String, dynamic>>? orders,
    bool? hasReachedMax,
    int? currentPage,
    String? currentStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return BakeryOrdersLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentStatus: currentStatus ?? this.currentStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [orders, hasReachedMax, currentPage, currentStatus, startDate, endDate, searchQuery];
}

class BakeryOrderDetailsLoading extends BakeryOrderManagementState {}

class BakeryOrderDetailsLoaded extends BakeryOrderManagementState {
  final Map<String, dynamic> order;

  const BakeryOrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class BakeryOrderStatusUpdateInProgress extends BakeryOrderManagementState {}

class BakeryOrderStatusUpdateSuccess extends BakeryOrderManagementState {
  final String orderId;
  final String newStatus;
  final String message;

  const BakeryOrderStatusUpdateSuccess({
    required this.orderId,
    required this.newStatus,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, newStatus, message];
}

class BakeryOrderReportGenerating extends BakeryOrderManagementState {
  final String reportType;

  const BakeryOrderReportGenerating(this.reportType);

  @override
  List<Object?> get props => [reportType];
}

class BakeryOrderReportGenerated extends BakeryOrderManagementState {
  final String reportType;
  final String reportUrl;
  final Map<String, dynamic> reportSummary;

  const BakeryOrderReportGenerated({
    required this.reportType,
    required this.reportUrl,
    required this.reportSummary,
  });

  @override
  List<Object?> get props => [reportType, reportUrl, reportSummary];
}

class BakeryOrderManagementError extends BakeryOrderManagementState {
  final String message;

  const BakeryOrderManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
