import '../../domain/models/favorite_item.dart' as domain;

class FavoriteItemModel extends domain.FavoriteItem {
  const FavoriteItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.type,
    super.rating,
    super.price,
    super.category,
    super.vendorId,
    super.metadata,
    required super.addedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
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
      addedAt:
          DateTime.parse(json['added_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
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

  factory FavoriteItemModel.fromDomain(domain.FavoriteItem item) {
    return FavoriteItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      image: item.image,
      type: item.type,
      rating: item.rating,
      price: item.price,
      category: item.category,
      vendorId: item.vendorId,
      metadata: item.metadata,
      addedAt: item.addedAt,
    );
  }

  domain.FavoriteItem toDomain() {
    return domain.FavoriteItem(
      id: id,
      name: name,
      description: description,
      image: image,
      type: type,
      rating: rating,
      price: price,
      category: category,
      vendorId: vendorId,
      metadata: metadata,
      addedAt: addedAt,
    );
  }
}
