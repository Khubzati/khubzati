import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_text_field.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantChefSection extends StatelessWidget {
  final TextEditingController chefNameController;
  final List<String> chefs;
  final VoidCallback onAddChef;

  const RestaurantChefSection({
    super.key,
    required this.chefNameController,
    required this.chefs,
    required this.onAddChef,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: chefNameController,
          hint: LocaleKeys.app_restaurant_owner_auth_chef_name_hint.tr(),
          label: LocaleKeys.app_restaurant_owner_auth_chef_name.tr(),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onAddChef,
          child: Text(
            LocaleKeys.app_restaurant_owner_auth_add_chef.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (chefs.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            LocaleKeys.app_restaurant_owner_auth_chefs_list.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...chefs.map((chef) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $chef',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
