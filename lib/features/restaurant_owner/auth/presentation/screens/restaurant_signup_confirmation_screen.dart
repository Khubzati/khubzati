import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_confirmation_logo.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_confirmation_content.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_confirmation_actions.dart';

@RoutePage()
class RestaurantSignupConfirmationScreen extends StatelessWidget {
  const RestaurantSignupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RestaurantConfirmationLogo(),
                40.verticalSpace,
                const RestaurantConfirmationContent(),
                40.verticalSpace,
                const RestaurantConfirmationActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
