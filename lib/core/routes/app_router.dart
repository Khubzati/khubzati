import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:khubzati/features/auth/presentation/screens/login_screen.dart';
import 'package:khubzati/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:khubzati/features/auth/presentation/screens/signup_screen.dart';
import 'package:khubzati/features/auth/presentation/screens/verify_page.dart';
import 'package:khubzati/features/customer/product_detail/presentation/screens/product_detail_screen.dart';
import 'package:khubzati/features/home_page/presentation/page/home_page.dart';
import 'package:khubzati/features/customer/cart/presentation/screens/cart_screen.dart';
import 'package:khubzati/features/customer/checkout/presentation/screens/checkout_screen.dart';
import 'package:khubzati/features/customer/home/presentation/screens/customer_home_screen.dart';
import 'package:khubzati/features/customer/vendor_detail/presentation/screens/vendor_detail_screen.dart';
import 'package:khubzati/features/customer/vendor_listing/presentation/screens/vendor_listing_screen.dart';
import 'package:khubzati/features/onboarding/presentation/screens/role_selection_screen.dart';
import 'package:khubzati/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/screens/restaurant_owner_dashboard_screen.dart';
import 'package:khubzati/features/driver/dashboard/presentation/screens/driver_dashboard_screen.dart';
import 'package:khubzati/features/customer/payment/presentation/screens/payment_screen.dart';
import 'package:khubzati/features/customer/order_confirmation/presentation/screens/order_confirmation_screen.dart';
import 'package:khubzati/features/customer/address/presentation/screens/address_list_screen.dart';
import 'package:khubzati/features/customer/address/presentation/screens/add_edit_address_screen.dart';
import 'package:khubzati/features/customer/reviews/presentation/screens/review_screen.dart';
import 'package:khubzati/features/customer/reviews/presentation/screens/add_review_screen.dart';
import 'package:khubzati/features/notifications/presentation/screens/notification_screen.dart';
import 'package:khubzati/features/customer/order_details/presentation/screens/order_details_screen.dart';
import 'package:khubzati/features/inventory/presentation/pages/inventory_screen.dart';
import 'package:khubzati/features/inventory/presentation/pages/product_detail_screen.dart';
import 'package:khubzati/features/inventory/presentation/pages/edit_product_screen.dart';
import 'package:khubzati/features/inventory/presentation/pages/add_new_item_screen.dart';
import 'package:khubzati/features/customer/profile/presentation/screens/profile_settings_screen.dart';
import 'main_navigation_screen.dart';

import '../di/injection.dart';
import '../services/app_preferences.dart';
import '../splash.dart';
part 'app_router.gr.dart';

class AuthGuard implements AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (getIt<AppPreferences>().isLoggedIn()) {
      resolver.next();
    } else {
      router.removeLast();
      router.push(const RoleSelectionRoute());
    }
  }
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final unAuthenticatedRoutes = [
    SplashRoute.name,
    LoginRoute.name,
    RoleSelectionRoute.name,
    SignupRoute.name,
    OtpVerificationRoute.name,
    VerifyRoute.name,
    MainNavigationRoute.name,
  ];

  @override
  get defaultRouteType => const RouteType.custom();

  @override
  List<AutoRoute> get routes => [
        // AutoRoute(page: SplashRoute.page, initial: true),
        // AutoRoute(page: LoginRoute.page, initial: false),
        // AutoRoute(page: SignupRoute.page, initial: false),
        // AutoRoute(page: OtpVerificationRoute.page, initial: false),
        // AutoRoute(page: VerifyRoute.page, initial: false),
        AutoRoute(page: MainNavigationRoute.page, initial: true),
        AutoRoute(page: RoleSelectionRoute.page, initial: false),
        AutoRoute(page: WelcomeRoute.page, initial: false),
        AutoRoute(page: CustomerHomeRoute.page, initial: false),
        AutoRoute(page: VendorListingRoute.page, initial: false),
        AutoRoute(page: VendorDetailRoute.page, initial: false),
        AutoRoute(page: InventoryProductDetailRoute.page, initial: false),
        AutoRoute(page: CartRoute.page, initial: false),
        AutoRoute(page: CheckoutRoute.page, initial: false),
        AutoRoute(page: RestaurantOwnerDashboardRoute.page, initial: false),
        AutoRoute(page: DriverDashboardRoute.page, initial: false),
        AutoRoute(page: PaymentRoute.page, initial: false),
        AutoRoute(page: OrderConfirmationRoute.page, initial: false),
        AutoRoute(page: AddressListRoute.page, initial: false),
        AutoRoute(page: AddEditAddressRoute.page, initial: false),
        AutoRoute(page: ReviewRoute.page, initial: false),
        AutoRoute(page: AddReviewRoute.page, initial: false),
        AutoRoute(page: NotificationRoute.page, initial: false),
        AutoRoute(page: OrderDetailsRoute.page, initial: false),
        AutoRoute(page: InventoryRoute.page, initial: false),
        AutoRoute(page: InventoryProductDetailRoute.page, initial: false),
        AutoRoute(page: EditProductRoute.page, initial: false),
        AutoRoute(page: AddNewItemRoute.page, initial: false),
        AutoRoute(page: ProfileSettingsRoute.page, initial: false),
      ];
}
