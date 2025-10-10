part of 'restaurant_order_management_bloc.dart';

abstract class RestaurantOrderManagementState extends Equatable {
  const RestaurantOrderManagementState();

  @override
  List<Object?> get props => [];
}

class RestaurantOrderManagementInitial extends RestaurantOrderManagementState {}

class RestaurantOrdersLoading extends RestaurantOrderManagementState {}

class RestaurantOrderDetailsLoading extends RestaurantOrderManagementState {}

class RestaurantOrderStatusUpdateInProgress extends RestaurantOrderManagementState {}

class RestaurantOrderActionInProgress extends RestaurantOrderManagementState {}

class RestaurantOrderReportGenerating extends RestaurantOrderManagementState {
  final String reportType;

  const RestaurantOrderReportGenerating(this.reportType);

  @override
  List<Object?> get props => [reportType];
}

class RestaurantOrderStatisticsLoading extends RestaurantOrderManagementState {}

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

class RestaurantOrderActionSuccess extends RestaurantOrderManagementState {
  final String message;

  const RestaurantOrderActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
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

class RestaurantOrderInvoiceGenerated extends RestaurantOrderManagementState {
  final String invoiceUrl;

  const RestaurantOrderInvoiceGenerated({required this.invoiceUrl});

  @override
  List<Object?> get props => [invoiceUrl];
}

class RestaurantOrdersLoaded extends RestaurantOrderManagementState {
  final List<Map<String, dynamic>> orders;
  final bool hasReachedMax;
  final int currentPage;
  final String currentStatus;
  final String? startDate;
  final String? endDate;
  final String? searchQuery;

  const RestaurantOrdersLoaded({
    required this.orders,
    required this.hasReachedMax,
    required this.currentPage,
    required this.currentStatus,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  RestaurantOrdersLoaded copyWith({
    List<Map<String, dynamic>>? orders,
    bool? hasReachedMax,
    int? currentPage,
    String? currentStatus,
    String? startDate,
    String? endDate,
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
  List<Object?> get props => [
        orders,
        hasReachedMax,
        currentPage,
        currentStatus,
        startDate,
        endDate,
        searchQuery,
      ];
}

class RestaurantOrderDetailsLoaded extends RestaurantOrderManagementState {
  final Map<String, dynamic> orderDetails;

  const RestaurantOrderDetailsLoaded({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}

class RestaurantOrderStatisticsLoaded extends RestaurantOrderManagementState {
  final Map<String, dynamic> statistics;

  const RestaurantOrderStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class RestaurantOrderManagementError extends RestaurantOrderManagementState {
  final String message;

  const RestaurantOrderManagementError(this.message);

  @override
  List<Object?> get props => [message];
}