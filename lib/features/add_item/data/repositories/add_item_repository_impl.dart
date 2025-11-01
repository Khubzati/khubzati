import '../../domain/entities/add_item_entity.dart';
import '../../domain/repositories/add_item_repository.dart';
import '../datasources/add_item_datasource.dart';
import '../models/add_item_model.dart';

class AddItemRepositoryImpl implements AddItemRepository {
  final AddItemDataSource dataSource;

  AddItemRepositoryImpl({required this.dataSource});

  @override
  Future<void> addItem(AddItemEntity item) async {
    final model = AddItemModel.fromEntity(item);
    await dataSource.addItem(model);
  }

  @override
  Future<List<AddItemEntity>> getItems() async {
    final models = await dataSource.getItems();
    return models.map((model) => model as AddItemEntity).toList();
  }

  @override
  Future<void> updateItem(AddItemEntity item) async {
    final model = AddItemModel.fromEntity(item);
    await dataSource.updateItem(model);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await dataSource.deleteItem(itemId);
  }
}
