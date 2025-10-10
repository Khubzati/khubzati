import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import 'bread_info_step.dart';
import 'personal_info_step.dart';
import 'signup_form.dart';

class StepBasedSignup extends StatefulWidget {
  final Function(Map<String, dynamic>) onSignupComplete;
  final Function(int)? onStepChanged;

  const StepBasedSignup({
    super.key,
    required this.onSignupComplete,
    this.onStepChanged,
  });

  @override
  State<StepBasedSignup> createState() => _StepBasedSignupState();
}

class _StepBasedSignupState extends State<StepBasedSignup> {
  int _currentStep = 0;

  Map<String, dynamic> _personalInfoData = {};
  Map<String, dynamic> _breadInfoData = {};
  final Map<String, dynamic> _accountData = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        32.verticalSpace,
        // Step Content
        _buildStepContent(),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return PersonalInfoStep(
          onDataChanged: (data) {
            _personalInfoData = data;
          },
          onNext: () {
            setState(() {
              _currentStep++;
            });
            widget.onStepChanged?.call(_currentStep);
          },
        );
      case 1:
        return BreadInfoStep(
          onDataChanged: (data) {
            _breadInfoData = data;
          },
          onNext: () {
            setState(() {
              _currentStep++;
            });
            widget.onStepChanged?.call(_currentStep);
          },
          phoneNumber: _personalInfoData['phone'] ??
              '', // Pass phone number from personal info
        );
      case 2:
        return _buildAccountStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_auth_signup_title.tr(),
          style: AppTextStyles.font20textDarkBrownbold,
        ),
        8.verticalSpace,
        Text(
          LocaleKeys.app_auth_signup_subheading.tr(),
          style: AppTextStyles.font15TextW400,
        ),
        32.verticalSpace,
        const SignupForm(),
        40.verticalSpace,
        // Complete Signup Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBurntOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              LocaleKeys.app_auth_signup_button.tr(),
              style: AppTextStyles.font16TextW500,
            ),
          ),
        ),
      ],
    );
  }

  void _completeSignup() {
    // Combine all form data
    Map<String, dynamic> completeData = {
      ..._personalInfoData,
      ..._breadInfoData,
      ..._accountData,
    };

    widget.onSignupComplete(completeData);
  }
}
