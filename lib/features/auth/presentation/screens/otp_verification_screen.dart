import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_bloc_wrapper_screen.dart';
import '../../../../core/widgets/app_custom_scroll_view.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../../../../core/widgets/otp_input_field.dart';
import '../../application/blocs/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/app_preferences.dart';

@RoutePage()
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final String purpose;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.purpose,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      print('═══════════════════════════════════════════════════════════');
      print('🔐 OTP VERIFICATION ATTEMPT');
      print('═══════════════════════════════════════════════════════════');
      print('📱 Phone Number: ${widget.phoneNumber}');
      print('🆔 Verification ID: ${widget.verificationId}');
      print('🔑 Entered OTP: $otp');
      print('🎯 Purpose: ${widget.purpose}');
      print('═══════════════════════════════════════════════════════════');

      try {
        // TEMPORARY: Using Backend OTP instead of Firebase (APNs not configured)
        // TODO: Re-enable Firebase phone auth when APNs key is purchased
        /*
        // FIREBASE OTP VERIFICATION - COMMENTED OUT (APNs not configured)
        final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('✅ OTP verification successful!');
        */

        // BACKEND OTP VERIFICATION - Verify OTP with backend API
        print('✅ Verifying OTP with backend...');

        if (widget.purpose == 'registration') {
          // For signup, verify OTP then register
          final prefs = getIt<AppPreferences>();
          final signup = await prefs.getPendingSignupData();
          if (signup != null) {
            // Verify OTP first, then register
            context.read<AuthBloc>().add(OtpVerificationRequested(
                  verificationId: widget
                      .verificationId, // This is the phone number for backend
                  otp: otp,
                  purpose: 'registration',
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup data not found.')),
            );
          }
        } else if (widget.purpose == 'login') {
          // For login, verify OTP with backend
          // verificationId is the phone number/email for backend
          context.read<AuthBloc>().add(OtpVerificationRequested(
                verificationId: widget.verificationId,
                otp: otp,
                purpose: 'login',
              ));
        }
      } catch (e) {
        print('❌ OTP verification failed: $e');
        print('💡 Make sure you entered the correct 6-digit code');
        print('💡 Check backend server console for the OTP code');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP code'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        // Go back to login screen
        context.router.replaceAll([const LoginRoute()]);
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
        // Go back to login screen
        context.router.replaceAll([const LoginRoute()]);
        break;
      default:
        context.router.replaceAll([MainNavigationRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocWrapperScreen(
      appBar: const CustomAppBar(
        title: LocaleKeys.app_otp_verification_title,
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent &&
              state.purpose == widget.purpose &&
              state.verificationId == widget.verificationId) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'OTP resent successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is Authenticated) {
            // Navigate to appropriate screen based on user role
            _navigateToHomeScreen(context, state.role);
          } else if (state is BakeryRegistrationSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Registration successful'),
                backgroundColor: Colors.green,
              ),
            );
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
          children: [
            LinearProgressIndicator(
              value: 0,
              backgroundColor: AppColors.tertiaryOliveGreen.withOpacity(0.7),
            ),
            Expanded(
              child: AppCustomScrollView(
                children: [
                  35.verticalSpace,
                  Center(child: SvgPicture.asset(Assets.images.otp)),
                  32.verticalSpace,
                  Text(context.tr(LocaleKeys.app_otp_verification_instruction),
                      style: AppTextStyles.font16textDarkBrownBold),
                  Center(
                    child: Text(widget.phoneNumber,
                        style: AppTextStyles.font16textDarkBrownBold),
                  ),
                  16.verticalSpace,
                  _buildSmsDeliveryInfo(),
                  if (kDebugMode) _buildDevelopmentHelper(),
                  19.verticalSpace,
                  _buildOtpInputs(),
                  35.verticalSpace,
                  InkWell(
                    onTap: () async {
                      // Resend OTP using Firebase
                      try {
                        print('DEBUG: Resending OTP to ${widget.phoneNumber}');
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: widget.phoneNumber,
                          timeout: const Duration(seconds: 60),
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            print(
                                'DEBUG: Resend failed: ${e.code} - ${e.message}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to resend OTP: ${e.message ?? 'Unknown error'}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            print(
                                'DEBUG: OTP resent. New Verification ID: $verificationId');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTP code resent successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error resending OTP: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      context.tr(LocaleKeys.app_otp_verification_resend_code),
                      style: AppTextStyles.font16PrimaryBold,
                    ),
                  ),
                  16.verticalSpace,
                  InkWell(
                    onTap: () {
                      // Handle change phone number
                      context.router.maybePop();
                    },
                    child: Text(
                      context.tr(LocaleKeys.app_otp_verification_change_phone),
                      style: AppTextStyles.font16PrimaryBold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return AppElevatedButton(
                    onPressed: isLoading ? null : _verifyOtp,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            context.tr(LocaleKeys.app_otp_verification_verify)),
                  );
                },
              ),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildSmsDeliveryInfo() {
    final isIOS = Platform.isIOS;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
                SizedBox(width: 8.w),
                Text(
                  'SMS Delivery Info',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              isIOS
                  ? 'On iOS, SMS may take a few minutes. If you don\'t receive it, check:\n• APNs is configured in Firebase\n• Phone number is correct\n• Try resending the code'
                  : 'SMS should arrive within 1-2 minutes. If not received:\n• Check your phone number\n• Check signal strength\n• Try resending the code',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentHelper() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.developer_mode,
                    size: 18, color: Colors.orange.shade700),
                SizedBox(width: 8.w),
                Text(
                  'Development Helper',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '💡 OTP Code Location:\n'
              '• Firebase: Check SMS on your phone\n'
              '• Backend: Check server console logs\n'
              '• Look for "🔑 OTP CODE:" in logs',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.orange.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInputs() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => OtpInputField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autoFocus: index == 0,
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  _focusNodes[index + 1].requestFocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
