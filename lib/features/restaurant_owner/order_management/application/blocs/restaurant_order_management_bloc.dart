import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/order_management/data/services/restaurant_order_management_service.dart';

part 'restaurant_order_management_event.dart';
part 'restaurant_order_management_state.dart';

class RestaurantOrderManagementBloc extends Bloc<RestaurantOrderManagementEvent,
    RestaurantOrderManagementState> {
  final RestaurantOrderManagementService orderManagementService;

  RestaurantOrderManagementBloc({required this.orderManagementService})
      : super(RestaurantOrderManagementInitial()) {
    on<LoadRestaurantOrders>(_onLoadRestaurantOrders);
    on<LoadRestaurantOrderDetails>(_onLoadRestaurantOrderDetails);
    on<UpdateRestaurantOrderStatus>(_onUpdateRestaurantOrderStatus);
    on<SearchRestaurantOrders>(_onSearchRestaurantOrders);
    on<FilterRestaurantOrdersByDate>(_onFilterRestaurantOrdersByDate);
    on<GenerateRestaurantOrderReport>(_onGenerateRestaurantOrderReport);
    on<AssignDeliveryPersonToOrder>(_onAssignDeliveryPersonToOrder);
    on<SendCustomerNotificationForOrder>(_onSendCustomerNotificationForOrder);
    on<GenerateOrderInvoice>(_onGenerateOrderInvoice);
    on<FetchOrderStatistics>(_onFetchOrderStatistics);
  }

  Future<void> _onLoadRestaurantOrders(LoadRestaurantOrders event,
      Emitter<RestaurantOrderManagementState> emit) async {
    // If we're loading the first page or changing filters, emit loading state
    if (event.page == 1 ||
        (state is RestaurantOrdersLoaded &&
            ((state as RestaurantOrdersLoaded).currentStatus != event.status ||
                (state as RestaurantOrdersLoaded).startDate !=
                    event.startDate ||
                (state as RestaurantOrdersLoaded).endDate != event.endDate))) {
      emit(RestaurantOrdersLoading());
    }

    try {
      // Call API to get orders
      final response = await orderManagementService.getOrders(
        status: event.status != 'all' ? event.status : null,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        page: event.page,
        limit: event.limit,
      );

      final orders = response['orders'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final currentPage = pagination['current_page'] ?? event.page;
      final limit = pagination['per_page'] ?? event.limit;
      final hasReachedMax = (currentPage * limit) >= totalCount;

      if (state is RestaurantOrdersLoaded && event.page > 1) {
        // Append to existing list for pagination
        final currentState = state as RestaurantOrdersLoaded;
        emit(currentState.copyWith(
          orders: List.of(currentState.orders)..addAll(orders),
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentStatus: event.status,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      } else {
        // First load or filter change
        emit(RestaurantOrdersLoaded(
          orders: orders,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentStatus: event.status,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to load orders: ${e.toString()}'));
    }
  }

  Future<void> _onLoadRestaurantOrderDetails(LoadRestaurantOrderDetails event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderDetailsLoading());
    try {
      // Call API to get order details
      final orderDetails =
          await orderManagementService.getOrderDetails(event.orderId);

      emit(RestaurantOrderDetailsLoaded(orderDetails: orderDetails));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to load order details: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRestaurantOrderStatus(UpdateRestaurantOrderStatus event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderStatusUpdateInProgress());
    try {
      // Validate cancellation reason if status is 'cancelled'
      if (event.newStatus == 'cancelled' &&
          (event.cancellationReason == null ||
              event.cancellationReason!.isEmpty)) {
        emit(const RestaurantOrderManagementError(
            'Cancellation reason is required when cancelling an order'));
        return;
      }

      // Call API to update order status
      final updatedOrder = await orderManagementService.updateOrderStatus(
        event.orderId,
        event.newStatus,
        notes:
            event.cancellationReason, // Use notes field for cancellation reason
      );

      // Generate appropriate message based on status
      String message;
      switch (event.newStatus) {
        case 'accepted':
          message = 'Order has been accepted';
          break;
        case 'preparing':
          message = 'Order preparation has started';
          break;
        case 'ready':
          message = 'Order is ready for pickup/delivery';
          break;
        case 'completed':
          message = 'Order has been completed';
          break;
        case 'cancelled':
          message = 'Order has been cancelled';
          break;
        default:
          message = 'Order status has been updated';
      }

      emit(RestaurantOrderStatusUpdateSuccess(
        orderId: event.orderId,
        newStatus: event.newStatus,
        message: message,
      ));

      // Update order in list if we were in loaded state
      if (state is RestaurantOrdersLoaded) {
        final currentState = state as RestaurantOrdersLoaded;
        final updatedOrders =
            List<Map<String, dynamic>>.from(currentState.orders);
        final index = updatedOrders.indexWhere((o) => o['id'] == event.orderId);

        if (index != -1) {
          updatedOrders[index] = updatedOrder;
          emit(currentState.copyWith(orders: updatedOrders));
        }
      }

      // If we were viewing order details, reload them
      if (state is RestaurantOrderDetailsLoaded) {
        add(LoadRestaurantOrderDetails(orderId: event.orderId));
      }
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to update order status: ${e.toString()}'));
    }
  }

  Future<void> _onSearchRestaurantOrders(SearchRestaurantOrders event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrdersLoading());
    try {
      // Call API to search orders
      final response = await orderManagementService.searchOrders(
        searchTerm: event.query,
        page: 1,
        limit: 20, // Adjust limit as needed
      );

      final searchResults = response['orders'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final hasReachedMax = searchResults.length >= totalCount;

      emit(RestaurantOrdersLoaded(
        orders: searchResults,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
        currentStatus: 'all',
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to search orders: ${e.toString()}'));
    }
  }

  Future<void> _onFilterRestaurantOrdersByDate(
      FilterRestaurantOrdersByDate event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrdersLoading());
    try {
      // Call API to get filtered orders
      final response = await orderManagementService.getOrders(
        // Assuming getOrders can filter by date range, otherwise need a specific endpoint
        // startDate: event.startDate,
        // endDate: event.endDate,
        page: 1,
        limit: 20, // Adjust limit as needed
      );

      final filteredOrders = response['orders'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final hasReachedMax = filteredOrders.length >= totalCount;

      emit(RestaurantOrdersLoaded(
        orders: filteredOrders,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
        currentStatus: 'all',
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to filter orders by date: ${e.toString()}'));
    }
  }

  Future<void> _onGenerateRestaurantOrderReport(
      GenerateRestaurantOrderReport event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderReportGenerating(event.reportType));
    try {
      // Call API to generate report
      // Assuming generateInvoice is the correct endpoint for now
      final reportData =
          await orderManagementService.generateInvoice(event.orderId);

      // Extract report URL and summary
      final reportUrl = reportData['invoice_url'];
      final reportSummary =
          reportData['summary'] ?? {}; // Assuming summary is part of response

      emit(RestaurantOrderReportGenerated(
        reportType: event.reportType,
        reportUrl: reportUrl,
        reportSummary: reportSummary,
      ));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to generate report: ${e.toString()}'));
    }
  }

  Future<void> _onAssignDeliveryPersonToOrder(AssignDeliveryPersonToOrder event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderActionInProgress());
    try {
      await orderManagementService.assignDeliveryPerson(
          event.orderId, event.deliveryPersonId);
      emit(const RestaurantOrderActionSuccess(
          'Delivery person assigned successfully'));
      // Update order details if currently viewing
      if (state is RestaurantOrderDetailsLoaded) {
        add(LoadRestaurantOrderDetails(orderId: event.orderId));
      }
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to assign delivery person: ${e.toString()}'));
    }
  }

  Future<void> _onSendCustomerNotificationForOrder(
      SendCustomerNotificationForOrder event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderActionInProgress());
    try {
      await orderManagementService.sendCustomerNotification(
          event.orderId, event.message);
      emit(
          const RestaurantOrderActionSuccess('Notification sent successfully'));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to send notification: ${e.toString()}'));
    }
  }

  Future<void> _onGenerateOrderInvoice(GenerateOrderInvoice event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderActionInProgress());
    try {
      final invoiceData =
          await orderManagementService.generateInvoice(event.orderId);
      emit(RestaurantOrderInvoiceGenerated(
          invoiceUrl: invoiceData['invoice_url']));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to generate invoice: ${e.toString()}'));
    }
  }

  Future<void> _onFetchOrderStatistics(FetchOrderStatistics event,
      Emitter<RestaurantOrderManagementState> emit) async {
    emit(RestaurantOrderStatisticsLoading());
    try {
      final statistics = await orderManagementService.getOrderStatistics();
      emit(RestaurantOrderStatisticsLoaded(statistics: statistics));
    } catch (e) {
      emit(RestaurantOrderManagementError(
          'Failed to fetch order statistics: ${e.toString()}'));
    }
  }
}
