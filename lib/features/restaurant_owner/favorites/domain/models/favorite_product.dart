import 'package:equatable/equatable.dart';

class FavoriteProduct extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String quantity;
  final String bakeryName;
  final String bakeryId;
  final DateTime addedAt;

  const FavoriteProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.bakeryName,
    required this.bakeryId,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        quantity,
        bakeryName,
        bakeryId,
        addedAt,
      ];

  FavoriteProduct copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? quantity,
    String? bakeryName,
    String? bakeryId,
    DateTime? addedAt,
  }) {
    return FavoriteProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      bakeryName: bakeryName ?? this.bakeryName,
      bakeryId: bakeryId ?? this.bakeryId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? '',
      bakeryName: json['bakeryName'] ?? '',
      bakeryId: json['bakeryId'] ?? '',
      addedAt: DateTime.parse(
        json['addedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'bakeryName': bakeryName,
      'bakeryId': bakeryId,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

