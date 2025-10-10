part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String transactionId;
  final String orderId;
  final double amount;

  const PaymentSuccess({
    required this.transactionId,
    required this.orderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [transactionId, orderId, amount];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentStatusChecked extends PaymentState {
  final String orderId;
  final String status;
  final String? transactionId;

  const PaymentStatusChecked({
    required this.orderId,
    required this.status,
    this.transactionId,
  });

  @override
  List<Object?> get props => [orderId, status, transactionId];
}

class PaymentMethodsLoaded extends PaymentState {
  final List<Map<String, dynamic>> paymentMethods;

  const PaymentMethodsLoaded({required this.paymentMethods});

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodSaved extends PaymentState {
  final Map<String, dynamic> paymentMethod;

  const PaymentMethodSaved({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class PaymentMethodDeleted extends PaymentState {
  final String paymentMethodId;

  const PaymentMethodDeleted({required this.paymentMethodId});

  @override
  List<Object?> get props => [paymentMethodId];
}
