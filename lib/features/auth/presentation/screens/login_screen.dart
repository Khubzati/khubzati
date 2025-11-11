import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/services/localization_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/firebase_phone_helper.dart';
import '../../application/blocs/auth_bloc.dart';
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String? _formattedPhoneNumber; // Store formatted phone number
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
        } else if (state is OtpSent && state.purpose == 'login') {
          setState(() {
            _isLoading = false;
          });
          final contact = state.contact ?? state.verificationId;
          context.router.push(OtpVerificationRoute(
            phoneNumber: contact,
            verificationId: state.verificationId,
            purpose: state.purpose,
          ));
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
                      // Store formatted phone number from IntlPhoneField
                      if (phone != null) {
                        try {
                          _formattedPhoneNumber = phone.completeNumber;
                          print(
                              'DEBUG: Login phone number: $_formattedPhoneNumber');
                        } catch (e) {
                          print('DEBUG: Error extracting phone number: $e');
                          _formattedPhoneNumber = _phoneController.text;
                        }
                      }
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
    // Use formatted phone number if available, otherwise use controller text
    String phoneNumber = _formattedPhoneNumber ?? _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Format phone number (ensure proper format)
    String formattedPhone = phoneNumber.trim();

    // Remove any spaces or dashes
    formattedPhone = formattedPhone.replaceAll(RegExp(r'[\s\-]'), '');

    // Format phone number for Firebase using helper
    formattedPhone =
        FirebasePhoneHelper.formatJordanPhoneNumber(formattedPhone);

    // Check if it's a test number
    final isTestNumber = FirebasePhoneHelper.isTestPhoneNumber(formattedPhone);
    if (isTestNumber) {
      print('DEBUG: Using Firebase test phone number: $formattedPhone');
      print(
          'DEBUG: Test verification code will be: ${FirebasePhoneHelper.getTestVerificationCode()}');
    }

    print('DEBUG: Login - Formatted phone number: $formattedPhone');

    // TEMPORARY: Using Backend OTP instead of Firebase (APNs not configured)
    // TODO: Re-enable Firebase phone auth when APNs key is purchased
    /*
    // FIREBASE PHONE AUTH - COMMENTED OUT (APNs not configured)
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('DEBUG: Auto-verification completed for login');
          // Auto-sign in if available
          try {
            final userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            print(
                'DEBUG: Firebase sign-in successful: ${userCredential.user?.uid}');
            // After Firebase auth, proceed with backend login
            if (mounted) {
              context.read<AuthBloc>().add(LoginRequested(
                    emailOrPhone: formattedPhone,
                  ));
            }
          } catch (e) {
            print('DEBUG: Error during auto-verification sign-in: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Auto-verification failed: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print(
              'DEBUG: Firebase verification failed: ${e.code} - ${e.message}');
          print('DEBUG: Full error details: ${e.toString()}');
          print('DEBUG: Error code: ${e.code}');
          print('DEBUG: Error message: ${e.message}');
          if (e.stackTrace != null) {
            print('DEBUG: Stack trace: ${e.stackTrace}');
          }

          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });

          // Use helper to get user-friendly error message
          final errorMessage = FirebasePhoneHelper.getErrorMessage(
            e.code,
            defaultMessage: e.message,
          );

          if (mounted) {
            // Show dialog for critical errors that need user attention
            if (e.code == 'too-many-requests') {
              _showRateLimitDialog(context, errorMessage);
            } else if (e.code == 'internal-error') {
              // Show dialog for internal errors as they need attention
              _showInternalErrorDialog(context, errorMessage);
            } else {
              // Show snackbar for other errors
              final duration = e.code == 'operation-not-allowed'
                  ? const Duration(seconds: 8)
                  : const Duration(seconds: 5);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                  backgroundColor: Colors.red,
                  duration: duration,
                ),
              );
            }
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print('═══════════════════════════════════════════════════════════');
          print('🔐 FIREBASE OTP VERIFICATION');
          print('═══════════════════════════════════════════════════════════');
          print('📱 Phone Number: $formattedPhone');
          print('🆔 Verification ID: $verificationId');
          print('⚠️  NOTE: Firebase sends OTP via SMS. Check your phone for the code.');
          print('');
          print('💡 DEVELOPMENT TIP:');
          print('   Firebase does NOT expose OTP codes in the app.');
          print('   For testing, use Firebase test phone numbers:');
          print('   • Add in Firebase Console → Authentication → Phone');
          print('   • Test number: +1 650-555-3434');
          print('   • Test code: 123456 (always works)');
          print('   • Or use: +1 650-555-1234 with code: 123456');
          print('');
          print('📋 To see OTP in logs, use BACKEND API instead of Firebase:');
          print('   • Backend API returns OTP in development mode');
          print('   • Check backend server console for OTP code');
          print('═══════════════════════════════════════════════════════════');

          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });

          // Show helpful information about SMS delivery
          final isIOS = Platform.isIOS;
          if (isIOS) {
            // On iOS, Firebase uses silent push notifications (APNs) instead of SMS
            // If APNs is not configured, SMS might not be delivered
            print('📱 Platform: iOS - SMS delivery depends on APNs configuration');
            print('📱 If SMS not received, check APNs setup in Firebase Console');
          } else {
            print('📱 Platform: Android - SMS should be delivered via carrier');
          }
          
          // Check if it's a test number and show the test code
          final isTestNumber = FirebasePhoneHelper.isTestPhoneNumber(formattedPhone);
          if (isTestNumber) {
            final testCode = FirebasePhoneHelper.getTestVerificationCode();
            print('');
            print('🧪 TEST PHONE NUMBER DETECTED!');
            print('🔑 TEST OTP CODE: $testCode');
            print('💡 Use this code: $testCode');
            print('');
          }

          // Navigate to OTP screen with Firebase verificationId
          context.router.push(OtpVerificationRoute(
            phoneNumber: formattedPhone,
            verificationId: verificationId,
            purpose: 'login',
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('DEBUG: Auto-retrieval timeout for login. Verification ID: $verificationId');
        },
      );
    } catch (e, stackTrace) {
      print('DEBUG: Exception during phone verification: $e');
      print('DEBUG: Stack trace: $stackTrace');
      // ... error handling ...
    }
    */

    // BACKEND OTP FLOW - Using backend API to generate OTP
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      print('═══════════════════════════════════════════════════════════');
      print('🔐 BACKEND OTP REQUEST (LOGIN)');
      print('═══════════════════════════════════════════════════════════');
      print('📱 Phone Number: $formattedPhone');
      print('💡 Backend will generate OTP and log it to console');
      print('📋 Check your backend server console for the OTP code');
      print('═══════════════════════════════════════════════════════════');

      // Request OTP from backend (backend will generate and log OTP to console)
      if (mounted) {
        context.read<AuthBloc>().add(LoginRequested(
              emailOrPhone: formattedPhone,
            ));
      }
    } catch (e) {
      print('DEBUG: Exception during backend OTP request: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting OTP: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _showInternalErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Internal Error',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💡 Quick Solution for Testing:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Use a test phone number (no setup needed):',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        '+1 650-555-3434',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Code: 123456',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '2. Or fix Firebase configuration:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• Check FIREBASE_CONFIG_STATUS.md\n'
                        '• Verify GoogleService-Info.plist has real CLIENT_ID\n'
                        '• Set up APNs in Firebase Console',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Retry the verification
                _handleAuth();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void _showRateLimitDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Too Many Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💡 Quick Solution for Testing:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Use a test phone number (no setup needed):',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        '+1 650-555-3434',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Code: 123456',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '2. Or fix Firebase configuration:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• Check FIREBASE_CONFIG_STATUS.md\n'
                        '• Verify GoogleService-Info.plist has real CLIENT_ID\n'
                        '• Set up APNs in Firebase Console',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomeScreen(BuildContext context, String role) {
    // Navigate to appropriate screen based on user role
    // Use replaceAll to clear the navigation stack after successful login
    switch (role.toLowerCase()) {
      case 'customer':
        // Customer functionality not implemented yet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Customer interface is not available yet. Please contact support.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        // Log out the user
        context.read<AuthBloc>().add(LogoutRequested());
        break;
      case 'bakery_owner':
        // Navigate to bakery dashboard
        context.router.replaceAll([MainNavigationRoute()]);
        break;
      case 'restaurant_owner':
        // Navigate to restaurant dashboard
        context.router.replaceAll([const RestaurantOwnerHomeRoute()]);
        break;
      case 'driver':
        // Driver functionality not implemented yet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Driver interface is not available yet. Please contact support.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        // Log out the user
        context.read<AuthBloc>().add(LogoutRequested());
        break;
      default:
        context.router.replaceAll([MainNavigationRoute()]);
    }
  }
}
