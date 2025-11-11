// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/features/auth/presentation/widgets/progress_indicator.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_bloc_wrapper_screen.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../widgets/step_based_signup.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/utils/firebase_phone_helper.dart';
import '../../application/blocs/auth_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/app_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  final int _totalSteps =
      2; // Changed from 3 to 2 - hiding last step for bakery registration
  Map<String, dynamic>? _signupData;

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _handleSignupComplete(Map<String, dynamic> data) async {
    setState(() {
      _signupData = data;
    });

    // Get role from signup data or form
    final role = data['role'] ?? 'customer';
    final username = data['username'] ?? '';
    final email = data['email'] ?? '';
    final phone = data['phone'] ?? '';
    final password = data['password'] ?? '';

    // If bakery owner, store bakery data in preferences for later use after OTP verification
    if (role == 'bakery_owner') {
      final appPreferences = getIt<AppPreferences>();
      await appPreferences.setPendingBakeryData({
        'bakeryName': data['bakeryName'] ?? '',
        'location': data['location'] ?? '',
        'phone': phone,
        'email': email,
        'logo': data['logo'],
        'description': data['description'],
      });
    }

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        password.isNotEmpty) {
      // Store pending signup data to complete after OTP verification
      final appPreferences = getIt<AppPreferences>();
      await appPreferences.setPendingSignupData({
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      });

      // Format phone number for Firebase using helper
      String formattedPhone =
          FirebasePhoneHelper.formatJordanPhoneNumber(phone);

      // Check if it's a test number
      final isTestNumber =
          FirebasePhoneHelper.isTestPhoneNumber(formattedPhone);
      if (isTestNumber) {
        print('DEBUG: Using Firebase test phone number: $formattedPhone');
        print(
            'DEBUG: Test verification code will be: ${FirebasePhoneHelper.getTestVerificationCode()}');
      }

      print('DEBUG: Signup - Original phone: $phone');
      print('DEBUG: Signup - Formatted phone number: $formattedPhone');

      // TEMPORARY: Using Backend OTP instead of Firebase (APNs not configured)
      // TODO: Re-enable Firebase phone auth when APNs key is purchased
      /*
      // FIREBASE PHONE AUTH - COMMENTED OUT (APNs not configured)
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: formattedPhone,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) {
            print('DEBUG: Auto-verification completed');
          },
          verificationFailed: (FirebaseAuthException e) {
            print('DEBUG: Firebase verification failed: ${e.code} - ${e.message}');
            // ... error handling ...
          },
          codeSent: (String verificationId, int? resendToken) {
            // Navigate to OTP screen
            context.router.push(OtpVerificationRoute(
              phoneNumber: formattedPhone,
              verificationId: verificationId,
              purpose: 'registration',
            ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('DEBUG: Auto-retrieval timeout. Verification ID: $verificationId');
          },
        );
      } catch (e) {
        print('DEBUG: Exception during phone verification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      */

      // BACKEND REGISTRATION - Register directly (no OTP for signup)
      // Note: Backend register endpoint doesn't use OTP, it creates user directly
      try {
        if (!mounted) return;

        print('═══════════════════════════════════════════════════════════');
        print('🔐 BACKEND REGISTRATION (SIGNUP)');
        print('═══════════════════════════════════════════════════════════');
        print('📱 Phone Number: $formattedPhone');
        print('👤 Username: $username');
        print('📧 Email: $email');
        print('🎭 Role: $role');
        print('💡 Registering user directly with backend...');
        print('═══════════════════════════════════════════════════════════');

        // Register directly with backend (no OTP needed for registration)
        if (mounted) {
          context.read<AuthBloc>().add(SignupRequested(
                username: username,
                email: email,
                phone: formattedPhone,
                password: password,
                role: role,
              ));
        }
      } catch (e) {
        print('DEBUG: Exception during backend registration: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error during registration: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
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
                // Retry the verification by calling the signup handler again
                if (_signupData != null) {
                  _handleSignupComplete(_signupData!);
                }
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

  @override
  Widget build(BuildContext context) {
    return AppBlocWrapperScreen(
      appBar: const CustomAppBar(
        title: LocaleKeys.app_auth_signup_title,
      ),
      child: BlocListener<AuthBloc, AuthState>(
        bloc: getIt<AuthBloc>(),
        listener: (context, state) {
          if (state is OtpSent) {
            // After signup, navigate to OTP verification with real verification ID
            final phone = _signupData?['phone'] ?? '';
            context.router.push(OtpVerificationRoute(
              phoneNumber: phone,
              verificationId: state.verificationId,
              purpose: state.purpose,
            ));
          } else if (state is Authenticated) {
            // User registered and authenticated - bakery registration already handled in AuthBloc
            // Navigate to home
            context.router.push(MainNavigationRoute());
          } else if (state is BakeryRegistrationSuccess) {
            // Show success message and navigate
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Registration successful'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home or a "pending approval" screen
            context.router.push(MainNavigationRoute());
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            SignupProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StepBasedSignup(
                  onSignupComplete: _handleSignupComplete,
                  onStepChanged: _onStepChanged,
                ),
              ),
            ),
            // Login link at bottom
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.app_auth_already_have_account_prompt.tr(),
                    style: AppTextStyles.font16textDarkBrownBold,
                  ),
                  TextButton(
                    onPressed: () {
                      context.router.push(const LoginRoute());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                    ),
                    child: Text(
                      LocaleKeys.app_auth_login_link.tr(),
                      style: AppTextStyles.font16PrimaryBold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
