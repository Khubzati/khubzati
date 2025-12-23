import 'package:equatable/equatable.dart';

class FavoriteBakery extends Equatable {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final String address;
  final String imageUrl;
  final DateTime addedAt;

  const FavoriteBakery({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.imageUrl,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rating,
        reviewCount,
        address,
        imageUrl,
        addedAt,
      ];

  FavoriteBakery copyWith({
    String? id,
    String? name,
    String? description,
    double? rating,
    int? reviewCount,
    String? address,
    String? imageUrl,
    DateTime? addedAt,
  }) {
    return FavoriteBakery(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory FavoriteBakery.fromJson(Map<String, dynamic> json) {
    return FavoriteBakery(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
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
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'imageUrl': imageUrl,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

