import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/features/network/application/blocs/network_bloc.dart';
import 'package:khubzati/features/network/application/blocs/network_event.dart';
import 'package:khubzati/features/network/presentation/widgets/no_internet_app_bar.dart';
import 'package:khubzati/features/network/presentation/widgets/no_internet_illustration.dart';
import 'package:khubzati/features/network/presentation/widgets/no_internet_message.dart';
import 'package:khubzati/features/network/presentation/widgets/no_internet_retry_button.dart';

@RoutePage()
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBloc()..add(const NetworkCheckRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NoInternetAppBar(),
        body: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const NoInternetIllustration(),
                    40.verticalSpace,
                    const NoInternetMessage(),
                  ],
                ),
              ),
              const NoInternetRetryButton(),
            ],
          ),
        ),
      ),
    );
  }
}
