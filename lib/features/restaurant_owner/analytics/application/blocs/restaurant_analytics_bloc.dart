import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/analytics/data/services/restaurant_analytics_service.dart';

part 'restaurant_analytics_event.dart';
part 'restaurant_analytics_state.dart';

class RestaurantAnalyticsBloc
    extends Bloc<RestaurantAnalyticsEvent, RestaurantAnalyticsState> {
  final RestaurantAnalyticsService analyticsService;

  RestaurantAnalyticsBloc({
    required this.analyticsService,
  }) : super(RestaurantAnalyticsInitial()) {
    on<LoadRestaurantAnalytics>(_onLoadRestaurantAnalytics);
    on<FetchSalesOverview>(_onFetchSalesOverview);
    on<FetchOrderStatistics>(_onFetchOrderStatistics);
    on<FetchPopularItems>(_onFetchPopularItems);
    on<ExportAnalyticsReport>(_onExportAnalyticsReport);
  }

  Future<void> _onLoadRestaurantAnalytics(
    LoadRestaurantAnalytics event,
    Emitter<RestaurantAnalyticsState> emit,
  ) async {
    emit(RestaurantAnalyticsLoading());

    try {
      // Fetch all analytics data concurrently
      final results = await Future.wait([
        analyticsService.getSalesOverview(period: event.period),
        analyticsService.getOrderStatistics(period: event.period),
        analyticsService.getPopularItems(period: event.period),
      ]);

      final salesOverview = results[0] as Map<String, dynamic>;
      final orderStatistics = results[1] as Map<String, dynamic>;
      final popularItems = results[2] as List<Map<String, dynamic>>;

      emit(RestaurantAnalyticsLoaded(
        salesOverview: salesOverview,
        orderStatistics: orderStatistics,
        popularItems: popularItems,
        period: event.period,
      ));
    } catch (e) {
      emit(RestaurantAnalyticsError(
          'Failed to load analytics: ${e.toString()}'));
    }
  }

  Future<void> _onFetchSalesOverview(
    FetchSalesOverview event,
    Emitter<RestaurantAnalyticsState> emit,
  ) async {
    if (state is RestaurantAnalyticsLoaded) {
      final currentState = state as RestaurantAnalyticsLoaded;

      try {
        final salesOverview = await analyticsService.getSalesOverview(
          period: event.period,
        );

        emit(currentState.copyWith(
          salesOverview: salesOverview,
          period: event.period,
        ));
      } catch (e) {
        emit(RestaurantAnalyticsError(
            'Failed to fetch sales overview: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchOrderStatistics(
    FetchOrderStatistics event,
    Emitter<RestaurantAnalyticsState> emit,
  ) async {
    if (state is RestaurantAnalyticsLoaded) {
      final currentState = state as RestaurantAnalyticsLoaded;

      try {
        final orderStatistics = await analyticsService.getOrderStatistics(
          period: event.period,
        );

        emit(currentState.copyWith(
          orderStatistics: orderStatistics,
          period: event.period,
        ));
      } catch (e) {
        emit(RestaurantAnalyticsError(
            'Failed to fetch order statistics: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchPopularItems(
    FetchPopularItems event,
    Emitter<RestaurantAnalyticsState> emit,
  ) async {
    if (state is RestaurantAnalyticsLoaded) {
      final currentState = state as RestaurantAnalyticsLoaded;

      try {
        final popularItems = await analyticsService.getPopularItems(
          period: event.period,
        );

        emit(currentState.copyWith(
          popularItems: popularItems,
          period: event.period,
        ));
      } catch (e) {
        emit(RestaurantAnalyticsError(
            'Failed to fetch popular items: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onExportAnalyticsReport(
    ExportAnalyticsReport event,
    Emitter<RestaurantAnalyticsState> emit,
  ) async {
    try {
      emit(RestaurantAnalyticsExporting());

      final reportData = await analyticsService.exportAnalyticsReport(
        period: event.period,
        format: event.format,
      );

      emit(RestaurantAnalyticsExportSuccess(
        reportPath: reportData['file_path'],
        message: 'Report exported successfully',
      ));
    } catch (e) {
      emit(
          RestaurantAnalyticsError('Failed to export report: ${e.toString()}'));
    }
  }
}
