part of 'carousel_bloc.dart';

abstract class CarouselEvent extends Equatable {
  const CarouselEvent();

  @override
  List<Object> get props => [];
}

class ChangeIndex extends CarouselEvent {
  final int index;

  const ChangeIndex(this.index);

  @override
  List<Object> get props => [index];
}
