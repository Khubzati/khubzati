part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutAddressSelectionState extends CheckoutState {
  // final List<AddressModel> availableAddresses;
  // final AddressModel? selectedAddress;
  final List<Map<String, dynamic>> availableAddresses;
  final Map<String, dynamic>? selectedAddress;
  final Map<String, Map<String, dynamic>> cartItems;
  final double subtotal;
  final double total;

  const CheckoutAddressSelectionState({
    required this.availableAddresses,
    this.selectedAddress,
    required this.cartItems,
    required this.subtotal,
    required this.total,
  });

  @override
  List<Object?> get props => [availableAddresses, selectedAddress, cartItems, subtotal, total];
}

class CheckoutPaymentSelectionState extends CheckoutState {
  // final List<PaymentMethodModel> availablePaymentMethods;
  // final PaymentMethodModel? selectedPaymentMethod;
  final List<Map<String, dynamic>> availablePaymentMethods;
  final Map<String, dynamic>? selectedPaymentMethod;
  final Map<String, dynamic> selectedAddress;
  final Map<String, Map<String, dynamic>> cartItems;
  final double subtotal;
  final double total;

  const CheckoutPaymentSelectionState({
    required this.availablePaymentMethods,
    this.selectedPaymentMethod,
    required this.selectedAddress,
    required this.cartItems,
    required this.subtotal,
    required this.total,
  });

  @override
  List<Object?> get props => [
        availablePaymentMethods,
        selectedPaymentMethod,
        selectedAddress,
        cartItems,
        subtotal,
        total
      ];
}

class CheckoutOrderSummaryState extends CheckoutState {
  final Map<String, dynamic> selectedAddress;
  final Map<String, dynamic> selectedPaymentMethod;
  final Map<String, Map<String, dynamic>> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const CheckoutOrderSummaryState({
    required this.selectedAddress,
    required this.selectedPaymentMethod,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  @override
  List<Object?> get props => [
        selectedAddress,
        selectedPaymentMethod,
        cartItems,
        subtotal,
        deliveryFee,
        tax,
        total
      ];
}

class CheckoutProcessingOrder extends CheckoutState {}

class CheckoutOrderSuccess extends CheckoutState {
  final String orderId;
  final double total;
  final String estimatedDeliveryTime;

  const CheckoutOrderSuccess({
    required this.orderId,
    required this.total,
    required this.estimatedDeliveryTime,
  });

  @override
  List<Object?> get props => [orderId, total, estimatedDeliveryTime];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressAddingState extends CheckoutState {}

class AddressAddedState extends CheckoutState {
  final Map<String, dynamic> newAddress;

  const AddressAddedState(this.newAddress);

  @override
  List<Object?> get props => [newAddress];
}
