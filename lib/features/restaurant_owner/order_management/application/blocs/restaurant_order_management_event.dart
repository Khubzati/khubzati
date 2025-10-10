part of 'restaurant_order_management_bloc.dart';

abstract class RestaurantOrderManagementEvent extends Equatable {
  const RestaurantOrderManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantOrders extends RestaurantOrderManagementEvent {
  final String status;
  final String? sortBy;
  final String? sortOrder;
  final int page;
  final int limit;
  final String? startDate;
  final String? endDate;

  const LoadRestaurantOrders({
    this.status = 'all',
    this.sortBy,
    this.sortOrder,
    this.page = 1,
    this.limit = 20,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [status, sortBy, sortOrder, page, limit, startDate, endDate];
}

class LoadRestaurantOrderDetails extends RestaurantOrderManagementEvent {
  final String orderId;

  const LoadRestaurantOrderDetails({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class UpdateRestaurantOrderStatus extends RestaurantOrderManagementEvent {
  final String orderId;
  final String newStatus;
  final String? cancellationReason;

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

  const SearchRestaurantOrders({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterRestaurantOrdersByDate extends RestaurantOrderManagementEvent {
  final String? startDate;
  final String? endDate;

  const FilterRestaurantOrdersByDate({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GenerateRestaurantOrderReport extends RestaurantOrderManagementEvent {
  final String orderId;
  final String reportType;

  const GenerateRestaurantOrderReport({
    required this.orderId,
    required this.reportType,
  });

  @override
  List<Object?> get props => [orderId, reportType];
}

class AssignDeliveryPersonToOrder extends RestaurantOrderManagementEvent {
  final String orderId;
  final String deliveryPersonId;

  const AssignDeliveryPersonToOrder({
    required this.orderId,
    required this.deliveryPersonId,
  });

  @override
  List<Object?> get props => [orderId, deliveryPersonId];
}

class SendCustomerNotificationForOrder extends RestaurantOrderManagementEvent {
  final String orderId;
  final String message;

  const SendCustomerNotificationForOrder({
    required this.orderId,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, message];
}

class GenerateOrderInvoice extends RestaurantOrderManagementEvent {
  final String orderId;

  const GenerateOrderInvoice({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class FetchOrderStatistics extends RestaurantOrderManagementEvent {
  const FetchOrderStatistics();
}