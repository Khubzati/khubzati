part of 'order_confirmation_bloc.dart';

abstract class OrderConfirmationEvent extends Equatable {
  const OrderConfirmationEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderConfirmation extends OrderConfirmationEvent {
  final String orderId;

  const LoadOrderConfirmation({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class TrackOrder extends OrderConfirmationEvent {
  final String orderId;

  const TrackOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrderConfirmationEvent {
  final String orderId;
  final String? reason;

  const CancelOrder({required this.orderId, this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}

class RateOrder extends OrderConfirmationEvent {
  final String orderId;
  final int rating;
  final String? comment;

  const RateOrder({
    required this.orderId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [orderId, rating, comment];
}
