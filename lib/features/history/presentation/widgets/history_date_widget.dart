import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';

class HistoryDateWidget extends StatelessWidget {
  const HistoryDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current date and format it based on locale
    final now = DateTime.now();
    final isArabic = context.locale.languageCode == 'ar';

    String formattedDate;
    if (isArabic) {
      // Arabic date format
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      formattedDate = '${now.day} ${months[now.month - 1]} ${now.year}';
    } else {
      // English date format
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      formattedDate = '${months[now.month - 1]} ${now.day}, ${now.year}';
    }

    return Container(
      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        formattedDate,
        style: AppTextStyles.font20textDarkBrownbold.copyWith(
          color: AppColors.creamColor,
        ),
      ),
    );
  }
}
