import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/shared_form_text_field_bloc.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'customer';
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_form_username_label.tr(),
            hint: LocaleKeys.app_form_username_hint.tr(),
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              if (value.length < 2) {
                return 'Username must be at least 2 characters';
              }
              return null;
            },
            onChanged: (value) {
              _usernameController.text = value;
            },
          ),

          16.verticalSpace,

          // Email Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_form_email_label.tr(),
            hint: LocaleKeys.app_form_email_hint.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              if (!value.contains('@')) {
                return LocaleKeys.app_form_validation_invalid_email.tr();
              }
              return null;
            },
            onChanged: (value) {
              _emailController.text = value;
            },
          ),
          16.verticalSpace,

          // Phone Field with PhoneFormField
          _buildPhoneField(),
          16.verticalSpace,

          // Role Selection
          _buildRoleSelection(),
          16.verticalSpace,

          // Password Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_form_password_label.tr(),
            hint: LocaleKeys.app_form_password_hint.tr(),
            obscureText: _obscurePassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              if (value.length < 6) {
                return LocaleKeys.app_form_validation_password_short.tr();
              }
              return null;
            },
            onChanged: (value) {
              _passwordController.text = value;
            },
          ),
          16.verticalSpace,

          // Confirm Password Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_form_confirm_password_label.tr(),
            hint: LocaleKeys.app_form_confirm_password_hint.tr(),
            obscureText: _obscureConfirmPassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              if (value != _passwordController.text) {
                return LocaleKeys.app_form_validation_password_mismatch.tr();
              }
              return null;
            },
            onChanged: (value) {
              _confirmPasswordController.text = value;
            },
          ),
          16.verticalSpace,

          // Terms and Conditions
          _buildTermsAndConditions(),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_form_phone_label.tr(),
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        PhoneFormField(
          key: const ValueKey('phone'),
          controller: PhoneController(),
          decoration: InputDecoration(
            hintText: LocaleKeys.app_form_phone_hint.tr(),
            hintStyle: TextStyle(
              color: AppColors.textDarkBrown.withOpacity(0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: AppColors.creamColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.primaryBurntOrange.withOpacity(0.3),
                width: 1.5.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primaryBurntOrange,
                width: 2,
              ),
            ),
            prefixIcon: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBurntOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
            ),
          ),
          defaultCountry: IsoCode.JO,
          validator: (phone) {
            if (phone == null || phone.international.isEmpty) {
              return LocaleKeys.app_form_validation_required.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.creamColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryBurntOrange.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkBrown,
              ),
              items: [
                DropdownMenuItem(
                  value: 'customer',
                  child: Text(LocaleKeys.app_roles_customer.tr()),
                ),
                DropdownMenuItem(
                  value: 'bakery_owner',
                  child: Text(LocaleKeys.app_roles_bakery_owner.tr()),
                ),
                DropdownMenuItem(
                  value: 'restaurant_owner',
                  child: Text(LocaleKeys.app_roles_restaurant_owner.tr()),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value ?? 'customer';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: AppColors.primaryBurntOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              LocaleKeys.app_auth_terms_and_conditions_prompt.tr(),
              style: AppTextStyles.font15TextW400,
            ),
          ),
        ),
      ],
    );
  }
}
