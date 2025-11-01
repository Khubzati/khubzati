class AddItemEntity {
  final String name;
  final String type;
  final String quantity;
  final String unit;
  final String price;
  final String calories;
  final String? imageUrl;

  const AddItemEntity({
    required this.name,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.calories,
    this.imageUrl,
  });

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

  factory AddItemEntity.fromJson(Map<String, dynamic> json) {
    return AddItemEntity(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
      price: json['price'] ?? '',
      calories: json['calories'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  AddItemEntity copyWith({
    String? name,
    String? type,
    String? quantity,
    String? unit,
    String? price,
    String? calories,
    String? imageUrl,
  }) {
    return AddItemEntity(
      name: name ?? this.name,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      calories: calories ?? this.calories,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
