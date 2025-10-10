import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/customer/payment/application/blocs/payment_bloc.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;
  final String? selectedAddressId;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    this.selectedAddressId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card';
  String? _selectedPaymentMethodId;
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const GetPaymentMethods());
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(
        paymentService: context.read(),
      )..add(const GetPaymentMethods()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              // Navigate to order confirmation
              context.router.push(
                OrderConfirmationRoute(
                  orderId: state.orderId,
                  transactionId: state.transactionId,
                ),
              );
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading || state is PaymentProcessing) {
              return const AppLoadingWidget(
                message: 'Processing payment...',
              );
            }

            return _buildPaymentContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildPaymentContent(BuildContext context, PaymentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary
          _buildOrderSummary(context),
          const SizedBox(height: 24),

          // Payment Methods
          _buildPaymentMethodsSection(context, state),
          const SizedBox(height: 24),

          // Card Details (if card selected)
          if (_selectedPaymentMethod == 'card') ...[
            _buildCardDetailsSection(context),
            const SizedBox(height: 24),
          ],

          // Pay Button
          _buildPayButton(context),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID:',
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                '#${widget.orderId}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection(BuildContext context, PaymentState state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Cash on Delivery
          _buildPaymentMethodOption(
            context,
            'cash',
            'Cash on Delivery',
            'Pay when your order arrives',
            Icons.money,
          ),
          const SizedBox(height: 12),

          // Card Payment
          _buildPaymentMethodOption(
            context,
            'card',
            'Credit/Debit Card',
            'Pay with your card',
            Icons.credit_card,
          ),
          const SizedBox(height: 12),

          // Wallet Payment
          _buildPaymentMethodOption(
            context,
            'wallet',
            'Digital Wallet',
            'Pay with your wallet balance',
            Icons.account_balance_wallet,
          ),

          // Saved Payment Methods
          if (state is PaymentMethodsLoaded &&
              state.paymentMethods.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Saved Payment Methods',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...state.paymentMethods
                .map((method) => _buildSavedPaymentMethod(context, method)),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context,
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
          _selectedPaymentMethodId = null; // Reset saved method selection
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                    _selectedPaymentMethodId = null;
                  });
                }
              },
              activeColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPaymentMethod(
      BuildContext context, Map<String, dynamic> method) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isSelected = _selectedPaymentMethodId == method['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = 'card';
          _selectedPaymentMethodId = method['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.credit_card,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '**** **** **** ${method['last_four_digits']}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Expires ${method['expiry_date']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method['id'],
              groupValue: _selectedPaymentMethodId,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = 'card';
                    _selectedPaymentMethodId = value;
                  });
                }
              },
              activeColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailsSection(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Details',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Card Number
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.replaceAll(' ', '').length < 16) {
                  return 'Please enter a valid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Expiry Date and CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (value.length < 3) {
                        return 'Please enter a valid CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cardholder Name
            TextFormField(
              controller: _cardholderNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cardholder name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return AppButton(
      text: 'Pay \$${widget.amount.toStringAsFixed(2)}',
      onPressed: _processPayment,
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
    );
  }

  void _processPayment() {
    if (_selectedPaymentMethod == 'card' && _selectedPaymentMethodId == null) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    Map<String, dynamic>? cardDetails;
    if (_selectedPaymentMethod == 'card' && _selectedPaymentMethodId == null) {
      cardDetails = {
        'card_number': _cardNumberController.text,
        'expiry_date': _expiryDateController.text,
        'cvv': _cvvController.text,
        'cardholder_name': _cardholderNameController.text,
      };
    }

    context.read<PaymentBloc>().add(ProcessPayment(
          orderId: widget.orderId,
          amount: widget.amount,
          paymentMethodId: _selectedPaymentMethodId,
          paymentMethod: _selectedPaymentMethod,
          cardDetails: cardDetails,
        ));
  }
}
