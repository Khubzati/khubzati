import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../gen/translations/locale_keys.g.dart';

part 'api_response.g.dart';
part 'api_response.freezed.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class ApiResponse<T> {
  final T data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@JsonSerializable(createToJson: false)
class ErrorResponse {
  final String? errorMessage;

  ErrorResponse({required this.errorMessage});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(String error) = Failure;
}

Future<ApiResult<T>> apiHandler<T>(
    Future<ApiResponse<T>> Function() restApiCall) async {
  try {
    final apiResponse = await restApiCall();
    return ApiResult.success(apiResponse.data);
  } on DioException catch (e) {
    if (!kReleaseMode) {
      log(e.toString());
    }
    final errorMsg = handleError(e);
    return ApiResult.failure(errorMsg);
  } catch (e) {
    if (!kReleaseMode) {
      log(e.toString());
    }
    return ApiResult.failure(LocaleKeys.app_apiError_server.tr());
  }
}

String handleError(DioException error) {
  late String errorMsg;
  if (error.type == DioExceptionType.connectionError) {
    errorMsg = LocaleKeys.app_apiError_connection.tr();
  } else {
    errorMsg = ErrorResponse.fromJson(
          error.response?.data is Map<String, dynamic>
              ? error.response?.data
              : {},
        ).errorMessage ??
        LocaleKeys.app_apiError_server.tr();
  }
  return errorMsg;
}
