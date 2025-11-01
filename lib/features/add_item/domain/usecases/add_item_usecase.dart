import '../entities/add_item_entity.dart';
import '../repositories/add_item_repository.dart';

class AddItemUseCase {
  final AddItemRepository repository;

  AddItemUseCase({required this.repository});

  Future<void> call(AddItemEntity item) async {
    await repository.addItem(item);
  }
}
