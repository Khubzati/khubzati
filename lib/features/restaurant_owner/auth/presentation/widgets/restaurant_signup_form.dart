import 'package:flutter/material.dart';
import 'package:khubzati/core/widgets/shared/app_text_field.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantSignupForm extends StatelessWidget {
  final TextEditingController restaurantNameController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const RestaurantSignupForm({
    super.key,
    required this.restaurantNameController,
    required this.phoneController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: restaurantNameController,
          hint: LocaleKeys.app_restaurant_owner_auth_restaurant_name_hint.tr(),
          label: LocaleKeys.app_restaurant_owner_auth_restaurant_name.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys
                  .app_restaurant_owner_auth_restaurant_name_required
                  .tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: phoneController,
          hint: LocaleKeys.app_restaurant_owner_auth_phone_number_hint.tr(),
          label: LocaleKeys.app_restaurant_owner_auth_phone_number.tr(),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.app_restaurant_owner_auth_phone_number_required
                  .tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: locationController,
          hint: LocaleKeys.app_restaurant_owner_auth_location_hint.tr(),
          label: LocaleKeys.app_restaurant_owner_auth_location.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.app_restaurant_owner_auth_location_required
                  .tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
