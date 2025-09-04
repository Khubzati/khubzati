import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/routes/app_router.dart';
import '../../gen/assets.gen.dart';
import '../../gen/translations/locale_keys.g.dart';
import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';
import 'app_elevated_button.dart';
import '../../features/auth/application/blocs/auth_bloc.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.pageBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Color(0x1F000000), blurRadius: 18),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              140.verticalSpace,
              Text(
                context.tr(LocaleKeys.app_general_admin_succes_message),
                style: AppTextStyles.font24Textbold,
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AppElevatedButton(
                  child: Text(context.tr(LocaleKeys.app_general_logout)),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    context.router.push(const LoginRoute());
                  },
                ),
              ),
              60.verticalSpace
            ],
          ),
        ),
        Positioned(
          top: -100,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            Assets.images.successMessage,
          ),
        ),
      ],
    );
  }
}
