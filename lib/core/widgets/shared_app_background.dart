// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/gen/assets.gen.dart';

class SharedAppBackground extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SharedAppBackground({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 390.w,
      height: height ?? 125.h,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.luminosity,
          ),
          image: Assets.images.customAppBackground.provider(),
          fit: fit,
        ),
      ),
      child: child != null
          ? Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            )
          : null,
    );
  }
}
