import '../../domain/entities/add_item_entity.dart';

abstract class AddItemEvent {}

class AddItemSubmitted extends AddItemEvent {
  final AddItemEntity item;

  AddItemSubmitted({required this.item});
}

class AddItemFormChanged extends AddItemEvent {
  final String field;
  final String value;

  AddItemFormChanged({required this.field, required this.value});
}

class AddItemFormReset extends AddItemEvent {}
