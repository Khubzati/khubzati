part of 'restaurant_analytics_bloc.dart';

abstract class RestaurantAnalyticsEvent extends Equatable {
  const RestaurantAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantAnalytics extends RestaurantAnalyticsEvent {
  final String period;

  const LoadRestaurantAnalytics({this.period = 'today'});

  @override
  List<Object?> get props => [period];
}

class FetchSalesOverview extends RestaurantAnalyticsEvent {
  final String period;

  const FetchSalesOverview({required this.period});

  @override
  List<Object?> get props => [period];
}

class FetchOrderStatistics extends RestaurantAnalyticsEvent {
  final String period;

  const FetchOrderStatistics({required this.period});

  @override
  List<Object?> get props => [period];
}

class FetchPopularItems extends RestaurantAnalyticsEvent {
  final String period;

  const FetchPopularItems({required this.period});

  @override
  List<Object?> get props => [period];
}

class ExportAnalyticsReport extends RestaurantAnalyticsEvent {
  final String period;
  final String format; // 'pdf', 'excel', 'csv'

  const ExportAnalyticsReport({
    required this.period,
    this.format = 'pdf',
  });

  @override
  List<Object?> get props => [period, format];
}
