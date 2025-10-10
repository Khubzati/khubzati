import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class CustomDropDown extends StatefulWidget {
  final String? label;
  final String hintText;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final bool isRequired;

  const CustomDropDown({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) _buildLabel(),
          if (widget.label != null) SizedBox(height: 8.h),

          // Field container with outer border
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _isFocused
                    ? AppColors.primaryBurntOrange
                    : AppColors.primaryBurntOrange.withOpacity(0.4),
                width: _isFocused ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                focusNode: _focusNode,
                initialValue: widget.selectedItem,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  counterText: '',
                ),
                hint: Text(
                  widget.hintText,
                  style: AppTextStyles.font15TextW400.copyWith(
                    color: AppColors.primaryBurntOrange.withOpacity(0.46),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryBurntOrange,
                  size: 20.sp,
                ),
                style: AppTextStyles.font15TextW400.copyWith(
                  color: AppColors.textDarkBrown,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                onChanged: widget.onChanged,
                items: widget.items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
                  context.tr(widget.label!),
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
}
