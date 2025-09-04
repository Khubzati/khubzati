import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/bakery_owner/order_management/data/services/bakery_order_management_service.dart';

part 'bakery_order_management_event.dart';
part 'bakery_order_management_state.dart';

class BakeryOrderManagementBloc
    extends Bloc<BakeryOrderManagementEvent, BakeryOrderManagementState> {
  final BakeryOrderManagementService orderManagementService;

  BakeryOrderManagementBloc({required this.orderManagementService})
      : super(BakeryOrderManagementInitial()) {
    on<LoadBakeryOrders>(_onLoadBakeryOrders);
    on<LoadBakeryOrderDetails>(_onLoadBakeryOrderDetails);
    on<UpdateBakeryOrderStatus>(_onUpdateBakeryOrderStatus);
    on<SearchBakeryOrders>(_onSearchBakeryOrders);
    on<FilterBakeryOrdersByDate>(_onFilterBakeryOrdersByDate);
    on<GenerateBakeryOrderReport>(_onGenerateBakeryOrderReport);
  }

  Future<void> _onLoadBakeryOrders(
      LoadBakeryOrders event, Emitter<BakeryOrderManagementState> emit) async {
    // If we're loading the first page or changing filters, emit loading state
    if (event.page == 1 ||
        (state is BakeryOrdersLoaded &&
            ((state as BakeryOrdersLoaded).currentStatus != event.status ||
                (state as BakeryOrdersLoaded).startDate != event.startDate ||
                (state as BakeryOrdersLoaded).endDate != event.endDate))) {
      emit(BakeryOrdersLoading());
    }

    try {
      // Call API to get orders
      final response = await orderManagementService.getOrders(
        status: event.status != 'all' ? event.status : null,
        startDate: event.startDate,
        endDate: event.endDate,
        page: event.page,
        limit: event.limit,
      );

      final orders = response['orders'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final currentPage = pagination['current_page'] ?? event.page;
      final limit = pagination['per_page'] ?? event.limit;
      final hasReachedMax = (currentPage * limit) >= totalCount;

      if (state is BakeryOrdersLoaded && event.page > 1) {
        // Append to existing list for pagination
        final currentState = state as BakeryOrdersLoaded;
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
        emit(BakeryOrdersLoaded(
          orders: orders,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentStatus: event.status,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }
    } catch (e) {
      emit(
          BakeryOrderManagementError('Failed to load orders: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBakeryOrderDetails(LoadBakeryOrderDetails event,
      Emitter<BakeryOrderManagementState> emit) async {
    emit(BakeryOrderDetailsLoading());
    try {
      // Call API to get order details
      final orderDetails =
          await orderManagementService.getOrderDetails(event.orderId);

      emit(BakeryOrderDetailsLoaded(orderDetails));
    } catch (e) {
      emit(BakeryOrderManagementError(
          'Failed to load order details: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBakeryOrderStatus(UpdateBakeryOrderStatus event,
      Emitter<BakeryOrderManagementState> emit) async {
    emit(BakeryOrderStatusUpdateInProgress());
    try {
      // Validate cancellation reason if status is 'cancelled'
      if (event.newStatus == 'cancelled' &&
          (event.cancellationReason == null ||
              event.cancellationReason!.isEmpty)) {
        emit(const BakeryOrderManagementError(
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
        case 'ready_for_pickup':
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

      emit(BakeryOrderStatusUpdateSuccess(
        orderId: event.orderId,
        newStatus: event.newStatus,
        message: message,
      ));

      // Update order in list if we were in loaded state
      if (state is BakeryOrdersLoaded) {
        final currentState = state as BakeryOrdersLoaded;
        final updatedOrders =
            List<Map<String, dynamic>>.from(currentState.orders);
        final index = updatedOrders.indexWhere((o) => o['id'] == event.orderId);

        if (index != -1) {
          updatedOrders[index] = updatedOrder;
          emit(currentState.copyWith(orders: updatedOrders));
        }
      }

      // If we were viewing order details, reload them
      if (state is BakeryOrderDetailsLoaded) {
        add(LoadBakeryOrderDetails(event.orderId));
      }
    } catch (e) {
      emit(BakeryOrderManagementError(
          'Failed to update order status: ${e.toString()}'));
    }
  }

  Future<void> _onSearchBakeryOrders(SearchBakeryOrders event,
      Emitter<BakeryOrderManagementState> emit) async {
    emit(BakeryOrdersLoading());
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

      emit(BakeryOrdersLoaded(
        orders: searchResults,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
        currentStatus: 'all',
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(BakeryOrderManagementError(
          'Failed to search orders: ${e.toString()}'));
    }
  }

  Future<void> _onFilterBakeryOrdersByDate(FilterBakeryOrdersByDate event,
      Emitter<BakeryOrderManagementState> emit) async {
    emit(BakeryOrdersLoading());
    try {
      // Call API to get filtered orders
      final response = await orderManagementService.getOrders(
        startDate: event.startDate,
        endDate: event.endDate,
        page: 1,
        limit: 20, // Adjust limit as needed
      );

      final filteredOrders = response['orders'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final hasReachedMax = filteredOrders.length >= totalCount;

      emit(BakeryOrdersLoaded(
        orders: filteredOrders,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
        currentStatus: 'all',
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(BakeryOrderManagementError(
          'Failed to filter orders by date: ${e.toString()}'));
    }
  }

  Future<void> _onGenerateBakeryOrderReport(GenerateBakeryOrderReport event,
      Emitter<BakeryOrderManagementState> emit) async {
    emit(BakeryOrderReportGenerating(event.reportType));
    try {
      // Convert DateTime to String in YYYY-MM-DD format
      final startDateString = event.startDate.toIso8601String().split('T')[0];
      final endDateString = event.endDate.toIso8601String().split('T')[0];

      // Call API to generate report
      final reportData = await orderManagementService.generateOrderReport(
        startDate: startDateString,
        endDate: endDateString,
        reportType: event.reportType,
      );

      // Extract report URL and summary
      final reportUrl = reportData['report_url'];
      final reportSummary = reportData['summary'];

      emit(BakeryOrderReportGenerated(
        reportType: event.reportType,
        reportUrl: reportUrl,
        reportSummary: reportSummary,
      ));
    } catch (e) {
      emit(BakeryOrderManagementError(
          'Failed to generate report: ${e.toString()}'));
    }
  }
}
