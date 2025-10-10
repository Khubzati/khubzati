import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
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

@RoutePage()
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
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

  @override
  Widget build(BuildContext context) {
    return AppBlocWrapperScreen(
      appBar: const CustomAppBar(
        title: LocaleKeys.app_otp_verification_title,
      ),
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
                35.verticalSpace,
                _buildOtpInputs(),
                35.verticalSpace,
                InkWell(
                  onTap: () {
                    // Handle resend code
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
            child: AppElevatedButton(
              onPressed: () {
                // Navigate to verify page after successful OTP verification
                context.router.push(const VerifyRoute());
              },
              child: Text(context.tr(LocaleKeys.app_otp_verification_verify)),
            ),
          ),
          40.verticalSpace,
        ],
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
