// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:khubzati/core/bloc/app/app_cubit.dart' as _i880;
import 'package:khubzati/core/bloc/data/data_cubit.dart' as _i835;
import 'package:khubzati/core/di/app_service_model.dart' as _i1044;
import 'package:khubzati/core/network/retrofit_client.dart' as _i454;
import 'package:khubzati/core/routes/app_router.dart' as _i591;
import 'package:khubzati/core/services/app_preferences.dart' as _i458;
import 'package:khubzati/core/services/auth_service.dart' as _i189;
import 'package:khubzati/core/services/localization_service.dart' as _i273;
import 'package:khubzati/features/auth/application/blocs/auth_bloc.dart'
    as _i450;
import 'package:khubzati/features/customer/address/application/blocs/address_bloc.dart'
    as _i173;
import 'package:khubzati/features/customer/address/data/services/address_service.dart'
    as _i602;
import 'package:khubzati/features/customer/payment/application/blocs/payment_bloc.dart'
    as _i62;
import 'package:khubzati/features/customer/payment/data/services/payment_service.dart'
    as _i96;
import 'package:khubzati/features/customer/reviews/application/blocs/review_bloc.dart'
    as _i984;
import 'package:khubzati/features/customer/reviews/data/services/review_service.dart'
    as _i666;
import 'package:khubzati/features/driver/dashboard/application/blocs/driver_dashboard_bloc.dart'
    as _i191;
import 'package:khubzati/features/driver/dashboard/data/services/driver_dashboard_service.dart'
    as _i809;
import 'package:khubzati/features/notifications/application/blocs/notification_bloc.dart'
    as _i203;
import 'package:khubzati/features/notifications/data/services/notification_service.dart'
    as _i588;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart'
    as _i913;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appServiceModel = _$AppServiceModel();
    await gh.factoryAsync<_i913.StreamingSharedPreferences>(
      () => appServiceModel.preferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i591.AppRouter>(() => appServiceModel.appRouter);
    gh.lazySingleton<_i361.Dio>(() => appServiceModel.dio);
    gh.lazySingleton<_i454.RetrofitClient>(
        () => appServiceModel.retrofitClient);
    gh.lazySingleton<_i59.FirebaseAuth>(() => appServiceModel.firebaseAuth);
    gh.lazySingleton<_i273.LocalizationService>(
        () => _i273.LocalizationService());
    gh.lazySingleton<_i835.DataCubit>(() => _i835.DataCubit());
    gh.lazySingleton<_i189.AuthService>(
        () => _i189.AuthService(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i458.AppPreferences>(
        () => _i458.AppPreferences(gh<_i913.StreamingSharedPreferences>()));
    gh.factory<_i450.AuthBloc>(() => _i450.AuthBloc(
          authService: gh<_i189.AuthService>(),
          appPreferences: gh<_i458.AppPreferences>(),
        ));
    gh.factory<_i62.PaymentBloc>(
        () => _i62.PaymentBloc(paymentService: gh<_i96.PaymentService>()));
    gh.lazySingleton<_i880.AppCubit>(() => _i880.AppCubit(
          gh<_i273.LocalizationService>(),
          gh<_i458.AppPreferences>(),
        ));
    gh.factory<_i173.AddressBloc>(
        () => _i173.AddressBloc(addressService: gh<_i602.AddressService>()));
    gh.factory<_i203.NotificationBloc>(() => _i203.NotificationBloc(
        notificationService: gh<_i588.NotificationService>()));
    gh.factory<_i191.DriverDashboardBloc>(() => _i191.DriverDashboardBloc(
        driverDashboardService: gh<_i809.DriverDashboardService>()));
    gh.factory<_i984.ReviewBloc>(
        () => _i984.ReviewBloc(reviewService: gh<_i666.ReviewService>()));
    return this;
  }
}

class _$AppServiceModel extends _i1044.AppServiceModel {}
