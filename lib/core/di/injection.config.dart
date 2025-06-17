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
    gh.lazySingleton<_i880.AppCubit>(() => _i880.AppCubit(
          gh<_i273.LocalizationService>(),
          gh<_i458.AppPreferences>(),
        ));
    return this;
  }
}

class _$AppServiceModel extends _i1044.AppServiceModel {}
