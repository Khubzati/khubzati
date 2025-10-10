import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';

class SharedFormTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlign textAlign;
  final bool isRequired;
  final String? errorText;

  const SharedFormTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.textAlign = TextAlign.right,
    this.isRequired = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional Label
          if (label != null) _buildLabel(),
          if (label != null) SizedBox(height: 8.h),

          // Input Field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            color: AppColors.creamColor,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            margin: EdgeInsets.only(right: 11.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRequired)
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  label!,
                  style: AppTextStyles.font14Primary700.copyWith(
                    color: AppColors.textDarkBrown,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: errorText != null ? Colors.red : const Color(0x75965641),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
        color: enabled ? Colors.white : AppColors.surfaceVariant,
      ),
      padding: contentPadding ??
          EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
          ),
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        textAlign: textAlign,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        enabled: enabled,
        style: AppTextStyles.font15TextW400.copyWith(
          color: enabled ? AppColors.textDarkBrown : AppColors.onSurfaceVariant,
          fontSize: 12.sp,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.font15TextW400.copyWith(
            color: const Color(0x75965641),
            fontSize: 12.sp,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          counterText: '',
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 10.sp,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// Predefined variants for common use cases
class SharedFormTextFieldVariants {
  static SharedFormTextField standard({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      isRequired: isRequired,
      errorText: errorText,
    );
  }

  static SharedFormTextField number({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      isRequired: isRequired,
      errorText: errorText,
    );
  }

  static SharedFormTextField email({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      isRequired: isRequired,
      errorText: errorText,
    );
  }

  static SharedFormTextField phone({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      isRequired: isRequired,
      errorText: errorText,
    );
  }

  static SharedFormTextField password({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    bool obscureText = true,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      isRequired: isRequired,
      errorText: errorText,
    );
  }

  static SharedFormTextField multiline({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    int maxLines = 3,
  }) {
    return SharedFormTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      isRequired: isRequired,
      errorText: errorText,
    );
  }
}
