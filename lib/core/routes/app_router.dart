import 'package:auto_route/auto_route.dart';
import 'package:khubzati/features/auth/presentation/screens/login_screen.dart';
import 'package:khubzati/features/auth/presentation/screens/signup_screen.dart';
import 'package:khubzati/features/onboarding/presentation/screens/role_selection_screen.dart';

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
  ];

  @override
  get defaultRouteType => const RouteType.custom();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page, initial: false),
        AutoRoute(page: SignupRoute.page, initial: false),
        AutoRoute(page: RoleSelectionRoute.page, initial: false),
      ];
}
