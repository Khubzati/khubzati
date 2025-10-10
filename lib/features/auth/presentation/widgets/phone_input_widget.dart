import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class PhoneInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<dynamic>? onChanged;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_form_phone_label.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDarkBrown,
          ),
        ),
        8.verticalSpace,
        Container(
          width: 358.w,
          height: 56.h,
          padding: EdgeInsets.only(top: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primaryBurntOrange.withOpacity(0.46),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: IntlPhoneField(
            controller: controller,
            onChanged: onChanged,
            initialCountryCode: 'JO',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: AppTextStyles.font16textDarkBrownBold,
            flagsButtonPadding: EdgeInsets.only(left: 16.w),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: LocaleKeys.app_form_phone_hint.tr(),
              hintStyle: AppTextStyles.font12PrimaryBurntOrange,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 16.w),
              isDense: true,
              alignLabelWithHint: true,
            ),
            dropdownIcon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            dropdownTextStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textDarkBrown,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
