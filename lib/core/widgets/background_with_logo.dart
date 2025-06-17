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
  const BackgroundWithLogo({super.key, required this.child});

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
        Positioned(
          // left: 120.h,
          child: Column(
            children: [
              160.verticalSpace,
              SvgPicture.asset(Assets.images.arLogo),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: Text(context.tr(LocaleKeys.app_userTypeSelection_title),
                    style: AppTextStyles.font47TextW700),
              ),
              child
            ],
          ),
        ),
      ],
    );
  }
}
