import '../../domain/entities/add_item_entity.dart';

abstract class AddItemState {}

class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {
  final AddItemEntity item;

  AddItemSuccess({required this.item});
}

class AddItemFailure extends AddItemState {
  final String message;

  AddItemFailure({required this.message});
}

class AddItemFormValid extends AddItemState {
  final Map<String, String> formData;

  AddItemFormValid({required this.formData});
}

class AddItemFormInvalid extends AddItemState {
  final Map<String, String> errors;

  AddItemFormInvalid({required this.errors});
}
