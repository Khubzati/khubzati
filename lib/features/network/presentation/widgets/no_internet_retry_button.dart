import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/features/network/application/blocs/network_bloc.dart';
import 'package:khubzati/features/network/application/blocs/network_event.dart';
import 'package:khubzati/features/network/application/blocs/network_state.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInternetRetryButton extends StatelessWidget {
  const NoInternetRetryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50.h,
          child: AppButton(
            text: LocaleKeys.app_no_internet_retry.tr(),
            onPressed: state is NetworkChecking
                ? null
                : () {
                    context
                        .read<NetworkBloc>()
                        .add(const NetworkRetryRequested());
                  },
            backgroundColor: AppColors.primary,
            textColor: AppColors.surface,
            isLoading: state is NetworkChecking,
            borderRadius: 12.r,
          ),
        );
      },
    );
  }
}
