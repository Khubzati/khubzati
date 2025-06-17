import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/di/injection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'data_cubit.freezed.dart';
part 'data_state.dart';

@lazySingleton
class DataCubit extends Cubit<DataState> {
  DataCubit() : super(const DataState.reset());

  void triggerState(String message, bool isError, [int? statusCode]) {
    emit(const DataState.reset());
    emit(isError
        ? (DataState.error(message, statusCode))
        : (DataState.success(message)));
  }
}

void triggerDataEvent(String message, bool isError, [int? statusCode]) {
  final dataCubit = getIt<DataCubit>();
  dataCubit.triggerState(message, isError, statusCode);
}
