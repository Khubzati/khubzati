import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  Map<String, dynamic>? _selectedVariants;
  final List<String> _selectedAddons = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TODO: Load product detail
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Loading product detail for ${widget.productId}'),
          backgroundColor: context.colorScheme.primary,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProductDetailView(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildProductDetailView(BuildContext context) {
    final colorScheme = context.colorScheme;

    // Mock product data
    final product = {
      'name': 'Delicious Pizza',
      'price': 15.99,
      'rating': 4.5,
      'review_count': 128,
      'description':
          'A delicious pizza with fresh ingredients and amazing taste.',
      'image': null,
      'variants': [],
      'addons': [],
      'nutrition': {
        'calories': 350,
        'protein': 15,
        'carbs': 45,
        'fat': 12,
      },
    };

    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          floating: false,
          pinned: true,
          backgroundColor: colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Product Image
                product['image'] != null
                    ? Image.network(
                        product['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.fastfood,
                              size: 64,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.fastfood,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // TODO: Implement favorite functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Implement share functionality
              },
            ),
          ],
        ),

        // Product Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Price
                _buildProductHeader(context, product),
                const SizedBox(height: 24),

                // Product Description
                _buildProductDescription(context, product),
                const SizedBox(height: 24),

                // Variants (if any)
                if (product['variants'] != null &&
                    (product['variants'] as List).isNotEmpty)
                  _buildVariantsSection(context, product),

                // Add-ons (if any)
                if (product['addons'] != null &&
                    (product['addons'] as List).isNotEmpty)
                  _buildAddonsSection(context, product),

                // Quantity Selector
                _buildQuantitySelector(context),
                const SizedBox(height: 24),

                // Nutritional Information
                if (product['nutrition'] != null)
                  _buildNutritionSection(context, product),

                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(
      BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'] ?? '',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${product['price'] ?? 0.0}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product['original_price'] != null &&
                product['original_price'] > product['price']) ...[
              const SizedBox(width: 12),
              Text(
                '\$${product['original_price']}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '${product['rating'] ?? 0.0}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${product['review_count'] ?? 0} reviews)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductDescription(
      BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product['description'] ?? 'No description available.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSection(
      BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final variants = product['variants'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Variant',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...variants.map((variant) => _buildVariantOption(context, variant)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVariantOption(
      BuildContext context, Map<String, dynamic> variant) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () {
        setState(() {
          _selectedVariants = variant;
        });
      },
      child: Row(
        children: [
          Radio<Map<String, dynamic>>(
            value: variant,
            groupValue: _selectedVariants,
            onChanged: (value) {
              setState(() {
                _selectedVariants = value;
              });
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variant['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (variant['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    variant['description'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${variant['price'] ?? 0.0}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonsSection(
      BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final addons = product['addons'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-ons',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...addons.map((addon) => _buildAddonOption(context, addon)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAddonOption(BuildContext context, Map<String, dynamic> addon) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isSelected = _selectedAddons.contains(addon['id']);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAddons.remove(addon['id']);
          } else {
            _selectedAddons.add(addon['id']);
          }
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedAddons.add(addon['id']);
                } else {
                  _selectedAddons.remove(addon['id']);
                }
              });
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (addon['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    addon['description'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${addon['price'] ?? 0.0}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Quantity',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _quantity > 1
                    ? () {
                        setState(() {
                          _quantity--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$_quantity',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection(
      BuildContext context, Map<String, dynamic> product) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final nutrition = product['nutrition'] as Map<String, dynamic>;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutritional Information',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutritionItem(
                  context, 'Calories', '${nutrition['calories'] ?? 0}'),
              _buildNutritionItem(
                  context, 'Protein', '${nutrition['protein'] ?? 0}g'),
              _buildNutritionItem(
                  context, 'Carbs', '${nutrition['carbs'] ?? 0}g'),
              _buildNutritionItem(context, 'Fat', '${nutrition['fat'] ?? 0}g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(BuildContext context, String label, String value) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    // Mock product data
    final product = {
      'name': 'Delicious Pizza',
      'price': 15.99,
      'addons': [],
    };

    // Calculate total price
    double totalPrice = (product['price'] as double? ?? 0.0) * _quantity;
    if (_selectedVariants != null) {
      totalPrice += (_selectedVariants!['price'] ?? 0.0) * _quantity;
    }
    for (String addonId in _selectedAddons) {
      final addon = (product['addons'] as List<Map<String, dynamic>>)
          .firstWhere((a) => a['id'] == addonId);
      totalPrice += (addon['price'] ?? 0.0) * _quantity;
    }

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
      child: Row(
        children: [
          // Price
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Add to Cart Button
          AppButton(
            text: 'Add to Cart',
            onPressed: () {
              // TODO: Implement add to cart
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added to cart successfully!'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
            type: AppButtonType.primary,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }
}
