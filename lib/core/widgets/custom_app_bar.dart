import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/assets.gen.dart';
import '../theme/styles/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr(title),
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
          ),
          SvgPicture.asset(
            Assets.images.appIcon, // Update with your asset path
            height: 30.h,
          ),
        ],
      ),
      actions: actions,
      backgroundColor: AppColors.primaryBurntOrange,
      foregroundColor: AppColors.creamColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
