import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc() : super(const CarouselState(index: 0)) {
    on<ChangeIndex>(_onChangeIndex);
  }

  void _onChangeIndex(ChangeIndex event, Emitter<CarouselState> emit) {
    emit(state.copyWith(index: event.index));
  }
}
