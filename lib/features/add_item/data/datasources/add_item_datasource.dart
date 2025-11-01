import '../models/add_item_model.dart';

abstract class AddItemDataSource {
  Future<void> addItem(AddItemModel item);
  Future<List<AddItemModel>> getItems();
  Future<void> updateItem(AddItemModel item);
  Future<void> deleteItem(String itemId);
}
