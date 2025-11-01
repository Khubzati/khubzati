import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SharedBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    Widget? footer,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    String? svgAssetPath,
    double? borderRadius,
    bool showGrabHandle = true,
    bool showCloseButton = true,
    EdgeInsets? contentPadding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: svgAssetPath != null
          ? Colors.transparent
          : (backgroundColor ?? Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular((borderRadius ?? 16).w),
        ),
      ),
      builder: (ctx) {
        final sheet = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Space for SVG if provided
            if (svgAssetPath != null) 130.verticalSpace,
            // Grab handle
            if (showGrabHandle)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            // Title row
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (showCloseButton)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                  ],
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding:
                    contentPadding ?? EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: content,
              ),
            ),
            if (footer != null) footer,
          ],
        );

        Widget result = sheet;

        // Wrap in container with custom styling if SVG is provided
        if (svgAssetPath != null ||
            borderRadius != null ||
            backgroundColor != null) {
          result = Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: borderRadius != null
                  ? BorderRadius.only(
                      topLeft: Radius.circular(borderRadius.w),
                      topRight: Radius.circular(borderRadius.w),
                    )
                  : null,
            ),
            child: sheet,
          );
        }

        // Wrap in Stack if SVG illustration is provided
        if (svgAssetPath != null) {
          result = Stack(
            clipBehavior: Clip.none,
            children: [
              result,
              Positioned(
                top: -100,
                left: 0,
                right: 0,
                child: SvgPicture.asset(svgAssetPath),
              ),
            ],
          );
        }

        if (height != null) {
          return SizedBox(height: height, child: result);
        }
        return result;
      },
    );
  }
}
