// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController bakeryNameController;
  final TextEditingController addressController;
  final PhoneController phoneNumberController;
  final bool isEditing;
  final Function(String) onBakeryNameChanged;
  final Function(String) onAddressChanged;
  final Function(PhoneNumber?) onPhoneNumberChanged;

  const ProfileForm({
    super.key,
    required this.bakeryNameController,
    required this.addressController,
    required this.phoneNumberController,
    required this.isEditing,
    required this.onBakeryNameChanged,
    required this.onAddressChanged,
    required this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bakery Name Field
        _buildFormField(
          label: LocaleKeys.app_profile_bakery_name.tr(),
          controller: bakeryNameController,
          onChanged: onBakeryNameChanged,
          enabled: isEditing,
        ),
        20.verticalSpace,

        // Address Field
        _buildFormField(
          label: LocaleKeys.app_profile_address.tr(),
          controller: addressController,
          onChanged: onAddressChanged,
          enabled: isEditing,
        ),
        20.verticalSpace,

        // Phone Number Field
        _buildPhoneField(
          label: LocaleKeys.app_profile_phone_number.tr(),
          controller: phoneNumberController,
          onChanged: onPhoneNumberChanged,
          enabled: isEditing,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font16textDarkBrownBold,
          textAlign: TextAlign.right,
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown,
                width: 2.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            filled: true,
            fillColor: enabled
                ? AppColors.creamColor
                : AppColors.creamColor.withOpacity(0.5),
          ),
          textAlign: TextAlign.right,
          style: AppTextStyles.font14TextW400OP8,
        ),
      ],
    );
  }

  Widget _buildPhoneField({
    required String label,
    required PhoneController controller,
    required Function(PhoneNumber?) onChanged,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font16textDarkBrownBold,
          textAlign: TextAlign.right,
        ),
        8.verticalSpace,
        PhoneFormField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: LocaleKeys.app_form_phone_hint.tr(),
            hintStyle: TextStyle(
              color: AppColors.textDarkBrown.withOpacity(0.6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: enabled
                ? AppColors.creamColor
                : AppColors.creamColor.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.textDarkBrown,
                width: 2.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
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
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
