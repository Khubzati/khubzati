import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_event.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_state.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_bloc.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_otp_header.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_otp_input.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_otp_actions.dart';

@RoutePage()
class RestaurantOtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const RestaurantOtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<RestaurantOtpVerificationScreen> createState() =>
      _RestaurantOtpVerificationScreenState();
}

class _RestaurantOtpVerificationScreenState
    extends State<RestaurantOtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleKeys.app_otp_verification_title.tr(),
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
        listener: (context, state) {
          if (state is RestaurantOtpVerified) {
            context.router.push(const RestaurantSignupConfirmationRoute());
          } else if (state is RestaurantSignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RestaurantOtpHeader(phoneNumber: widget.phoneNumber),
              const SizedBox(height: 30),
              RestaurantOtpInput(
                controllers: _otpControllers,
                focusNodes: _focusNodes,
              ),
              const SizedBox(height: 20),
              BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
                builder: (context, state) {
                  return RestaurantOtpActions(
                    onResendOtp: _resendOtp,
                    onChangePhone: _changePhoneNumber,
                    onVerify: _verifyOtp,
                    isLoading: state is RestaurantSignupLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resendOtp() {
    context.read<RestaurantSignupBloc>().add(
          RestaurantOtpResendRequested(widget.phoneNumber),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.app_restaurant_owner_auth_otp_resent.tr()),
      ),
    );
  }

  void _changePhoneNumber() {
    context.router.maybePop();
  }

  void _verifyOtp() {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      context.read<RestaurantSignupBloc>().add(
            RestaurantOtpVerificationRequested(
              phoneNumber: widget.phoneNumber,
              otp: otp,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.app_restaurant_owner_auth_enter_otp.tr()),
        ),
      );
    }
  }
}
