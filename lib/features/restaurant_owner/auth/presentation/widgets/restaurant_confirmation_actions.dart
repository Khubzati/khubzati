import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantConfirmationActions extends StatelessWidget {
  const RestaurantConfirmationActions({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: LocaleKeys.app_restaurant_owner_auth_logout.tr(),
      onPressed: () {
        context.router.popAndPush(const LoginRoute());
      },
    );
  }
}
