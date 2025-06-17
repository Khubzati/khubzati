import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final void Function(String)? onChanged;
  final FocusNode focusNode;

  const OtpInputField({
    super.key,
    required this.controller,
    this.autoFocus = false,
    this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      height: 49.h,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: AppTextStyles.otpInput.copyWith(fontSize: 20),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 7.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppColors.primaryBurntOrange,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppColors.primaryBurntOrange,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppColors.primaryBurntOrange,
              width: 1,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
