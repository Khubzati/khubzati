import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../gen/translations/locale_keys.g.dart';
import '../bloc/data/data_cubit.dart';
import '../config/app_config.dart';
import '../di/injection.dart';
import '../services/app_preferences.dart';
import 'api_response.dart';

class DioConstants {
  static final String baseUrl = AppConfig.shared.baseUrl;

  static final BaseOptions defaultOptions = BaseOptions(
    baseUrl: DioConstants.baseUrl,
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.acceptHeader: Headers.jsonContentType,
    },
  );

  static const getFileByIdEndpoint = '/File/GetFileById';

  static List<Interceptor> defaultInterceptors = [
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final appPreferences = getIt<AppPreferences>();
        options.headers['Authorization'] =
            'Bearer ${appPreferences.accessToken}';
        options.headers['Lang'] = getIt<AppPreferences>().getLang;

        handler.next(options);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          triggerDataEvent(LocaleKeys.app_apiError_sessionExpired, true, 401);
        } else {
          final errorMsg = handleError(error);
          triggerDataEvent(errorMsg, true);
        }

        return handler.next(error);
      },
    ),
    DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.request,
        hitCacheOnErrorExcept: [401, 403],
      ),
    ),
  ];
}
