import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';

class TabSelector extends StatefulWidget {
  final ValueChanged<bool>? onChanged; // true: current, false: previous

  const TabSelector({super.key, this.onChanged});

  @override
  State<TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector> {
  bool isCurrentSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(33.r),
      ),
      child: Stack(
        children: [
          // Sliding indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 10),
            left: isCurrentSelected ? 195.w : 0,
            child: Container(
              width: 175.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primaryBurntOrange,
                borderRadius: BorderRadius.circular(33.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pageBackground.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          // Tab buttons
          Row(
            children: [
              // Current Orders Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCurrentSelected = true;
                    });
                    widget.onChanged?.call(true);
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.h,
                            decoration: const BoxDecoration(
                              color: AppColors.pageBackground,
                              shape: BoxShape.circle,
                            ),
                          ),
                          // SizedBox(width: 18.w),
                          Text(
                            'الطلبات الحالية',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isCurrentSelected
                                  ? AppColors.pageBackground
                                  : AppColors.textDarkBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Previous Orders Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCurrentSelected = false;
                    });
                    widget.onChanged?.call(false);
                  },
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: !isCurrentSelected
                                ? AppColors.pageBackground
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        16.horizontalSpace,
                        Text(
                          'الطلبات السابقة',
                          style: TextStyle(
                            color: !isCurrentSelected
                                ? AppColors.pageBackground
                                : AppColors.textDarkBrown,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
