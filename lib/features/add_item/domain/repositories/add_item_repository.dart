import '../entities/add_item_entity.dart';

abstract class AddItemRepository {
  Future<void> addItem(AddItemEntity item);
  Future<List<AddItemEntity>> getItems();
  Future<void> updateItem(AddItemEntity item);
  Future<void> deleteItem(String itemId);
}
