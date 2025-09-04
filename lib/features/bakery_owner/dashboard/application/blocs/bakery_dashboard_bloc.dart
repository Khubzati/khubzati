import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/bakery_owner/dashboard/data/services/bakery_dashboard_service.dart';

part 'bakery_dashboard_event.dart';
part 'bakery_dashboard_state.dart';

class BakeryDashboardBloc
    extends Bloc<BakeryDashboardEvent, BakeryDashboardState> {
  final BakeryDashboardService bakeryDashboardService;

  BakeryDashboardBloc({
    required this.bakeryDashboardService,
  }) : super(BakeryDashboardInitial()) {
    on<LoadBakeryDashboard>(_onLoadBakeryDashboard);
    on<FetchBakeryStats>(_onFetchBakeryStats);
    on<FetchRecentOrders>(_onFetchRecentOrders);
    on<FetchPopularProducts>(_onFetchPopularProducts);
    on<UpdateBakeryStatus>(_onUpdateBakeryStatus);
  }

  Future<void> _onLoadBakeryDashboard(
      LoadBakeryDashboard event, Emitter<BakeryDashboardState> emit) async {
    emit(BakeryDashboardLoading());
    try {
      // Fetch all required data concurrently
      final results = await Future.wait([
        bakeryDashboardService.getDashboardSummary(),
        bakeryDashboardService.getSalesStatistics(period: 'today'),
        bakeryDashboardService.getRecentOrders(limit: 10),
        bakeryDashboardService.getTopSellingProducts(limit: 5),
      ]);

      final bakeryInfo = results[0] as Map<String, dynamic>;
      final stats = results[1] as Map<String, dynamic>;
      final recentOrders = results[2] as List<Map<String, dynamic>>;
      final popularProducts = results[3] as List<Map<String, dynamic>>;

      // Assuming 'isOpen' status is part of the summary or profile info
      final isOpen = bakeryInfo['is_open'] ?? true;

      emit(BakeryDashboardLoaded(
        bakeryInfo: bakeryInfo,
        stats: stats,
        recentOrders: recentOrders,
        popularProducts: popularProducts,
        isOpen: isOpen,
        timeRange: 'today',
      ));
    } catch (e) {
      emit(BakeryDashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onFetchBakeryStats(
      FetchBakeryStats event, Emitter<BakeryDashboardState> emit) async {
    if (state is BakeryDashboardLoaded) {
      final currentState = state as BakeryDashboardLoaded;
      emit(BakeryStatsLoading(event.timeRange));

      try {
        // Fetch stats for the requested time range
        final stats = await bakeryDashboardService.getSalesStatistics(
            period: event.timeRange);

        emit(currentState.copyWith(
          stats: stats,
          timeRange: event.timeRange,
        ));
      } catch (e) {
        emit(BakeryDashboardError('Failed to fetch stats: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchRecentOrders(
      FetchRecentOrders event, Emitter<BakeryDashboardState> emit) async {
    if (state is BakeryDashboardLoaded) {
      final currentState = state as BakeryDashboardLoaded;
      // Could emit a specific loading state for orders, but for simplicity using the main state

      try {
        // Fetch recent orders
        final recentOrders =
            await bakeryDashboardService.getRecentOrders(limit: event.limit);

        emit(currentState.copyWith(
          recentOrders: recentOrders,
        ));
      } catch (e) {
        emit(BakeryDashboardError(
            'Failed to fetch recent orders: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchPopularProducts(
      FetchPopularProducts event, Emitter<BakeryDashboardState> emit) async {
    if (state is BakeryDashboardLoaded) {
      final currentState = state as BakeryDashboardLoaded;
      // Could emit a specific loading state for products, but for simplicity using the main state

      try {
        // Fetch popular products
        final popularProducts = await bakeryDashboardService
            .getTopSellingProducts(limit: event.limit);

        emit(currentState.copyWith(
          popularProducts: popularProducts,
        ));
      } catch (e) {
        emit(BakeryDashboardError(
            'Failed to fetch popular products: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateBakeryStatus(
      UpdateBakeryStatus event, Emitter<BakeryDashboardState> emit) async {
    if (state is BakeryDashboardLoaded) {
      final currentState = state as BakeryDashboardLoaded;
      emit(BakeryStatusUpdateInProgress());

      try {
        // In a real app, this would call a specific endpoint to update status
        // For now, we assume it's part of the profile update or a dedicated endpoint
        // await bakeryDashboardService.updateBakeryStatus(isOpen: event.isOpen);

        // Placeholder: simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        final message = event.isOpen
            ? 'Bakery is now open for orders'
            : 'Bakery is now closed';
        emit(BakeryStatusUpdateSuccess(isOpen: event.isOpen, message: message));

        // Update the main state
        emit(currentState.copyWith(isOpen: event.isOpen));
      } catch (e) {
        emit(BakeryDashboardError(
            'Failed to update bakery status: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }
}
