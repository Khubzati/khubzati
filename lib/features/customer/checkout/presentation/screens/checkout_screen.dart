import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_text_field.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/customer/checkout/application/blocs/checkout_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedPaymentMethod = 'cash';
  String? _selectedAddressId;
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutBloc>().add(const InitializeCheckout());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.app_checkout_title.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const AppLoadingWidget(
              message: 'Loading checkout...',
            );
          }

          if (state is CheckoutError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<CheckoutBloc>().add(const InitializeCheckout());
              },
            );
          }

          return _buildCheckoutContent(context, state);
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildCheckoutContent(BuildContext context, CheckoutState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            _buildSectionTitle(context, 'Contact Information'),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Full Name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address Selection
            _buildAddressSection(context),
            const SizedBox(height: 24),

            // Payment Method
            _buildSectionTitle(context, 'Payment Method'),
            const SizedBox(height: 16),

            _buildPaymentOption(
                context, 'Cash on Delivery', 'cash', Icons.money),
            const SizedBox(height: 12),
            _buildPaymentOption(
                context, 'Credit/Debit Card', 'card', Icons.credit_card),
            const SizedBox(height: 12),
            _buildPaymentOption(context, 'Digital Wallet', 'wallet',
                Icons.account_balance_wallet),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, String title, String value, IconData icon) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isSelected = _selectedPaymentMethod == value;

    return AppCard(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Order Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$25.99', // This should come from the cart state
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Place Order Button
          AppButton(
            text: 'Place Order',
            onPressed: _placeOrder,
            type: AppButtonType.primary,
            size: AppButtonSize.large,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Delivery Address'),
        const SizedBox(height: 16),
        if (_selectedAddress != null)
          AppCard(
            onTap: () => _selectAddress(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedAddress!['label'] ?? 'Address',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedAddress!['address'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedAddress!['city'] ?? ''}, ${_selectedAddress!['state'] ?? ''} ${_selectedAddress!['postal_code'] ?? ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        else
          AppCard(
            onTap: () => _selectAddress(context),
            child: Row(
              children: [
                Icon(
                  Icons.add_location,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select or add delivery address',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _selectAddress(BuildContext context) async {
    final result = await context.router.push(
      AddressListRoute(isSelectionMode: true),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedAddress = result;
        _selectedAddressId = result['id'];
      });
    }
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to payment screen
    context.router.push(
      PaymentRoute(
        orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
        amount: 25.99, // This should come from cart state
        selectedAddressId: _selectedAddressId,
      ),
    );
  }
}
