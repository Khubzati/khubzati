import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_status.freezed.dart';

@freezed
class BaseStatus<T> with _$BaseStatus<T> {
  const factory BaseStatus.initial() = Initial<T>;

  const factory BaseStatus.changed() = Changed<T>;

  const factory BaseStatus.loading() = Loading<T>;

  const factory BaseStatus.success() = Success<T>;

  const factory BaseStatus.failure([String? error]) = Failure<T>;
}
