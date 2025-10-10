import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class AppTextFormField extends StatelessWidget {
  final String? label;
  final bool? readOnly;
  final bool? obscureText;
  final bool? enableSuggestions;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? filled;
  final Color? fillColor;
  final InputBorder? disabledBorder;
  final String? initialValue;
  final double cursorWidth;
  final Color cursorColor;
  final Color cursorErrorColor;
  final String? hintText;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final Key? textFormkey;
  final int? maxLength;
  const AppTextFormField({
    super.key,
    this.label,
    this.suffixIcon,
    this.textEditingController,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly,
    this.obscureText,
    this.enableSuggestions,
    this.textInputAction,
    this.cursorWidth = 1.7,
    this.cursorColor = AppColors.textDarkBrown,
    this.cursorErrorColor = AppColors.textDarkBrown,
    this.onFieldSubmitted,
    this.enabled,
    this.filled,
    this.fillColor,
    this.disabledBorder,
    this.initialValue,
    this.keyboardType,
    this.style,
    this.textFormkey,
    this.hintText,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: textFormkey ?? ValueKey(context.locale),
          textInputAction: textInputAction ?? TextInputAction.next,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: label != null ? Text(label!).tr() : null,
            floatingLabelStyle: AppTextStyles.font20textDarkBrownbold,
            suffixIcon: suffixIcon,
            filled: filled,
            fillColor: fillColor,
            disabledBorder: disabledBorder,
            hintText: hintText,
            alignLabelWithHint: false,
            hintStyle: AppTextStyles.font14TextW400OP8,
            labelStyle: AppTextStyles.font20textDarkBrownbold,
          ),
          obscureText: obscureText ?? false,
          enableSuggestions: enableSuggestions ?? true,
          cursorWidth: cursorWidth.w,
          cursorColor: cursorColor,
          readOnly: readOnly ?? false,
          cursorErrorColor: cursorErrorColor,
          controller: textEditingController,
          validator: validator,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled ?? true,
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: style ?? AppTextStyles.font15TextW400,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
        ),
      ],
    );
  }
}
