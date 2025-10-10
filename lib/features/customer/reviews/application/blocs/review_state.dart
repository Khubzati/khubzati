part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final bool hasMore;

  const ReviewsLoaded({
    required this.reviews,
    required this.averageRating,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [reviews, averageRating, hasMore];
}

class UserReviewsLoaded extends ReviewState {
  final List<Map<String, dynamic>> reviews;
  final bool hasMore;

  const UserReviewsLoaded({
    required this.reviews,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [reviews, hasMore];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
