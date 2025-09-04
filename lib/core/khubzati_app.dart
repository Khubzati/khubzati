import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/application/blocs/auth_bloc.dart';
import '../features/user_type_selection/application/blocs/carousel_bloc.dart';
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
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<AppCubit>()),
        BlocProvider(create: (context) => getIt<DataCubit>()),
        BlocProvider(create: (context) => CarouselBloc()),
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
