part of 'restaurant_analytics_bloc.dart';

abstract class RestaurantAnalyticsState extends Equatable {
  const RestaurantAnalyticsState();

  @override
  List<Object?> get props => [];
}

class RestaurantAnalyticsInitial extends RestaurantAnalyticsState {}

class RestaurantAnalyticsLoading extends RestaurantAnalyticsState {}

class RestaurantAnalyticsLoaded extends RestaurantAnalyticsState {
  final Map<String, dynamic> salesOverview;
  final Map<String, dynamic> orderStatistics;
  final List<Map<String, dynamic>> popularItems;
  final String period;

  const RestaurantAnalyticsLoaded({
    required this.salesOverview,
    required this.orderStatistics,
    required this.popularItems,
    required this.period,
  });

  @override
  List<Object?> get props =>
      [salesOverview, orderStatistics, popularItems, period];

  RestaurantAnalyticsLoaded copyWith({
    Map<String, dynamic>? salesOverview,
    Map<String, dynamic>? orderStatistics,
    List<Map<String, dynamic>>? popularItems,
    String? period,
  }) {
    return RestaurantAnalyticsLoaded(
      salesOverview: salesOverview ?? this.salesOverview,
      orderStatistics: orderStatistics ?? this.orderStatistics,
      popularItems: popularItems ?? this.popularItems,
      period: period ?? this.period,
    );
  }
}

class RestaurantAnalyticsExporting extends RestaurantAnalyticsState {}

class RestaurantAnalyticsExportSuccess extends RestaurantAnalyticsState {
  final String reportPath;
  final String message;

  const RestaurantAnalyticsExportSuccess({
    required this.reportPath,
    required this.message,
  });

  @override
  List<Object?> get props => [reportPath, message];
}

class RestaurantAnalyticsError extends RestaurantAnalyticsState {
  final String message;

  const RestaurantAnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
