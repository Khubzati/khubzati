import '../../domain/models/search_result.dart' as domain;

class SearchResultModel extends domain.SearchResult {
  const SearchResultModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.type,
    super.rating,
    super.price,
    super.category,
    super.isFavorite = false,
    super.metadata,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
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
      'is_favorite': isFavorite,
      'metadata': metadata,
    };
  }

  factory SearchResultModel.fromDomain(domain.SearchResult result) {
    return SearchResultModel(
      id: result.id,
      name: result.name,
      description: result.description,
      image: result.image,
      type: result.type,
      rating: result.rating,
      price: result.price,
      category: result.category,
      isFavorite: result.isFavorite,
      metadata: result.metadata,
    );
  }

  domain.SearchResult toDomain() {
    return domain.SearchResult(
      id: id,
      name: name,
      description: description,
      image: image,
      type: type,
      rating: rating,
      price: price,
      category: category,
      isFavorite: isFavorite,
      metadata: metadata,
    );
  }
}
