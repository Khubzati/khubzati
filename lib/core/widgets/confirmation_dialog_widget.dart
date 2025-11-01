import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String? svgAssetPath;
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const ConfirmationDialogWidget({
    super.key,
    this.svgAssetPath,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creamColor,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Space for the illustration
                  SizedBox(height: 100.h),

                  // Title
                  Text(
                    title,
                    style: AppTextStyles.font20textDarkBrownbold,
                    textAlign: TextAlign.center,
                  ),

                  16.verticalSpace,

                  // Message
                  Text(
                    message,
                    style: AppTextStyles.font14TextW400OP8,
                    textAlign: TextAlign.center,
                  ),

                  32.verticalSpace,

                  // Action buttons
                  if (cancelButtonText.isNotEmpty)
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: OutlinedButton(
                              onPressed:
                                  onCancel ?? () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: cancelButtonColor ??
                                      AppColors.primaryBurntOrange,
                                  width: 1.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                backgroundColor: AppColors.creamColor,
                              ),
                              child: Text(
                                cancelButtonText,
                                style: AppTextStyles.font16textDarkBrownBold,
                              ),
                            ),
                          ),
                        ),

                        16.horizontalSpace,

                        // Confirm button
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: confirmButtonColor ??
                                    AppColors.primaryBurntOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                confirmButtonText,
                                style: AppTextStyles.font16textDarkBrownBold
                                    .copyWith(
                                  color: AppColors.creamColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // Single button (for success dialogs)
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmButtonColor ??
                              AppColors.primaryBurntOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          confirmButtonText,
                          style: AppTextStyles.font16textDarkBrownBold.copyWith(
                            color: AppColors.creamColor,
                          ),
                        ),
                      ),
                    ),

                  24.verticalSpace,
                ],
              ),
            ),

            // Illustration positioned at the top
            if (svgAssetPath != null)
              Positioned(
                top: -80.h,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset(
                    svgAssetPath!,
                    height: 160.h,
                    width: 160.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Static method to show the confirmation dialog
  static Future<void> show({
    required BuildContext context,
    String? svgAssetPath,
    required String title,
    required String message,
    required String confirmButtonText,
    required String cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialogWidget(
        svgAssetPath: svgAssetPath,
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
      ),
    );
  }
}
