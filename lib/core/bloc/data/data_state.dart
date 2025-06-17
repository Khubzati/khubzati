part of 'data_cubit.dart';

@freezed
class DataState with _$DataState {
  const factory DataState.reset() = _Reset;
  const factory DataState.error(String message, int? statusCode) = _Error;
  const factory DataState.success(String message) = _Success;
}
