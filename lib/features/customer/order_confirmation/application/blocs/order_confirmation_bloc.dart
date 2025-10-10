import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/customer/order_confirmation/data/services/order_confirmation_service.dart';

part 'order_confirmation_event.dart';
part 'order_confirmation_state.dart';

class OrderConfirmationBloc
    extends Bloc<OrderConfirmationEvent, OrderConfirmationState> {
  final OrderConfirmationService orderConfirmationService;

  OrderConfirmationBloc({required this.orderConfirmationService})
      : super(OrderConfirmationInitial()) {
    on<LoadOrderConfirmation>(_onLoadOrderConfirmation);
    on<TrackOrder>(_onTrackOrder);
    on<CancelOrder>(_onCancelOrder);
    on<RateOrder>(_onRateOrder);
    on<SendOrderReceipt>(_onSendOrderReceipt);
    on<ConfirmOrderReceipt>(_onConfirmOrderReceipt);
    on<ReportOrderIssue>(_onReportOrderIssue);
  }

  Future<void> _onLoadOrderConfirmation(
      LoadOrderConfirmation event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderConfirmationLoading());
    try {
      // Get order confirmation details from API
      final orderData =
          await orderConfirmationService.getOrderConfirmation(event.orderId);

      // Determine if order can be cancelled based on status
      // Usually only possible if order is still in 'confirmed' or 'preparing' state
      final status = orderData['status'] as String;
      final canCancel = status == 'confirmed' || status == 'preparing';

      emit(OrderConfirmationLoaded(
        order: orderData,
        orderStatus: status,
        estimatedDeliveryTime:
            orderData['estimated_delivery_time'] ?? 'Not available',
        canCancel: canCancel,
      ));
    } catch (e) {
      emit(OrderConfirmationError(
          'Failed to load order confirmation: ${e.toString()}'));
    }
  }

  Future<void> _onTrackOrder(
      TrackOrder event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderConfirmationLoading());
    try {
      // Get order details from API
      final orderData =
          await orderConfirmationService.getOrderConfirmation(event.orderId);

      // In a real implementation, you would have a separate tracking endpoint
      // For now, we'll use the order confirmation data and extract tracking information
      final status = orderData['status'] as String;
      final trackingSteps =
          orderData['tracking_steps'] as List<Map<String, dynamic>>? ?? [];
      final deliveryPerson =
          orderData['delivery_person'] as Map<String, dynamic>? ?? {};
      final location = orderData['location'] as Map<String, dynamic>? ?? {};

      emit(OrderTrackingState(
        order: orderData,
        currentStatus: status,
        trackingSteps: trackingSteps,
        estimatedDeliveryTime:
            orderData['estimated_delivery_time'] ?? 'Not available',
        deliveryPerson: deliveryPerson,
        location: location,
      ));
    } catch (e) {
      emit(OrderConfirmationError('Failed to track order: ${e.toString()}'));
    }
  }

  Future<void> _onCancelOrder(
      CancelOrder event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderCancellationInProgress());
    try {
      // Call API to cancel the order
      final result = await orderConfirmationService.cancelOrder(
          event.orderId, event.reason ?? '');

      emit(OrderCancellationSuccess(
        orderId: event.orderId,
        message:
            result['message'] ?? 'Your order has been successfully cancelled.',
      ));
    } catch (e) {
      emit(OrderConfirmationError('Failed to cancel order: ${e.toString()}'));
    }
  }

  Future<void> _onRateOrder(
      RateOrder event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderRatingInProgress());
    try {
      // Prepare review data
      final reviewData = {
        'rating': event.rating,
        'comment': event.comment,
      };

      // Submit review to API
      final result = await orderConfirmationService.submitOrderReview(
          event.orderId, reviewData);

      emit(OrderRatingSuccess(
        orderId: event.orderId,
        rating: event.rating,
        message: 'Thank you for your feedback!',
      ));
    } catch (e) {
      emit(OrderConfirmationError('Failed to submit rating: ${e.toString()}'));
    }
  }

  Future<void> _onSendOrderReceipt(
      SendOrderReceipt event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderReceiptSendingInProgress());
    try {
      // Call API to send receipt
      final success = await orderConfirmationService.sendOrderReceipt(
        event.orderId,
        email: event.email,
      );

      if (success) {
        emit(OrderReceiptSendingSuccess(
          message: 'Receipt has been sent to ${event.email ?? 'your email'}.',
        ));
      } else {
        emit(const OrderConfirmationError('Failed to send receipt.'));
      }
    } catch (e) {
      emit(OrderConfirmationError('Failed to send receipt: ${e.toString()}'));
    }
  }

  Future<void> _onConfirmOrderReceipt(
      ConfirmOrderReceipt event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderConfirmationLoading());
    try {
      // Call API to confirm receipt of order
      final result =
          await orderConfirmationService.confirmOrderReceipt(event.orderId);

      emit(OrderReceiptConfirmed(
        orderId: event.orderId,
        message: 'Thank you for confirming your order receipt.',
      ));

      // Reload order confirmation to show updated status
      add(LoadOrderConfirmation(orderId: event.orderId));
    } catch (e) {
      emit(OrderConfirmationError(
          'Failed to confirm order receipt: ${e.toString()}'));
    }
  }

  Future<void> _onReportOrderIssue(
      ReportOrderIssue event, Emitter<OrderConfirmationState> emit) async {
    emit(OrderIssueReportingInProgress());
    try {
      // Prepare issue data
      final issueData = {
        'issue_type': event.issueType,
        'description': event.description,
        'images': event.images,
      };

      // Call API to report issue
      final result = await orderConfirmationService.reportOrderIssue(
          event.orderId, issueData);

      emit(OrderIssueReportingSuccess(
        orderId: event.orderId,
        ticketId: result['ticket_id'],
        message: 'Your issue has been reported. We will get back to you soon.',
      ));
    } catch (e) {
      emit(OrderConfirmationError('Failed to report issue: ${e.toString()}'));
    }
  }
}
