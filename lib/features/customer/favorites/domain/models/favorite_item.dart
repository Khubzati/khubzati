import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final String type; // 'vendor' or 'product'
  final double? rating;
  final double? price;
  final String? category;
  final String? vendorId;
  final Map<String, dynamic>? metadata;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.type,
    this.rating,
    this.price,
    this.category,
    this.vendorId,
    this.metadata,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        type,
        rating,
        price,
        category,
        vendorId,
        metadata,
        addedAt,
      ];

  FavoriteItem copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? type,
    double? rating,
    double? price,
    String? category,
    String? vendorId,
    Map<String, dynamic>? metadata,
    DateTime? addedAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      category: category ?? this.category,
      vendorId: vendorId ?? this.vendorId,
      metadata: metadata ?? this.metadata,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating']?.toDouble(),
      price: json['price']?.toDouble(),
      category: json['category'],
      vendorId: json['vendor_id'],
      metadata: json['metadata'],
      addedAt: DateTime.parse(json['added_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'type': type,
      'rating': rating,
      'price': price,
      'category': category,
      'vendor_id': vendorId,
      'metadata': metadata,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
