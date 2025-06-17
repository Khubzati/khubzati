import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/cubit/auth_cubit.dart';
import '../features/user_type_selection/presentation/bloc/cubit/carousel_cubit.dart';
import 'theme/app_theme.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'bloc/app/app_cubit.dart';
import 'bloc/data/data_cubit.dart';
import 'constants/constants.dart';
import 'di/injection.dart';
import 'routes/app_router.dart';

class KhubzatiApp extends StatelessWidget {
  final AppRouter appRouter = getIt<AppRouter>();

  KhubzatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<AppCubit>()),
        BlocProvider(create: (context) => getIt<DataCubit>()),
        BlocProvider(create: (context) => getIt<CarouselCubit>()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(
          includePrefixMatches: true,
          deepLinkBuilder: (deepLink) {
            return DeepLink.defaultPath;
          },
        ),
        theme: appThemeData,
        localizationsDelegates: [
          ...context.localizationDelegates,
          ...PhoneFieldLocalization.delegates,
        ],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
