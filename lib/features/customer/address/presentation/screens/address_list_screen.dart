import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/customer/address/application/blocs/address_bloc.dart';

@RoutePage()
class AddressListScreen extends StatelessWidget {
  final bool isSelectionMode;
  final String? selectedAddressId;

  const AddressListScreen({
    super.key,
    this.isSelectionMode = false,
    this.selectedAddressId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc(
        addressService: context.read(),
      )..add(const LoadAddresses()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isSelectionMode ? 'Select Address' : 'My Addresses',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (!isSelectionMode)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.router.push(
                    AddEditAddressRoute(),
                  );
                },
              ),
          ],
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AddressLoading) {
              return const AppLoadingWidget(
                message: 'Loading addresses...',
              );
            }

            if (state is AddressError) {
              return _buildErrorState(context, state.message);
            }

            if (state is AddressesLoaded) {
              return _buildAddressList(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: !isSelectionMode
            ? FloatingActionButton(
                onPressed: () {
                  context.router.push(
                    AddEditAddressRoute(),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: context.theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Retry',
            onPressed: () {
              context.read<AddressBloc>().add(const LoadAddresses());
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, AddressesLoaded state) {
    if (state.addresses.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.addresses.length,
      itemBuilder: (context, index) {
        final address = state.addresses[index];
        return _buildAddressCard(context, address);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Addresses Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first address to start ordering food',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Add Address',
              onPressed: () {
                context.router.push(
                  AddEditAddressRoute(),
                );
              },
              type: AppButtonType.primary,
              size: AppButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Map<String, dynamic> address) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isSelected = isSelectionMode && selectedAddressId == address['id'];
    final isDefault = address['is_default'] == true;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: isSelectionMode
          ? () {
              context.router.maybePop(address);
            }
          : null,
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
                  address['label'] ?? 'Address',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address['address'] ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['postal_code'] ?? ''}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address['country'] ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (!isSelectionMode) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Edit',
                    onPressed: () {
                      context.router.push(
                        AddEditAddressRoute(
                          addressId: address['id'],
                          initialData: address,
                        ),
                      );
                    },
                    type: AppButtonType.outline,
                    size: AppButtonSize.small,
                  ),
                ),
                const SizedBox(width: 12),
                if (!isDefault)
                  Expanded(
                    child: AppButton(
                      text: 'Set Default',
                      onPressed: () {
                        context.read<AddressBloc>().add(
                              SetDefaultAddress(
                                addressId: address['id'],
                              ),
                            );
                      },
                      type: AppButtonType.primary,
                      size: AppButtonSize.small,
                    ),
                  ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: colorScheme.error,
                  ),
                  onPressed: () {
                    _showDeleteConfirmation(context, address);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete "${address['label']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AddressBloc>().add(
                    DeleteAddress(addressId: address['id']),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
