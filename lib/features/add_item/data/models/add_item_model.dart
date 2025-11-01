import '../../domain/entities/add_item_entity.dart';

class AddItemModel extends AddItemEntity {
  const AddItemModel({
    required super.name,
    required super.type,
    required super.quantity,
    required super.unit,
    required super.price,
    required super.calories,
    super.imageUrl,
  });

  factory AddItemModel.fromEntity(AddItemEntity entity) {
    return AddItemModel(
      name: entity.name,
      type: entity.type,
      quantity: entity.quantity,
      unit: entity.unit,
      price: entity.price,
      calories: entity.calories,
      imageUrl: entity.imageUrl,
    );
  }

  factory AddItemModel.fromJson(Map<String, dynamic> json) {
    return AddItemModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
      price: json['price'] ?? '',
      calories: json['calories'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'calories': calories,
      'imageUrl': imageUrl,
    };
  }
}
