part of 'restaurant_order_management_bloc.dart';

abstract class RestaurantOrderManagementState extends Equatable {
  const RestaurantOrderManagementState();

  @override
  List<Object?> get props => [];
}

class RestaurantOrderManagementInitial extends RestaurantOrderManagementState {}

class RestaurantOrdersLoading extends RestaurantOrderManagementState {}

class RestaurantOrdersLoaded extends RestaurantOrderManagementState {
  final List<Map<String, dynamic>> orders;
  final bool hasReachedMax;
  final int currentPage;
  final String currentStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const RestaurantOrdersLoaded({
    required this.orders,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentStatus = 'all',
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  RestaurantOrdersLoaded copyWith({
    List<Map<String, dynamic>>? orders,
    bool? hasReachedMax,
    int? currentPage,
    String? currentStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return RestaurantOrdersLoaded(
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

class RestaurantOrderDetailsLoading extends RestaurantOrderManagementState {}

class RestaurantOrderDetailsLoaded extends RestaurantOrderManagementState {
  final Map<String, dynamic> order;

  const RestaurantOrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class RestaurantOrderStatusUpdateInProgress extends RestaurantOrderManagementState {}

class RestaurantOrderStatusUpdateSuccess extends RestaurantOrderManagementState {
  final String orderId;
  final String newStatus;
  final String message;

  const RestaurantOrderStatusUpdateSuccess({
    required this.orderId,
    required this.newStatus,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, newStatus, message];
}

class RestaurantOrderReportGenerating extends RestaurantOrderManagementState {
  final String reportType;

  const RestaurantOrderReportGenerating(this.reportType);

  @override
  List<Object?> get props => [reportType];
}

class RestaurantOrderReportGenerated extends RestaurantOrderManagementState {
  final String reportType;
  final String reportUrl;
  final Map<String, dynamic> reportSummary;

  const RestaurantOrderReportGenerated({
    required this.reportType,
    required this.reportUrl,
    required this.reportSummary,
  });

  @override
  List<Object?> get props => [reportType, reportUrl, reportSummary];
}

class RestaurantOrderManagementError extends RestaurantOrderManagementState {
  final String message;

  const RestaurantOrderManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
