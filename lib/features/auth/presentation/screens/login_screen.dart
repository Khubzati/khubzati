import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/services/localization_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_router.dart';
import '../../application/blocs/auth_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  LocalizationService get localizationService {
    try {
      return getIt<LocalizationService>();
    } catch (e) {
      // Return a default service if dependency injection fails
      return LocalizationService();
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AuthError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is Authenticated) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to appropriate screen based on user role
          _navigateToHomeScreen(context, state.role);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBurntOrange.withOpacity(0.1),
                AppColors.pageBackground,
                AppColors.secondaryLightCream,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  LoginHeaderWidget(
                    fadeAnimation: _fadeAnimation,
                    scaleAnimation: _scaleAnimation,
                    onLanguageToggle: _toggleLanguage,
                  ),
                  LoginFormWidget(
                    slideAnimation: _slideAnimation,
                    phoneController: _phoneController,
                    onPhoneChanged: (phone) {
                      // Handle phone number change
                    },
                  ),
                  40.verticalSpace,
                  AuthSectionWidget(
                    onAuthPressed: _isLoading ? null : _handleAuth,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleLanguage() {
    try {
      final currentLocale = localizationService.getCurrentLocale(context);
      final newLocale = currentLocale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');

      localizationService.setLocaleFromLocale(context, newLocale);
    } catch (e) {
      // Fallback: use context directly if service is not available
      final currentLocale = context.locale;
      final newLocale = currentLocale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');

      context.setLocale(newLocale);
    }
  }

  void _handleAuth() async {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Trigger login with AuthBloc
    context.read<AuthBloc>().add(LoginRequested(
          emailOrPhone: _phoneController.text.trim(),
          password:
              'default_password', // This should be handled properly in a real app
        ));
  }

  void _navigateToHomeScreen(BuildContext context, String role) {
    // Navigate to appropriate screen based on user role
    switch (role.toLowerCase()) {
      case 'customer':
        context.router.push(MainNavigationRoute());
        break;
      case 'bakery_owner':
        // Navigate to bakery dashboard
        context.router.push(MainNavigationRoute());
        break;
      case 'restaurant_owner':
        // Navigate to restaurant dashboard
        context.router.push(const RestaurantOwnerHomeRoute());
        break;
      case 'driver':
        context.router.push(MainNavigationRoute());
        break;
      default:
        context.router.push(MainNavigationRoute());
    }
  }
}
