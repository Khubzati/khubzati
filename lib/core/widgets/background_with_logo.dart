import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/translations/locale_keys.g.dart';
import '../theme/styles/app_text_style.dart';

class BackgroundWithLogo extends StatelessWidget {
  final Widget child;
  final bool showLogo;
  final bool showTitle;

  const BackgroundWithLogo({
    super.key,
    required this.child,
    this.showLogo = true,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: Assets.images.background.provider(),
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.w, sigmaY: 15.w),
          child: Container(
            color: const Color(0x66000000),
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            child: SingleChildScrollView(
              // padding: EdgeInsets.only(bottom: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showLogo || showTitle) ...[
                    160.verticalSpace,
                    if (showLogo) SvgPicture.asset(Assets.images.arLogo),
                    if (showLogo && showTitle) 10.verticalSpace,
                    if (showTitle)
                      Center(
                        // padding: EdgeInsets.only(left: 20.h),
                        child: Text(
                          context.tr(LocaleKeys.app_userTypeSelection_title),
                          style: AppTextStyles.font47TextW700,
                        ),
                      ),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
