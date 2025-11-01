import '../models/add_item_model.dart';
import 'add_item_datasource.dart';

class AddItemDataSourceImpl implements AddItemDataSource {
  // This would typically connect to a real data source like API, database, etc.
  // For now, we'll use a simple in-memory storage
  static final List<AddItemModel> _items = [];

  @override
  Future<void> addItem(AddItemModel item) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _items.add(item);
  }

  @override
  Future<List<AddItemModel>> getItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_items);
  }

  @override
  Future<void> updateItem(AddItemModel item) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.name == itemId);
  }
}
