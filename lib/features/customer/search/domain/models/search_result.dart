import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final String type; // 'vendor' or 'product'
  final double? rating;
  final double? price;
  final String? category;
  final bool isFavorite;
  final Map<String, dynamic>? metadata;

  const SearchResult({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.type,
    this.rating,
    this.price,
    this.category,
    this.isFavorite = false,
    this.metadata,
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
        isFavorite,
        metadata,
      ];

  SearchResult copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? type,
    double? rating,
    double? price,
    String? category,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return SearchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating']?.toDouble(),
      price: json['price']?.toDouble(),
      category: json['category'],
      isFavorite: json['is_favorite'] ?? false,
      metadata: json['metadata'],
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
      'is_favorite': isFavorite,
      'metadata': metadata,
    };
  }
}
