import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_item_usecase.dart';
import 'add_item_event.dart';
import 'add_item_state.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  final AddItemUseCase addItemUseCase;

  AddItemBloc({required this.addItemUseCase}) : super(AddItemInitial()) {
    on<AddItemSubmitted>(_onAddItemSubmitted);
    on<AddItemFormChanged>(_onAddItemFormChanged);
    on<AddItemFormReset>(_onAddItemFormReset);
  }

  Future<void> _onAddItemSubmitted(
    AddItemSubmitted event,
    Emitter<AddItemState> emit,
  ) async {
    emit(AddItemLoading());

    try {
      await addItemUseCase(event.item);
      emit(AddItemSuccess(item: event.item));
    } catch (e) {
      emit(AddItemFailure(message: e.toString()));
    }
  }

  void _onAddItemFormChanged(
    AddItemFormChanged event,
    Emitter<AddItemState> emit,
  ) {
    // Handle form validation logic here
    // This would typically validate the form and emit appropriate states
  }

  void _onAddItemFormReset(
    AddItemFormReset event,
    Emitter<AddItemState> emit,
  ) {
    emit(AddItemInitial());
  }
}
