import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import 'personal_info_form.dart';
import 'signup_form.dart';

class MultiStepSignupForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSignupComplete;

  const MultiStepSignupForm({
    super.key,
    required this.onSignupComplete,
  });

  @override
  State<MultiStepSignupForm> createState() => _MultiStepSignupFormState();
}

class _MultiStepSignupFormState extends State<MultiStepSignupForm> {
  int _currentStep = 0;
  final int _totalSteps = 2;

  Map<String, dynamic> _personalInfoData = {};
  final Map<String, dynamic> _accountData = {};

  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Indicator
        _buildProgressIndicator(),
        32.verticalSpace,

        // Step Content
        Expanded(
          child: _buildStepContent(),
        ),

        // Navigation Buttons
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          children: List.generate(_totalSteps, (index) {
            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: index <= _currentStep
                      ? AppColors.primaryBurntOrange
                      : AppColors.tertiaryOliveGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        ),
        8.verticalSpace,
        Text(
          'Step ${_currentStep + 1} of $_totalSteps',
          style: AppTextStyles.font14TextW400OP8,
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAccountStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTextStyles.font20textDarkBrownbold,
        ),
        8.verticalSpace,
        Text(
          'Please provide your bakery details',
          style: AppTextStyles.font15TextW400,
        ),
        24.verticalSpace,
        PersonalInfoForm(
          onDataChanged: (data) {
            _personalInfoData = data;
          },
        ),
      ],
    );
  }

  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Details',
          style: AppTextStyles.font20textDarkBrownbold,
        ),
        8.verticalSpace,
        Text(
          'Create your account credentials',
          style: AppTextStyles.font15TextW400,
        ),
        24.verticalSpace,
        const SignupForm(),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBurntOrange,
                side: const BorderSide(
                  color: AppColors.primaryBurntOrange,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Previous',
                style: AppTextStyles.font16PrimaryBold,
              ),
            ),
          ),
        if (_currentStep > 0) 16.horizontalSpace,
        Expanded(
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBurntOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              _currentStep == _totalSteps - 1 ? 'Complete Signup' : 'Next',
              style: AppTextStyles.font16TextW500,
            ),
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate personal info form
      if (_personalInfoFormKey.currentState?.validate() ?? false) {
        setState(() {
          _currentStep++;
        });
      }
    } else if (_currentStep == _totalSteps - 1) {
      // Validate account form and complete signup
      if (_accountFormKey.currentState?.validate() ?? false) {
        _completeSignup();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeSignup() {
    // Combine all form data
    Map<String, dynamic> completeData = {
      ..._personalInfoData,
      ..._accountData,
    };

    widget.onSignupComplete(completeData);
  }
}
