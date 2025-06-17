part of 'order_confirmation_bloc.dart';

abstract class OrderConfirmationState extends Equatable {
  const OrderConfirmationState();

  @override
  List<Object?> get props => [];
}

class OrderConfirmationInitial extends OrderConfirmationState {}

class OrderConfirmationLoading extends OrderConfirmationState {}

class OrderConfirmationLoaded extends OrderConfirmationState {
  // final OrderModel order;
  // Using placeholder map for now
  final Map<String, dynamic> order;
  final String orderStatus; // "confirmed", "preparing", "out_for_delivery", "delivered", "cancelled"
  final String estimatedDeliveryTime;
  final bool canCancel; // Whether the order can still be cancelled

  const OrderConfirmationLoaded({
    required this.order,
    required this.orderStatus,
    required this.estimatedDeliveryTime,
    this.canCancel = false,
  });

  @override
  List<Object?> get props => [order, orderStatus, estimatedDeliveryTime, canCancel];
}

class OrderTrackingState extends OrderConfirmationState {
  final Map<String, dynamic> order;
  final String currentStatus;
  final List<Map<String, dynamic>> trackingSteps;
  final String estimatedDeliveryTime;
  final Map<String, dynamic>? deliveryPerson;
  final Map<String, dynamic>? location;

  const OrderTrackingState({
    required this.order,
    required this.currentStatus,
    required this.trackingSteps,
    required this.estimatedDeliveryTime,
    this.deliveryPerson,
    this.location,
  });

  @override
  List<Object?> get props => [
        order,
        currentStatus,
        trackingSteps,
        estimatedDeliveryTime,
        deliveryPerson,
        location
      ];
}

class OrderCancellationInProgress extends OrderConfirmationState {}

class OrderCancellationSuccess extends OrderConfirmationState {
  final String orderId;
  final String message;

  const OrderCancellationSuccess({
    required this.orderId,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, message];
}

class OrderRatingInProgress extends OrderConfirmationState {}

class OrderRatingSuccess extends OrderConfirmationState {
  final String orderId;
  final int rating;
  final String message;

  const OrderRatingSuccess({
    required this.orderId,
    required this.rating,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, rating, message];
}

class OrderConfirmationError extends OrderConfirmationState {
  final String message;

  const OrderConfirmationError(this.message);

  @override
  List<Object?> get props => [message];
}
