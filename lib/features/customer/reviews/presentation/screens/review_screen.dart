import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/customer/reviews/application/blocs/review_bloc.dart';

@RoutePage()
class ReviewScreen extends StatefulWidget {
  final String entityType; // 'product', 'restaurant', 'bakery'
  final String entityId;
  final String entityName;

  const ReviewScreen({
    super.key,
    required this.entityType,
    required this.entityId,
    required this.entityName,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviews(
          entityType: widget.entityType,
          entityId: widget.entityId,
          page: _currentPage,
          limit: _limit,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.entityName}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.router.push(
                AddReviewRoute(
                  entityType: widget.entityType,
                  entityId: widget.entityId,
                  entityName: widget.entityName,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading && _currentPage == 1) {
            return const AppLoadingWidget(
              message: 'Loading reviews...',
            );
          }

          if (state is ReviewError && _currentPage == 1) {
            return _buildErrorState(context, state.message);
          }

          if (state is ReviewsLoaded) {
            return _buildReviewsList(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: context.theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Retry',
            onPressed: () {
              setState(() {
                _currentPage = 1;
              });
              context.read<ReviewBloc>().add(LoadReviews(
                    entityType: widget.entityType,
                    entityId: widget.entityId,
                    page: _currentPage,
                    limit: _limit,
                  ));
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, ReviewsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _currentPage = 1;
        });
        context.read<ReviewBloc>().add(LoadReviews(
              entityType: widget.entityType,
              entityId: widget.entityId,
              page: _currentPage,
              limit: _limit,
            ));
      },
      child: CustomScrollView(
        slivers: [
          // Rating Summary
          SliverToBoxAdapter(
            child: _buildRatingSummary(context, state),
          ),

          // Reviews List
          if (state.reviews.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(context),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < state.reviews.length) {
                    return _buildReviewCard(context, state.reviews[index]);
                  } else if (state.hasMore) {
                    // Load more indicator
                    _loadMoreReviews();
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return null;
                },
                childCount: state.reviews.length + (state.hasMore ? 1 : 0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context, ReviewsLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Average Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.averageRating.toStringAsFixed(1),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(state.averageRating, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    '${state.reviews.length} reviews',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),

              // Rating Distribution
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rating = 5 - index;
                    final count = state.reviews
                        .where((r) => (r['rating'] ?? 0.0).round() == rating)
                        .length;
                    final percentage = state.reviews.isEmpty
                        ? 0.0
                        : count / state.reviews.length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            '$rating',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            textWidthBasis: TextWidthBasis.longestLine,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor:
                                  colorScheme.outline.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Reviews Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to review this ${widget.entityType}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Write Review',
            onPressed: () {
              context.router.push(
                AddReviewRoute(
                  entityType: widget.entityType,
                  entityId: widget.entityId,
                  entityName: widget.entityName,
                ),
              );
            },
            type: AppButtonType.primary,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Header
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Text(
                  (review['user_name'] ?? 'U')[0].toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // User Info and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['user_name'] ?? 'Anonymous',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(review['rating'] ?? 0.0, size: 16),
                  ],
                ),
              ),

              // Review Date
              Text(
                _formatDate(review['created_at']),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review Comment
          if (review['comment'] != null && review['comment'].isNotEmpty)
            Text(
              review['comment'],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),

          // Review Actions
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 18,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () {
                  // TODO: Implement like functionality
                },
              ),
              Text(
                '${review['likes_count'] ?? 0}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  Icons.report_outlined,
                  size: 18,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () {
                  _showReportDialog(context, review['id']);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1;
        return Icon(
          starRating <= rating
              ? Icons.star
              : starRating - 0.5 <= rating
                  ? Icons.star_half
                  : Icons.star_border,
          size: size,
          color: Colors.amber,
        );
      }),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _loadMoreReviews() {
    setState(() {
      _currentPage++;
    });
    context.read<ReviewBloc>().add(LoadReviews(
          entityType: widget.entityType,
          entityId: widget.entityId,
          page: _currentPage,
          limit: _limit,
        ));
  }

  void _showReportDialog(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Review'),
        content: const Text('Are you sure you want to report this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement report functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review reported successfully'),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}
