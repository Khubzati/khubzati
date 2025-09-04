import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/customer/checkout/data/services/checkout_service.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutService checkoutService;

  CheckoutBloc({
    required this.checkoutService,
  }) : super(CheckoutInitial()) {
    on<InitializeCheckout>(_onInitializeCheckout);
    on<LoadDeliveryAddresses>(_onLoadDeliveryAddresses);
    on<SelectDeliveryAddress>(_onSelectDeliveryAddress);
    on<AddNewDeliveryAddress>(_onAddNewDeliveryAddress);
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onInitializeCheckout(
      InitializeCheckout event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      // Get cart data from event or from CartBloc
      final cartItems = event.cartItems ??
          {}; // Placeholder, should get from CartBloc if not provided
      final subtotal = event.subtotal ?? 0.0;
      final total = event.total ?? 0.0;

      // Proceed to address selection
      add(LoadDeliveryAddresses());

      // Note: The actual transition to address selection state will happen in _onLoadDeliveryAddresses
      // This is just to initialize the checkout process
    } catch (e) {
      emit(CheckoutError('Failed to initialize checkout: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDeliveryAddresses(
      LoadDeliveryAddresses event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      // Get addresses from the API
      final addressesResponse = await checkoutService.getDeliveryAddresses();

      // Transform API response to the format expected by the UI
      final addresses = addressesResponse
          .map((addr) => {
                'id': addr['id'],
                'name': addr['name'],
                'street': addr['street'],
                'city': addr['city'],
                'state': addr['state'],
                'country': addr['country'],
                'postalCode': addr['postal_code'],
                'isDefault': addr['is_default'] ?? false,
              })
          .toList();

      // Get cart data (in a real app, this would come from CartBloc or be passed in the event)
      final cartItems = event.cartItems ?? {};
      final subtotal = event.subtotal ?? 0.0;
      final total = event.total ?? 0.0;

      // Find default address if any
      final defaultAddress = addresses.firstWhere(
        (addr) => addr['isDefault'] == true,
        orElse: () => addresses.isNotEmpty ? addresses.first : {},
      );

      emit(CheckoutAddressSelectionState(
        availableAddresses: addresses,
        selectedAddress: defaultAddress.isNotEmpty ? defaultAddress : null,
        cartItems: cartItems,
        subtotal: subtotal,
        total: total,
      ));
    } catch (e) {
      emit(CheckoutError('Failed to load delivery addresses: ${e.toString()}'));
    }
  }

  void _onSelectDeliveryAddress(
      SelectDeliveryAddress event, Emitter<CheckoutState> emit) {
    if (state is CheckoutAddressSelectionState) {
      final currentState = state as CheckoutAddressSelectionState;

      // Find the selected address
      final selectedAddress = currentState.availableAddresses.firstWhere(
        (addr) => addr['id'] == event.addressId,
        orElse: () => {},
      );

      if (selectedAddress.isNotEmpty) {
        // Update state with selected address
        emit(CheckoutAddressSelectionState(
          availableAddresses: currentState.availableAddresses,
          selectedAddress: selectedAddress,
          cartItems: currentState.cartItems,
          subtotal: currentState.subtotal,
          total: currentState.total,
        ));

        // Move to payment selection
        add(LoadPaymentMethods());
      } else {
        emit(CheckoutError('Selected address not found'));
      }
    }
  }

  Future<void> _onAddNewDeliveryAddress(
      AddNewDeliveryAddress event, Emitter<CheckoutState> emit) async {
    if (state is CheckoutAddressSelectionState) {
      final currentState = state as CheckoutAddressSelectionState;
      emit(AddressAddingState());

      try {
        // Call API to add new address
        final newAddress =
            await checkoutService.addDeliveryAddress(event.address);

        // Transform API response to the format expected by the UI
        final formattedAddress = {
          'id': newAddress['id'],
          'name': newAddress['name'],
          'street': newAddress['street'],
          'city': newAddress['city'],
          'state': newAddress['state'],
          'country': newAddress['country'],
          'postalCode': newAddress['postal_code'],
          'isDefault': newAddress['is_default'] ?? false,
        };

        // Notify UI that address was added
        emit(AddressAddedState(formattedAddress));

        // Reload addresses to include the new one
        add(LoadDeliveryAddresses());
      } catch (e) {
        emit(CheckoutError('Failed to add new address: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadPaymentMethods(
      LoadPaymentMethods event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      // Get payment methods from the API
      final paymentMethodsResponse = await checkoutService.getPaymentMethods();

      // Transform API response to the format expected by the UI
      final paymentMethods = paymentMethodsResponse
          .map((pm) => {
                'id': pm['id'],
                'type': pm['type'],
                'brand': pm['brand'],
                'last4': pm['last4'],
                'isDefault': pm['is_default'] ?? false,
                'name': pm['name'],
              })
          .toList();

      // Get current state data
      if (state is CheckoutAddressSelectionState) {
        final addressState = state as CheckoutAddressSelectionState;
        final selectedAddress = addressState.selectedAddress!;

        // Find default payment method if any
        final defaultPaymentMethod = paymentMethods.firstWhere(
          (pm) => pm['isDefault'] == true,
          orElse: () => paymentMethods.isNotEmpty ? paymentMethods.first : {},
        );

        emit(CheckoutPaymentSelectionState(
          availablePaymentMethods: paymentMethods,
          selectedPaymentMethod:
              defaultPaymentMethod.isNotEmpty ? defaultPaymentMethod : null,
          selectedAddress: selectedAddress,
          cartItems: addressState.cartItems,
          subtotal: addressState.subtotal,
          total: addressState.total,
        ));
      } else {
        emit(CheckoutError('Invalid state transition to payment selection'));
      }
    } catch (e) {
      emit(CheckoutError('Failed to load payment methods: ${e.toString()}'));
    }
  }

  void _onSelectPaymentMethod(
      SelectPaymentMethod event, Emitter<CheckoutState> emit) async {
    if (state is CheckoutPaymentSelectionState) {
      final currentState = state as CheckoutPaymentSelectionState;

      // Find the selected payment method
      final selectedPaymentMethod =
          currentState.availablePaymentMethods.firstWhere(
        (pm) => pm['id'] == event.paymentMethodId,
        orElse: () => {},
      );

      if (selectedPaymentMethod.isNotEmpty) {
        emit(CheckoutLoading());

        try {
          // Calculate delivery fees based on selected address and cart items
          final deliveryFeesResponse =
              await checkoutService.calculateDeliveryFees(
            currentState.selectedAddress['id'],
            currentState.cartItems.values.toList(),
          );

          // Extract delivery fee and tax from response
          final deliveryFee = deliveryFeesResponse['delivery_fee'] ?? 0.0;
          final tax = deliveryFeesResponse['tax'] ?? 0.0;
          final subtotal = currentState.subtotal;
          final total = subtotal + deliveryFee + tax;

          // Move to order summary
          emit(CheckoutOrderSummaryState(
            selectedAddress: currentState.selectedAddress,
            selectedPaymentMethod: selectedPaymentMethod,
            cartItems: currentState.cartItems,
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            tax: tax,
            total: total,
          ));
        } catch (e) {
          emit(CheckoutError(
              'Failed to calculate delivery fees: ${e.toString()}'));
        }
      } else {
        emit(CheckoutError('Selected payment method not found'));
      }
    }
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event, Emitter<CheckoutState> emit) async {
    if (state is CheckoutOrderSummaryState) {
      final currentState = state as CheckoutOrderSummaryState;
      emit(CheckoutProcessingOrder());

      try {
        // Prepare order data
        final orderData = {
          'address_id': currentState.selectedAddress['id'],
          'payment_method_id': currentState.selectedPaymentMethod['id'],
          'items': currentState.cartItems.values.toList(),
          'subtotal': currentState.subtotal,
          'delivery_fee': currentState.deliveryFee,
          'tax': currentState.tax,
          'total': currentState.total,
          'notes': event.notes,
        };

        // Validate checkout data first
        await checkoutService.validateCheckout(orderData);

        // Place the order
        final orderResponse = await checkoutService.placeOrder(orderData);

        // Extract order details from response
        final orderId = orderResponse['id'];
        final estimatedDeliveryTime = orderResponse['estimated_delivery_time'];

        // Process payment if needed
        if (currentState.selectedPaymentMethod['type'] != 'cash_on_delivery') {
          final paymentData = {
            'payment_method_id': currentState.selectedPaymentMethod['id'],
            // Add any additional payment data required by the payment gateway
          };

          await checkoutService.processPayment(orderId, paymentData);
        }

        // Order success
        emit(CheckoutOrderSuccess(
          orderId: orderId,
          total: currentState.total,
          estimatedDeliveryTime: estimatedDeliveryTime,
        ));

        // In a real app, you would also clear the cart here via CartBloc
      } catch (e) {
        emit(CheckoutError('Failed to place order: ${e.toString()}'));
      }
    }
  }
}
