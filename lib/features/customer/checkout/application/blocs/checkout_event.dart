part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCheckout extends CheckoutEvent {
  // Optional: Pass cart data if not fetched from CartBloc
  final Map<String, Map<String, dynamic>>? cartItems;
  final double? subtotal;
  final double? total;

  const InitializeCheckout({this.cartItems, this.subtotal, this.total});

  @override
  List<Object?> get props => [cartItems, subtotal, total];
}

class LoadDeliveryAddresses extends CheckoutEvent {
  final Map<String, Map<String, dynamic>>? cartItems;
  final double? subtotal;
  final double? total;

  const LoadDeliveryAddresses({
    this.cartItems,
    this.subtotal,
    this.total,
  });

  @override
  List<Object?> get props => [cartItems, subtotal, total];
}

class SelectDeliveryAddress extends CheckoutEvent {
  final String addressId;
  // Or full address object if needed
  // final AddressModel address;

  const SelectDeliveryAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class AddNewDeliveryAddress extends CheckoutEvent {
  // final AddressModel address;
  // Using simple map for now
  final Map<String, dynamic> address;

  const AddNewDeliveryAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class LoadPaymentMethods extends CheckoutEvent {}

class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethodId;
  // Or full payment method object if needed
  // final PaymentMethodModel paymentMethod;

  const SelectPaymentMethod(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class PlaceOrder extends CheckoutEvent {
  // Any additional order details not already in state
  final String? notes;

  const PlaceOrder({this.notes});

  @override
  List<Object?> get props => [notes];
}
