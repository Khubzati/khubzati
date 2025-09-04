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

class SendOrderReceipt extends OrderConfirmationEvent {
  final String orderId;
  final String? email;

  const SendOrderReceipt({required this.orderId, this.email});

  @override
  List<Object?> get props => [orderId, email];
}

class ConfirmOrderReceipt extends OrderConfirmationEvent {
  final String orderId;

  const ConfirmOrderReceipt({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ReportOrderIssue extends OrderConfirmationEvent {
  final String orderId;
  final String issueType;
  final String? description;
  final List<dynamic>?
      images; // Could be List<File> or URLs depending on implementation

  const ReportOrderIssue({
    required this.orderId,
    required this.issueType,
    this.description,
    this.images,
  });

  @override
  List<Object?> get props => [orderId, issueType, description, images];
}
