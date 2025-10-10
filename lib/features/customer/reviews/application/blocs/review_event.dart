part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String entityType; // 'product', 'restaurant', 'bakery'
  final String entityId;
  final int page;
  final int limit;

  const LoadReviews({
    required this.entityType,
    required this.entityId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [entityType, entityId, page, limit];
}

class AddReview extends ReviewEvent {
  final String entityType;
  final String entityId;
  final double rating;
  final String comment;
  final String? orderId;

  const AddReview({
    required this.entityType,
    required this.entityId,
    required this.rating,
    required this.comment,
    this.orderId,
  });

  @override
  List<Object?> get props => [entityType, entityId, rating, comment, orderId];
}

class UpdateReview extends ReviewEvent {
  final String reviewId;
  final double rating;
  final String comment;

  const UpdateReview({
    required this.reviewId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment];
}

class DeleteReview extends ReviewEvent {
  final String reviewId;

  const DeleteReview({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

class LoadUserReviews extends ReviewEvent {
  final int page;
  final int limit;

  const LoadUserReviews({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}
