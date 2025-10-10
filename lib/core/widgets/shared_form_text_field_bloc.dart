// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/bloc/form_field/form_field_bloc.dart'
    as form_field_bloc;
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';

class SharedFormTextFieldBloc extends StatefulWidget {
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
  final String initialValue;
  final bool autoFocus;
  final bool readOnly;

  const SharedFormTextFieldBloc({
    super.key,
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
    this.textAlign = TextAlign.start,
    this.isRequired = false,
    this.errorText,
    this.initialValue = '',
    this.autoFocus = false,
    this.readOnly = false,
  });

  @override
  State<SharedFormTextFieldBloc> createState() =>
      _SharedFormTextFieldBlocState();
}

class _SharedFormTextFieldBlocState extends State<SharedFormTextFieldBloc> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final form_field_bloc.FormFieldBloc _formFieldBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _formFieldBloc = form_field_bloc.FormFieldBloc(
      validator: widget.validator,
      initialValue: widget.initialValue,
    );

    _focusNode.addListener(() {
      _formFieldBloc
          .add(form_field_bloc.FormFieldFocusChanged(_focusNode.hasFocus));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _formFieldBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formFieldBloc,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional Label
            if (widget.label != null) _buildLabel(),
            if (widget.label != null) SizedBox(height: 8.h),

            // Input Field
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.creamColor,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isRequired)
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  widget.label!,
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
    return BlocBuilder<form_field_bloc.FormFieldBloc,
        form_field_bloc.FormFieldState>(
      builder: (context, state) {
        final isError =
            state is form_field_bloc.FormFieldUpdated && !state.isValid;
        final isFocused =
            state is form_field_bloc.FormFieldUpdated && state.isFocused;

        return Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isFocused
                  ? AppColors.primaryBurntOrange
                  : AppColors.primaryBurntOrange.withOpacity(0.6),
              width: isFocused ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: widget.contentPadding ??
              EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 12.w,
              ),
          width: double.infinity,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            textAlign: widget.textAlign,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              _formFieldBloc.add(form_field_bloc.FormFieldTextChanged(value));
              widget.onChanged?.call(value);
            },
            onFieldSubmitted: (value) {
              _formFieldBloc
                  .add(const form_field_bloc.FormFieldValidationRequested());
            },
            style: AppTextStyles.font15TextW400.copyWith(
              color: widget.enabled
                  ? AppColors.textDarkBrown
                  : AppColors.onSurfaceVariant,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.font15TextW400.copyWith(
                overflow: TextOverflow.ellipsis,
                color: AppColors.textDarkBrown.withOpacity(0.2),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              counterText: '',
              errorStyle:
                  AppTextStyles.font14Primary700.copyWith(color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}

// BLoC-based variants for common use cases
class SharedFormTextFieldBlocVariants {
  static SharedFormTextFieldBloc standard({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }

  static SharedFormTextFieldBloc number({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }

  static SharedFormTextFieldBloc email({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }

  static SharedFormTextFieldBloc phone({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }

  static SharedFormTextFieldBloc password({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    bool obscureText = true,
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }

  static SharedFormTextFieldBloc multiline({
    String? label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isRequired = false,
    String? errorText,
    String initialValue = '',
    int maxLines = 3,
    bool autoFocus = false,
    bool readOnly = false,
  }) {
    return SharedFormTextFieldBloc(
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      isRequired: isRequired,
      errorText: errorText,
      autoFocus: autoFocus,
      readOnly: readOnly,
    );
  }
}

// Helper widget to get form field state
class FormFieldStateBuilder extends StatelessWidget {
  final Widget Function(
      BuildContext context, form_field_bloc.FormFieldState state) builder;

  const FormFieldStateBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<form_field_bloc.FormFieldBloc,
        form_field_bloc.FormFieldState>(
      builder: builder,
    );
  }
}

// Helper widget to get form field value
class FormFieldValueBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, String value, bool hasChanged)
      builder;

  const FormFieldValueBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<form_field_bloc.FormFieldBloc,
        form_field_bloc.FormFieldState>(
      builder: (context, state) {
        if (state is form_field_bloc.FormFieldUpdated) {
          return builder(context, state.text, state.hasChanged);
        }
        return builder(context, '', false);
      },
    );
  }
}
