import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/customer/order_history/data/services/order_history_service.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderHistoryService orderHistoryService;
  // final CartBloc cartBloc; // For reordering functionality

  OrderHistoryBloc({
    required this.orderHistoryService,
    // required this.cartBloc,
  }) : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>(_onFetchOrderHistory);
    on<LoadMoreOrders>(_onLoadMoreOrders);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
    on<ViewOrderDetails>(_onViewOrderDetails);
    on<ReorderItems>(_onReorderItems);
    on<SearchOrders>(_onSearchOrders);
  }

  Future<void> _onFetchOrderHistory(
      FetchOrderHistory event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());
    try {
      // Call API to get order history
      final response = await orderHistoryService.getOrderHistory(
        page: 1,
        limit: 10,
        status: event.status,
      );

      final orders = response['orders'];
      final pagination = response['pagination'];

      emit(OrderHistoryLoaded(
        orders: orders,
        hasReachedMax:
            orders.length < 10 || orders.length >= pagination['total_count'],
        currentFilter: event.status ?? 'all',
        totalOrders: pagination['total_count'],
      ));
    } catch (e) {
      emit(OrderHistoryError('Failed to fetch order history: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreOrders(
      LoadMoreOrders event, Emitter<OrderHistoryState> emit) async {
    if (state is OrderHistoryLoaded) {
      final currentState = state as OrderHistoryLoaded;

      if (!currentState.hasReachedMax) {
        try {
          // Calculate next page based on current items
          final nextPage = (currentState.orders.length ~/ 10) + 1;

          // Call API to get more orders
          final response = await orderHistoryService.getOrderHistory(
            page: nextPage,
            limit: 10,
            status: currentState.currentFilter != 'all'
                ? currentState.currentFilter
                : null,
          );

          final moreOrders = response['orders'];
          final pagination = response['pagination'];

          if (moreOrders.isEmpty) {
            // No more orders to load
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            // Append new orders to existing list
            emit(currentState.copyWith(
              orders: List.of(currentState.orders)..addAll(moreOrders),
              hasReachedMax: moreOrders.length < 10 ||
                  (currentState.orders.length + moreOrders.length) >=
                      pagination['total_count'],
            ));
          }
        } catch (e) {
          emit(
              OrderHistoryError('Failed to load more orders: ${e.toString()}'));
        }
      }
    }
  }

  Future<void> _onFilterOrdersByStatus(
      FilterOrdersByStatus event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());
    try {
      // Call API to get filtered orders
      final response = await orderHistoryService.getOrderHistory(
        page: 1,
        limit: 10,
        status: event.status != 'all' ? event.status : null,
      );

      final filteredOrders = response['orders'];
      final pagination = response['pagination'];

      emit(OrderHistoryLoaded(
        orders: filteredOrders,
        hasReachedMax: filteredOrders.length < 10 ||
            filteredOrders.length >= pagination['total_count'],
        currentFilter: event.status,
        totalOrders: pagination['total_count'],
      ));
    } catch (e) {
      emit(OrderHistoryError('Failed to filter orders: ${e.toString()}'));
    }
  }

  Future<void> _onViewOrderDetails(
      ViewOrderDetails event, Emitter<OrderHistoryState> emit) async {
    emit(OrderDetailsLoading());
    try {
      // Call API to get order details
      final orderDetails =
          await orderHistoryService.getOrderDetails(event.orderId);

      emit(OrderDetailsLoaded(orderDetails));
    } catch (e) {
      emit(OrderHistoryError('Failed to load order details: ${e.toString()}'));
    }
  }

  Future<void> _onReorderItems(
      ReorderItems event, Emitter<OrderHistoryState> emit) async {
    emit(ReorderInProgress());
    try {
      // Call API to reorder items
      // final cartData = await orderHistoryService.reorder(event.orderId);

      // In a real implementation, you would also update the CartBloc with the new cart data
      // cartBloc.add(UpdateCartFromReorder(cartData));

      emit(const ReorderSuccess('Items have been added to your cart!'));
    } catch (e) {
      emit(ReorderFailure('Failed to reorder items: ${e.toString()}'));
    }
  }

  Future<void> _onSearchOrders(
      SearchOrders event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());
    try {
      // Call API to search orders
      final response = await orderHistoryService.searchOrders(
        searchTerm: event.searchTerm,
        startDate: event.startDate?.toIso8601String().split('T')[0],
        endDate: event.endDate?.toIso8601String().split('T')[0],
        page: 1,
        limit: 10,
      );

      final searchResults = response['orders'];
      final pagination = response['pagination'];

      emit(OrderHistoryLoaded(
        orders: searchResults,
        hasReachedMax: searchResults.length < 10 ||
            searchResults.length >= pagination['total_count'],
        currentFilter: 'search',
        totalOrders: pagination['total_count'],
        searchTerm: event.searchTerm,
      ));
    } catch (e) {
      emit(OrderHistoryError('Failed to search orders: ${e.toString()}'));
    }
  }
}
