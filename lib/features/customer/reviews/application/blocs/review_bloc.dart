import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/customer/reviews/data/services/review_service.dart';

part 'review_event.dart';
part 'review_state.dart';

@injectable
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewService reviewService;

  ReviewBloc({required this.reviewService}) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
    on<UpdateReview>(_onUpdateReview);
    on<DeleteReview>(_onDeleteReview);
    on<LoadUserReviews>(_onLoadUserReviews);
  }

  Future<void> _onLoadReviews(
      LoadReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await reviewService.getReviews(
        entityType: event.entityType,
        entityId: event.entityId,
        page: event.page,
        limit: event.limit,
      );

      final averageRating = await reviewService.getAverageRating(
        entityType: event.entityType,
        entityId: event.entityId,
      );

      emit(ReviewsLoaded(
        reviews: reviews,
        averageRating: averageRating,
        hasMore: reviews.length == event.limit,
      ));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    if (state is ReviewsLoaded) {
      final currentState = state as ReviewsLoaded;
      emit(ReviewLoading());
      try {
        final newReview = await reviewService.addReview(
          entityType: event.entityType,
          entityId: event.entityId,
          rating: event.rating,
          comment: event.comment,
          orderId: event.orderId,
        );

        final updatedReviews = [newReview, ...currentState.reviews];
        final newAverageRating = _calculateAverageRating(updatedReviews);

        emit(ReviewsLoaded(
          reviews: updatedReviews,
          averageRating: newAverageRating,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateReview(
      UpdateReview event, Emitter<ReviewState> emit) async {
    if (state is ReviewsLoaded) {
      final currentState = state as ReviewsLoaded;
      emit(ReviewLoading());
      try {
        final updatedReview = await reviewService.updateReview(
          reviewId: event.reviewId,
          rating: event.rating,
          comment: event.comment,
        );

        final updatedReviews = currentState.reviews.map((review) {
          return review['id'] == event.reviewId ? updatedReview : review;
        }).toList();

        final newAverageRating = _calculateAverageRating(updatedReviews);

        emit(ReviewsLoaded(
          reviews: updatedReviews,
          averageRating: newAverageRating,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteReview(
      DeleteReview event, Emitter<ReviewState> emit) async {
    if (state is ReviewsLoaded) {
      final currentState = state as ReviewsLoaded;
      emit(ReviewLoading());
      try {
        await reviewService.deleteReview(event.reviewId);

        final updatedReviews = currentState.reviews
            .where((review) => review['id'] != event.reviewId)
            .toList();

        final newAverageRating = _calculateAverageRating(updatedReviews);

        emit(ReviewsLoaded(
          reviews: updatedReviews,
          averageRating: newAverageRating,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    }
  }

  Future<void> _onLoadUserReviews(
      LoadUserReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await reviewService.getUserReviews(
        page: event.page,
        limit: event.limit,
      );

      emit(UserReviewsLoaded(
        reviews: reviews,
        hasMore: reviews.length == event.limit,
      ));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  double _calculateAverageRating(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + (review['rating'] ?? 0.0),
    );

    return totalRating / reviews.length;
  }
}
