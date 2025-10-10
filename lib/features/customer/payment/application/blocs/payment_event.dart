part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessPayment extends PaymentEvent {
  final String orderId;
  final double amount;
  final String? paymentMethodId;
  final String paymentMethod; // 'card', 'cash', 'wallet'
  final Map<String, dynamic>? cardDetails;

  const ProcessPayment({
    required this.orderId,
    required this.amount,
    this.paymentMethodId,
    required this.paymentMethod,
    this.cardDetails,
  });

  @override
  List<Object?> get props =>
      [orderId, amount, paymentMethodId, paymentMethod, cardDetails];
}

class CheckPaymentStatus extends PaymentEvent {
  final String orderId;

  const CheckPaymentStatus({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class GetPaymentMethods extends PaymentEvent {
  const GetPaymentMethods();
}

class SavePaymentMethod extends PaymentEvent {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final bool isDefault;

  const SavePaymentMethod({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
    required this.isDefault,
  });

  @override
  List<Object?> get props =>
      [cardNumber, expiryDate, cvv, cardholderName, isDefault];
}

class DeletePaymentMethod extends PaymentEvent {
  final String paymentMethodId;

  const DeletePaymentMethod({required this.paymentMethodId});

  @override
  List<Object?> get props => [paymentMethodId];
}
