import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/gen/assets.gen.dart';

class NoInternetIllustration extends StatelessWidget {
  const NoInternetIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300.h,
      child: SvgPicture.asset(
        Assets.images.noInternet,
        width: double.infinity,
        height: 300.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
