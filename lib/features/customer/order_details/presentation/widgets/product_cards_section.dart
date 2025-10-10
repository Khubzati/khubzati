import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/order_details_model.dart';
import 'product_card.dart';

class ProductCardsSection extends StatelessWidget {
  final List<OrderProduct> products;

  const ProductCardsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        12.verticalSpace,
        ...products.map((product) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: ProductCard(product: product),
            )),
      ],
    );
  }
}
