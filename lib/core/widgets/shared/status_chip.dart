import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/styles/app_colors.dart';
import '../../theme/styles/app_text_style.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.padding,
  });

  Color _resolveColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('complete') || lower.contains('مكتمل')) {
      return AppColors.tertiaryOliveGreen;
    }
    if (lower.contains('cancel') || lower.contains('ملغي')) {
      return AppColors.error;
    }
    return AppColors.primaryBurntOrange;
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? _resolveColor(label);

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.font15TextW400.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: chipColor,
        ),
      ),
    );
  }
}
