import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/widgets/app_text_field.dart';
import 'package:khubzati/features/customer/order_history/application/blocs/order_history_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class OrderSearchBar extends StatefulWidget {
  const OrderSearchBar({super.key});

  @override
  State<OrderSearchBar> createState() => _OrderSearchBarState();
}

class _OrderSearchBarState extends State<OrderSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      context.read<OrderHistoryBloc>().add(
            SearchOrders(searchTerm: _searchController.text.trim()),
          );
    } else {
      // If search is empty, fetch all orders
      context.read<OrderHistoryBloc>().add(const FetchOrderHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: AppTextFormField(
        textEditingController: _searchController,
        hintText: LocaleKeys.app_search_hint.tr(),
        suffixIcon: IconButton(
          onPressed: _performSearch,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onChanged: (value) {
          // Optional: Perform search as user types (debounced)
          if (value!.trim().isEmpty) {
            _performSearch();
          }
        },
        onFieldSubmitted: (_) => _performSearch(),
      ),
    );
  }
}
